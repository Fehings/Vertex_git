function [NeuronModel, SynModel, InModel, S, RecVar,wArr] = ...
    simulateParallelMultiregion(TP, NP, SS, RS, ...
    IDMap, NeuronModel, SynModel, InModel, RecVar, lineSourceModCell, synArr, wArr, synMap, iterator, simStep, S, revSynArr, neuronInGroup)
%Parallel version of simulate.

outputDirectory = RS.saveDir;

nIntSize = 'uint32';
tIntSize = 'uint16';

%excitatory = [NP.isExcitatory];
groupComparts = [NP.numCompartments];

N = TP.N;
numInGroup = TP.numInGroupInLab;


[cpexLoopTotal, partnerLab] = cpexGetExchangePartners();

% set field inputs
ns = iterator.nsaves;

spmd
    
    %Get the neuron ids processed in this lab
    subsetInLab = find(SS.neuronInLab==labindex());

    
    recordIntra = RecVar.recordIntra;
    recordI_syn = RecVar.recordI_syn;
    recordFac_syn = RecVar.recordFac_syn;
    recordWeights = RecVar.recordWeights;
    recordWeightsArr = RecVar.recordWeightsArr;
    comCount = SS.minDelaySteps;
    % vars to keep track of where we are in recording buffers

    receivedSpikes = cell(numlabs, 2);

    
    if S.spikeLoad
        fName = sprintf('%sRecordings%d_.mat', inputDirectory, iterator.numSaves);
        loadedSpikes = pload(fName);
    end
    
    


    % simulation loop
    labBarrier();

     
        %Update weight recording
        if simStep == RS.samplingSteps(iterator.sampleStepCounter)
            if recordWeights
                RecVar = updateWeightsRecording(RecVar,iterator.sampleStepCounter,wArr,SS);
            end
        end
        if recordWeightsArr
    
            if iterator.weightsArrcount <= length(RS.weights_arr) && simStep == RS.weights_arr(iterator.weightsArrcount)
                disp('recording weights')
                disp(['simstep: ' num2str(simStep)]);
                disp(['rectime: ' num2str(RS.weights_arr(iterator.weightsArrcount))]);
                RecVar.WeightArrRec{iterator.weightsArrcount} = wArr;
                iterator.weightsArrcount = iterator.weightsArrcount+1;
            end
        end
        
        for iGroup = 1:TP.numGroups
            
            
            [NeuronModel, SynModel, InModel] = ...
                groupUpdateSchedule(NP,SS,NeuronModel,SynModel,InModel,iGroup);
            
            
            S = addGroupSpikesToSpikeList(NeuronModel,IDMap,S,iGroup,comCount);
            
            % store group-collected recorded variables for membrane potential:
            if simStep == RS.samplingSteps(iterator.sampleStepCounter)
                if recordIntra
                    RecVar = ...
                        updateIntraRecording(NeuronModel,RecVar,iGroup,iterator.recTimeCounter);
                end
                
                % for synaptic currents:
                if recordI_syn
                    RecVar = ...
                        updateI_synRecording(SynModel,RecVar,iGroup,iterator.recTimeCounter);
                end
                
                % for LFP:
                if RS.LFP && NP(iGroup).numCompartments ~= 1
                    RecVar = ...
                        updateLFPRecording(RS,NeuronModel,RecVar,lineSourceModCell,iGroup,iterator.recTimeCounter);
                end
                
                if recordFac_syn
                    RecVar = updateFac_synRecording(SynModel,RecVar,iGroup,iterator.recTimeCounter,synMap,TP);
                end
                
            end
        end % for each group
        
        % increment the recording sample pointer
        if simStep == RS.samplingSteps(iterator.sampleStepCounter)
            iterator.recTimeCounter = iterator.recTimeCounter + 1;
            
            % Only increment sampleStepCounter if this isn't the last scheduled
            % recording step
            if iterator.sampleStepCounter < length(RS.samplingSteps)
                iterator.sampleStepCounter = iterator.sampleStepCounter + 1;
            end
        end
        
        % communicate spikes
        if iterator.comCount == 1
            % update neuron event queues
            % first process own spikes
            if ~S.spikeLoad
                if S.spikeCount ~= 0
                    receivedSpikes(labindex(), :) = {S.spikes(1:S.spikeCount), ...
                        S.spikeStep(1:S.spikeCount)};
                else
                    receivedSpikes(labindex(), :) = {zeros(0, nIntSize), ...
                        zeros(0, tIntSize)};
                end
            else
                S.spikeLoad
                tt = loadedSpikes.data.spikeRecording{iterator.spikeRecCounter};
                toKeep = ismember(tt{1}, S.spikeLoad);
                tt{1} = tt{1}(toKeep);
                tt{2} = tt{2}(toKeep);
                if S.spikeCount ~= 0
                    tt{1} = [tt{1}; S.spikes(1:S.spikeCount)];
                    tt{2} = [tt{2}; S.spikeStep(1:S.spikeCount)];
                end
                if isempty(tt)
                    tt = {zeros(0, nIntSize), zeros(0, tIntSize)};
                end
                receivedSpikes(labindex(), :) = tt;
            end
            
            for iLab = 1:cpexLoopTotal
                if partnerLab(iLab) == -1
                    %no partner
                else
                    % exchange spikes with partner iLab
                    receivedSpikes(partnerLab(iLab), :) = ...
                        labSendReceive(partnerLab(iLab), partnerLab(iLab), ...
                        receivedSpikes(labindex(), :));
                end
                labBarrier();
            end % for each pairwise exchange
            
            % Record the spikes
            RecVar.spikeRecording{iterator.spikeRecCounter} = ...
                receivedSpikes(labindex(), :);
            iterator.spikeRecCounter = iterator.spikeRecCounter + 1;
            allSpike = cell2mat(receivedSpikes(:, 1));
            allSpikeTimes = cell2mat(receivedSpikes(:, 2));
            
            
            % Go through spikes and insert events into relevant buffers
            % mat3d(ii+((jj-1)*x)+((kk-1)*y)*x))
            for iSpk = 1:length(allSpike)
                % Get which groups the targets are in
                postInGroup = neuronInGroup(synArr{allSpike(iSpk), 1});
                for iPostGroup = 1:TP.numGroups
                    iSpkSynGroup = synMap{iPostGroup}(neuronInGroup(allSpike(iSpk)));
                    if ~isempty(SynModel{iPostGroup, iSpkSynGroup})
                        tBufferLoc = synArr{allSpike(iSpk), 3} + ...
                            SynModel{iPostGroup, iSpkSynGroup}.bufferCount - allSpikeTimes(iSpk);
                        tBufferLoc(tBufferLoc > bufferLength) = ...
                            tBufferLoc(tBufferLoc > bufferLength) - bufferLength;
                        inGroup = postInGroup == iPostGroup;

                        inGroupInLab = subsetInLab(inGroup);
                        
                        if sum(inGroup ~= 0)
                            %
                            ind = ...
                                uint32(IDMap.modelIDToCellIDMap(synArr{allSpike(iSpk), 1}(inGroup), 1)') + ...
                                (uint32(synArr{allSpike(iSpk), 2}(inGroup)) - ...
                                uint32(1)) .* ...
                                uint32(numInGroup(iPostGroup, labindex())) + ...
                                (uint32(tBufferLoc(inGroup)) - ...
                                uint32(1)) .* ...
                                uint32(groupComparts(iPostGroup)) .* ...
                                uint32(numInGroup(iPostGroup, labindex()));
                            if isa(SynModel{iPostGroup, iSpkSynGroup}, 'SynapseModel_g_stp')
                                %synapse model function updates the stp variables and adds
                                %spikes to the buffers.
                                %we pass the id of the presynaptic neuron: allSpike(iSpk)
                                %Synapse model stores stp vars for each pre to post
                                %connection. iSpkSynGroup is the presynaptic group.
                                %on each lab we call bufferIncomingSpikes
                                %to process each spike as arrives at its
                                %postsynaptic neurons. 
                               % disp(['updating neuron: ' num2str(allSpike(iSpk))]);
                               
                                relative_preID = allSpike(iSpk) - TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk)));
                                 %disp(['at relative position: ' num2str(relative_preID)]);
                                 %disp(['Synapse F : ' num2str(SynModel{iPostGroup, iSpkSynGroup}.F(relative_preID))]);
                                bufferIncomingSpikes( ...
                                    SynModel{iPostGroup, iSpkSynGroup}, ...
                                    ind, wArr{allSpike(iSpk)}(inGroup),relative_preID);
                                %disp(['Synapse F : ' num2str(SynModel{iPostGroup, iSpkSynGroup}.F(relative_preID))]);
                            else
                                bufferIncomingSpikes(SynModel{iPostGroup, iSpkSynGroup}, ind, ...
                                    wArr{allSpike(iSpk)}(inGroup));
                            end
                            %Update synapse vars on presynaptic side
                            %Each lab only has the weights of synapses onto
                            %neurons in its group
                            if isa(SynModel{iPostGroup, iSpkSynGroup}, 'SynapseModel_g_stdp')
                                %process spike as presynaptic spike, updating weights for
                                %post synaptic neurons in this synapse group.
                                %passing weights and group relative ids of post synaptic neurons.
                                
                                %update Apre for synapses of spiking neuron
                                %synapse model has Apre for all presynaptic neurons, Apost only for those on this lab
                                %
                                
                                    
                                    relativeSpikeID = allSpike(iSpk) - TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk)));
                                    processAsPreSynSpike(SynModel{iPostGroup, iSpkSynGroup},relativeSpikeID );

                                
                                %for all spikes on all labs
                                   
                                    % get postsynaptic neurons in this lab
                                    % and this group
                                    %translate their total ID to the one
                                    %relative to their lab/group
                                    relativepostneuronIDs = IDMap.modelIDToCellIDMap(synArr{allSpike(iSpk), 1}(inGroup), 1)';
                                    %update weights of connections from
                                    %spiking neuron to all in this
                                    %labgroup, only depedent on the post
                                    %synaptic state
                                    wArr{allSpike(iSpk)}(inGroup) = updateweightsaspresynspike(SynModel{iPostGroup, iSpkSynGroup}, wArr{allSpike(iSpk)}(inGroup),relativepostneuronIDs );
                                    %Communicate weight change with other
                                    %labs
                                    %Receive weight change from other labs
                                    
                            end
                        end
                    end
                end
                %if we are using stdp on any synapses, then update weights on
                %connections presynaptic to the spiking neuron.
                labBarrier();
                if stdp

                    %get all neurons presynaptic to the spiking neuron
                    % in this lab
                    presynaptic = revSynArr{allSpike(iSpk),1};
                    postsynapticlocation = revSynArr{allSpike(iSpk),2};
                    preInGroup = neuronInGroup(presynaptic);
                    %for each group get neurons presynaptic to the firing neuron
                    for iPreGroup = 1:TP.numGroups
                        
                        %if the synapse between the spiking neuron and this
                        %pre synaptic group has stdp then 
                        
                         postGroup = neuronInGroup(allSpike(iSpk));
                         iSpkSynGroup = synMap{postGroup}(iPreGroup);
                         
                        if isa(SynModel{postGroup,iSpkSynGroup}, 'SynapseModel_g_stdp')
                            % if the spiking neuron is on this lab 
                            % then it is our responsibility to update its
                            % Apost value - it is a postsynaptic spike on
                            % the synapse currently being processed. The
                            % Apost value for neurons on other labs will be
                            % part of a synapse model hosted there. Synapse
                            % models split up and exist individually on
                            % each lab.
                          if ismember(allSpike(iSpk), subsetInLab)
                            relativeind =  IDMap.modelIDToCellIDMap(allSpike(iSpk));
                            processAsPostSynSpike(SynModel{postGroup, iSpkSynGroup},relativeind);
                          
                            %logical array specifying which presynaptic
                            %neurons are in the current group
                            inGroup = preInGroup == iPreGroup;
                            
                            %inGroupInLab = subsetInLab(inGroup);
                            %if there are presynaptic neurons in current
                            %group
                            if sum(inGroup ~= 0)

                                
                                
                                presyningroup = presynaptic(inGroup);
                                %ingroupinlab = ismember(presyningroup,subsetInLab);
                                %presyningroup = presyningroup(ingroupinlab);
                                postsynlocingroup = postsynapticlocation(inGroup);
                                %postsynlocingroup = postsynlocingroup(ingroupinlab);
                                
                                %IDs of neurons in presynaptic group in
                                %this lab
                                %relativepreID = IDMap.modelIDToCellIDMap(presyningroup);
                                relativepreID = presyningroup - TP.groupBoundaryIDArr(iPreGroup);
                                
                                %weights for connections to neurons presynaptic to
                                %the spiking neuron
                                wMat = zeros(length(presyningroup),1);

                                for synInd = 1:length(presyningroup)

                                    wMat(synInd) = wArr{presyningroup(synInd)}(postsynlocingroup(synInd));
                                end
                                
                                wMat = updateweightsaspostsynspike(SynModel{postGroup,iSpkSynGroup},...
                                    wMat,relativepreID,neuronInGroup(presyningroup(synInd)));
                                
                                for synInd = 1:length(presyningroup)
                                    wArr{presyningroup(synInd)}(postsynlocingroup(synInd)) = wMat(synInd);
                                end
                                
                                
                            end
                          end
                        end
                    end
                end
            end
            
            S.spikeCount = 0;
            iterator.comCount = SS.minDelaySteps;
        else
            iterator.comCount = comCount - 1;
        end
        
        if labindex() == 1 && mod(simStep * SS.timeStep, 5) == 0
            disp(num2str(simStep * SS.timeStep));
                             
        end
        
        % write recorded variables to disk
        if simStep == RS.dataWriteSteps(iterator.numSaves)
            if iterator.spikeRecCounter-1 ~= length(RecVar.spikeRecording)
                RecVar.spikeRecording{end} = {[], []};
            end
            iterator.recTimeCounter = 1;
            fName = sprintf('Recordings%d_.mat', iterator.numSaves+ns);
            saveDataSPMD(outputDirectory, fName, RecVar);
            
            % Only imcrement numSaves if this isn't the last scheduled save point.
            if iterator.numSaves < length(RS.dataWriteSteps)
                iterator.numSaves = iterator.numSaves + 1;
            end
            
            iterator.spikeRecCounter = 1;
            
            if S.spikeLoad
                if iterator.numSaves <= length(RS.dataWriteSteps)
                    fName = sprintf('%sRecordings%d_.mat',inputDirectory,iterator.numSaves+ns);
                    loadedSpikes = pload(fName);
                    disp(size(loadedSpikes.data.spikeRecording));
                end
            end
        end
    end % end of simulation time loop
    
    if isfield(RS,'LFPoffline') && RS.LFPoffline
        saveDataSPMD(outputDirectory, 'LineSourceConsts_.mat', lineSourceModCell);
    end
    %numSaves = numSaves - 1; % - no longer need this as numSaves is not
    %updated beyond the final scheduled save point

end % spmd