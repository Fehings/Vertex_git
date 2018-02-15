function [NeuronModel, SynModel, InModel, numSaves, RecVar] = ...
    simulateParallelOpt(TP, NP, SS, RS, ...
    IDMap, NeuronModel, SynModel, InModel, RecVar, lineSourceModCell, synArr, wArr, synMap, nsaves,paraStimParam)
%Parallel version of simulate.

outputDirectory = RS.saveDir;

nIntSize = 'uint32';
tIntSize = 'uint16';

%excitatory = [NP.isExcitatory];
groupComparts = [NP.numCompartments];

N = TP.N;
numInGroup = TP.numInGroupInLab;
neuronInGroup = createGroupsFromBoundaries(TP.groupBoundaryIDArr);
bufferLength = SS.maxDelaySteps;
simulationSteps = round(SS.simulationTime / SS.timeStep);



if isfield(SS,'spikeLoad')
    S.spikeLoad = SS.spikeLoad;
else
    S.spikeLoad = false;
end

if S.spikeLoad
    inputDirectory = SS.spikeLoadDir;
    if ~strcmpi(inputDirectory(end), '/')
        inputDirectory = [inputDirectory '/'];
    end
end

[cpexLoopTotal, partnerLab] = cpexGetExchangePartners();

if nargin == 13
    ns = 0;
    paraStimParam = [];
else
    ns = nsaves;
end
% set field inputs

stdp = SS.stdp;

if stdp
    disp('Using stdp, so calculating postsynaptic to presynaptic map');
    spmd
        posttoprearr = reverseSynArr(synArr);
        disp('Map calculated');
    end
        revSynArr = posttoprearr{1};
        for iLab = 1:length(posttoprearr)
            currLabSynArr = posttoprearr{iLab};
            revSynArr(~cellfun(@isempty,currLabSynArr(:,1)),1) = currLabSynArr(~cellfun(@isempty,currLabSynArr(:,1)),1);
            revSynArr(~cellfun(@isempty,currLabSynArr(:,2)),2) = currLabSynArr(~cellfun(@isempty,currLabSynArr(:,2)),2);
        end
end

spmd
    
    %Get the neuron ids processed in this lab
    subsetInLab = find(SS.neuronInLab==labindex());
    
    % x = compartments{1:10,labindex()}
    %if we are applying an electric field stimulus
    %     if SS.ef_stimulation
    %         % get compartments locations in suitable vectorised form
    %         % for each neuron group
    %         for iGroup = 1:TP.numGroups
    %             %Get neuron ids of neurons in this group and in this lab
    %             ingroupinlab = subsetInLab(neuronInGroup(subsetInLab)==iGroup);
    %              x = {compartments{ingroupinlab,1}};
    %              y = {compartments{ingroupinlab,2}};
    %              z = {compartments{ingroupinlab,3}};
    %             [StimParams.compartmentlocations{iGroup,1}, StimParams.compartmentlocations{iGroup,2}] = ...
    %                 convertcompartmentlocations(x,y,z);
    %         end
    %
    %         %Calculate the activation function for each compartment
    %         %Can be called on each iteration if the input field is time varying
    %         StimParams.activation = getExtracellularInput(TP, StimParams,1,NeuronModel,NP);
    %
    %     end
    %
    %      %if we are applying an focussed ultrasound
    %     if SS.fu_stimulation
    %         %Get compartments in suitable  vectorised form
    %         for iGroup = 1:TP.numGroups
    %             ingroupinlab = subsetInLab(neuronInGroup(subsetInLab)==iGroup);
    %             [StimParams.compartmentlocations{iGroup,1}, StimParams.compartmentlocations{iGroup,2}] = ...
    %                 convertcompartmentlocations({TP.compartmentlocations{ingroupinlab,1}},...
    %                 {TP.compartmentlocations{ingroupinlab,2}},{TP.compartmentlocations{ingroupinlab,3}});
    %         end
    %         %Calculate the ultrasound value function for each compartment
    %         %Can be called on each iteration if the input field is time varying
    %         StimParams.ultrasound = getUltraSoundAtCompartments(TP, StimParams,0);
    %     end
    
    
    
    
    
    recordIntra = RecVar.recordIntra;
    recordI_syn = RecVar.recordI_syn;
    recordFac_syn = RecVar.recordFac_syn;
    recordWeights = RecVar.recordWeights;
    recordWeightsArr = RecVar.recordWeightsArr;
    recordstdpvars = RecVar.recordstdpvars;
    weightsArrcount = 1;
    comCount = SS.minDelaySteps;
    % vars to keep track of where we are in recording buffers:
    
    recTimeCounter = 1;
    sampleStepCounter = 1;
    spikeRecCounter = 1;
    
    % vars to keep track of spikes
    S.spikes = zeros(N * SS.minDelaySteps, 1, nIntSize);
    S.spikeStep = zeros(N * SS.minDelaySteps, 1, tIntSize);
    receivedSpikes = cell(numlabs, 2);
    S.spikeCount = zeros(1, 1, nIntSize);
    numSaves = 1;
    
    if S.spikeLoad
        fName = sprintf('%sRecordings%d_.mat', inputDirectory, numSaves);
        loadedSpikes = pload(fName);
    end
    
    


    % simulation loop
    labBarrier();
    
    stimcount = 1;
    timeStimStep = 1;
    
    for simStep = 1:simulationSteps
        
%     if SS.freezeWeights
%         if simStep * SS.timeStep > SS.freezetime
%             disp('freezing weights')
%             for iGroup = 1:TP.numGroups
%                 for synGroup = 1:length(SynModel(iGroup,:))
%                     if isa(SynModel{iGroup,synGroup}, 'SynapseModel_g_stdp')
%                         SynModel{iGroup,synGroup}.postRate = 0;
%                         SynModel{iGroup,synGroup}.preRate = 0;
%                     end
%                 end
%             end
%             SS.freezeWeights = false;
%         end
%     end
                        
            
        %%%%
        % Stimulation code block
        % Turns stimulation dynamics on or off for neuron groups
        %%%%
        if isfield(TP, 'StimulationField')
            current_time = simStep * SS.timeStep; % Get current time in ms
            %if the current time is greater than the current stimulation
            %time start time then turn on.
            
            if current_time > TP.StimulationOn(stimcount) && current_time < TP.StimulationOff(stimcount)
                %disp('Stimulation on')
                for iGroup = 1:TP.numGroups
                    if  ~NeuronModel{iGroup}.incorporate_vext
                        stimulationOn(NeuronModel{iGroup});
                    end
                    % For time varying stimulation, step through the time
                    % dimension of the vext matrix for each simStep where
                    % stimulation is active. The vext matrix should have
                    % been previously interpolated in runSimulation.
                    if isa(TP.StimulationField, 'pde.TimeDependentResults')
                        setVext(NeuronModel{iGroup},paraStimParam(iGroup).V_ext_mat(:,:,timeStimStep));
                    elseif isfield(TP,'tRNS')
                        setVext(NeuronModel{iGroup},NeuronModel{iGroup}.v_ext*TP.tRNS);
                    end
                end
                
                    if isfield(TP,'tRNS')
                        TP.tRNS=wgn(1,1,0);
                    end
                
                timeStimStep = timeStimStep+1;
                % reset timeStimStep if it gets passed the length of the
                % time dimension in the stimulation field, this will loop
                % back to the beginning of the time varying stimulation.
                if timeStimStep > size(TP.StimulationField.NodalSolution,2)
                    timeStimStep = 1;
                end
                % otherwise if time is greater than current of time turn
                % off
           elseif current_time >= TP.StimulationOff(stimcount)
               disp('Stimulation off')
                for iGroup = 1:TP.numGroups
                    if  NeuronModel{iGroup}.incorporate_vext
                        stimulationOff(NeuronModel{iGroup});
                    end
                    % and move stimulation times index on if we have not
                    % reached the final stimulation time window
                end
                
                if stimcount < length(TP.StimulationOn)   
                    stimcount = stimcount+1;
                end
                
                disp(['stimcount: ' num2str(stimcount)]);
            end % if current time is between time on and off do nothing.
            
        end
        
        %Update weight recording
        if simStep == RS.samplingSteps(sampleStepCounter)
            if recordWeights
                RecVar = updateWeightsRecording(RecVar,recTimeCounter,wArr,SS);
            end
        end
        if recordWeightsArr
    
            if weightsArrcount <= length(RS.weights_arr) && simStep == RS.weights_arr(weightsArrcount)
                disp('recording weights')
                disp(['simstep: ' num2str(simStep)]);
                disp(['rectime: ' num2str(RS.weights_arr(weightsArrcount))]);
                if sum(synArr{3}==4669) >0 
                    disp(['synapse strength between 3 and 4669  is: ' num2str(wArr{3}(synArr{3}==4669))]);
                end
                
                RecVar.WeightArrRec{weightsArrcount} = wArr;
                weightsArrcount = weightsArrcount+1;
            end
        end
        
        for iGroup = 1:TP.numGroups
            
            
            [NeuronModel, SynModel, InModel] = ...
                groupUpdateSchedule(NP,SS,NeuronModel,SynModel,InModel,iGroup);
            
            
            S = addGroupSpikesToSpikeList(NeuronModel,IDMap,S,iGroup,comCount);
            
            % store group-collected recorded variables for membrane potential:
            if simStep == RS.samplingSteps(sampleStepCounter)
                if recordIntra
                    RecVar = ...
                        updateIntraRecording(NeuronModel,RecVar,iGroup,recTimeCounter);
                end
                
                % for synaptic currents:
                if recordI_syn
                    RecVar = ...
                        updateI_synRecording(SynModel,RecVar,iGroup,recTimeCounter);
                end
                
                % for LFP:
                if RS.LFP && NP(iGroup).numCompartments ~= 1
                    RecVar = ...
                        updateLFPRecording(RS,NeuronModel,RecVar,lineSourceModCell,iGroup,recTimeCounter);
                end
                
                if recordFac_syn
                    RecVar = updateFac_synRecording(SynModel,RecVar,iGroup,recTimeCounter,synMap,neuronInGroup,TP);
                end
                
                if recordstdpvars
                    RecVar = updateSTDPVarsRecording(SynModel,RecVar,iGroup,recTimeCounter,synMap,neuronInGroup,TP);
                end
                
            end
        end % for each group
        
        % increment the recording sample pointer
        if simStep == RS.samplingSteps(sampleStepCounter)
            recTimeCounter = recTimeCounter + 1;
            
            % Only increment sampleStepCounter if this isn't the last scheduled
            % recording step
            if sampleStepCounter < length(RS.samplingSteps)
                sampleStepCounter = sampleStepCounter + 1;
            end
        end
        
        % communicate spikes
        if comCount == 1
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
                tt = loadedSpikes.data.spikeRecording{spikeRecCounter};
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
            RecVar.spikeRecording{spikeRecCounter} = ...
                receivedSpikes(labindex(), :);
            spikeRecCounter = spikeRecCounter + 1;
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

                                relative_preID = allSpike(iSpk) - TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk)));
                                %postsynaptic neurons. 

%                                 if relative_preID == 279 && neuronInGroup(allSpike(iSpk)) == 3
%                                     disp(['spike id: ' num2str(allSpike(iSpk))]);
%                                     disp(['iSpkSynGroup: ' num2str(iSpkSynGroup)]);
%                                     disp(['iPostGroup: ' num2str(iPostGroup)]);
% 
%                                     disp(getSTPVars(SynModel{iPostGroup, iSpkSynGroup},relative_preID,neuronInGroup(allSpike(iSpk))))
%                                 end
                                
                                SynModel{iPostGroup, iSpkSynGroup} = bufferIncomingSpikes( ...
                                    SynModel{iPostGroup, iSpkSynGroup}, ...
                                    ind, wArr{allSpike(iSpk)}(inGroup),relative_preID,neuronInGroup(allSpike(iSpk)));
                                
%                                 if relative_preID == 279 && neuronInGroup(allSpike(iSpk)) == 3
%                                     disp(getSTPVars(SynModel{iPostGroup, iSpkSynGroup},relative_preID,neuronInGroup(allSpike(iSpk))))
% 
%                                 end
                                    
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
                                    processAsPreSynSpike(SynModel{iPostGroup, iSpkSynGroup},relativeSpikeID,neuronInGroup(allSpike(iSpk)) );

                                
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
                     postGroup = neuronInGroup(allSpike(iSpk));
                     processed = [];
                    %for each group get neurons presynaptic to the firing neuron
                    for iPreGroup = 1:TP.numGroups
                        
                        %if the synapse between the spiking neuron and this
                        %pre synaptic group has stdp then 
                        
                        

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
                            if ~ismember(iSpkSynGroup, processed)
                                processAsPostSynSpike(SynModel{postGroup, iSpkSynGroup},relativeind);
                                processed = [processed iSpkSynGroup];
                            end
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
                                
                                %Absolute IDs of neurons in presynaptic group 
                                %relativepreID = IDMap.modelIDToCellIDMap(presyningroup);
                                relativepreID = presyningroup - TP.groupBoundaryIDArr(iPreGroup);

                                %weights for connections to neurons presynaptic to
                                %the spiking neuron
                                wMat = zeros(length(presyningroup),1);

                                for synInd = 1:length(presyningroup)

                                    wMat(synInd) = wArr{presyningroup(synInd)}(postsynlocingroup(synInd));
                                end
                                
                                wMat = updateweightsaspostsynspike(SynModel{postGroup,iSpkSynGroup},...
                                    wMat,relativepreID, neuronInGroup(presyningroup(synInd)));
                                
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
            comCount = SS.minDelaySteps;
        else
            comCount = comCount - 1;
        end
        
        if labindex() == 1 && mod(simStep * SS.timeStep, 5) == 0
            disp(num2str(simStep * SS.timeStep));
                             
        end
        
        % write recorded variables to disk
        if simStep == RS.dataWriteSteps(numSaves)
            if spikeRecCounter-1 ~= length(RecVar.spikeRecording)
                RecVar.spikeRecording{end} = {[], []};
            end
            recTimeCounter = 1;
            fName = sprintf('Recordings%d_.mat', numSaves+ns);
            saveDataSPMD(outputDirectory, fName, RecVar);
            
            % Only imcrement numSaves if this isn't the last scheduled save point.
            if numSaves < length(RS.dataWriteSteps)
                numSaves = numSaves + 1;
            end
            
            spikeRecCounter = 1;
            
            if S.spikeLoad
                if numSaves <= length(RS.dataWriteSteps)
                    fName = sprintf('%sRecordings%d_.mat',inputDirectory,numSaves+ns);
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