function [NeuronModel, SynModel, InModel, iterator,S,RecVar,wArr] = simulateMultiregional(TP, NP, SS, RS, S, iterator, simStep, revSynArr, IDMap, ...
    NeuronModel, SynModel, InModel, RecVar, neuronInGroup, lineSourceModCell, synArr, wArr, synMap,rgn)

recordIntra = RecVar.recordIntra;
recordI_syn = RecVar.recordI_syn;
recordstp_syn = RecVar.recordstp_syn;
recordWeights = RecVar.recordWeights;
recordWeightsArr = RecVar.recordWeightsArr;
nIntSize = 'uint32';
tIntSize = 'uint16';
outputDirectory = RS.saveDir;

%Update weight recording
if recordWeights
    if simStep == RS.samplingSteps(iterator.sampleStepCounter)
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
       groupUpdateSchedule(NP,TP,SS,NeuronModel,SynModel,InModel,iGroup,synArr,wArr, IDMap, neuronInGroup);
    
    S = addGroupSpikesToSpikeList(NeuronModel,IDMap,S,iGroup,iterator.comCount);
    
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
        
        if recordstp_syn
            RecVar = updateFac_synRecording(SynModel,RecVar,iGroup,iterator.recTimeCounter,synMap,TP);
        end
        
        
    end
   
    if isfield(RS,'LFP_janrit')
            RecVar = ...
                updateLFPRecording(RS,NeuronModel,RecVar,lineSourceModCell,iGroup,iterator.recTimeCounter);
           
    end

   
end % for each group

% increment the recording sample counter
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
    if ~S.spikeLoad
        if S.spikeCount ~= 0
            allSpike = S.spikes(1:S.spikeCount);
            allSpikeTimes = S.spikeStep(1:S.spikeCount);
        else
            allSpike = zeros(0, nIntSize);
            allSpikeTimes = zeros(0, tIntSize);
        end
    else
        tt = iterator.loadedSpikes.(dataFieldName{1}).spikeRecording{iterator.spikeRecCounter};
        toKeep = ismember(tt{1}, S.spikeLoad);
        aS = tt{1}(toKeep);
        aST = tt{2}(toKeep);
        if S.spikeCount ~= 0
            allSpike = [aS; S.spikes(1:S.spikeCount)];
            allSpikeTimes = [aST; S.spikeStep(1:S.spikeCount)];
        else
            allSpike = aS;
            allSpikeTimes = aST;
        end
        if isempty(allSpike)
            allSpike = zeros(0, nIntSize);
            allSpikeTimes = zeros(0, tIntSize);
        end
    end
    
    % Record the spikes
    RecVar.spikeRecording{iterator.spikeRecCounter} = {allSpike, allSpikeTimes};
    iterator.spikeRecCounter = iterator.spikeRecCounter + 1;
    
    % Go through spikes and insert events into relevant buffers
    % mat3d(ii+((jj-1)*x)+((kk-1)*y)*x))
    for iSpk = 1:length(allSpike)
        % Get which groups the targets are in
        postInGroup = neuronInGroup(synArr{allSpike(iSpk), 1});
        % Eac
        for iPostGroup = 1:TP.numGroups
            iSpkSynGroup = synMap{iPostGroup}(neuronInGroup(allSpike(iSpk)));
            if ~isempty(SynModel{iPostGroup, iSpkSynGroup})
                % Adjust time indeces according to circular buffer index
                % and according the the delay speicifc to the synapse type,
                % specified by: synArr{allSpike(iSpk), 3}
                tBufferLoc = synArr{allSpike(iSpk), 3} + ...
                    SynModel{iPostGroup, iSpkSynGroup}.bufferCount - allSpikeTimes(iSpk);
                tBufferLoc(tBufferLoc > iterator.bufferLength) = ...
                    tBufferLoc(tBufferLoc > iterator.bufferLength) - iterator.bufferLength;
                inGroup = postInGroup == iPostGroup;
                if sum(inGroup ~= 0)
                    %creates the index (reduced from 3 dimensions to single
                    %dimension) for the eventbuffer array which holds a position
                    %for each compartment at each time in the buffer for each
                    %post synaptic neuron. The time specified by tBufferLoc
                    %determines the time at which the spike should arrive
                    %(acoording to the synaptic delay and when it was generated).
                    ind = ...
                        uint32(IDMap.modelIDToCellIDMap(synArr{allSpike(iSpk), 1}(inGroup), 1)') + ...
                        (uint32(synArr{allSpike(iSpk), 2}(inGroup)) - ...
                        uint32(1)) .* ...
                        uint32(iterator.numInGroup(iPostGroup)) + ...
                        (uint32(tBufferLoc(inGroup)) - ...
                        uint32(1)) .* ...
                        uint32(iterator.groupComparts(iPostGroup)) .* ...
                        uint32(iterator.numInGroup(iPostGroup));
                    if isa(SynModel{iPostGroup, iSpkSynGroup}, 'STPModel')
                        %synapse model function updates the stp variables and adds
                        %spikes to the buffers.
                        %we pass the id of the presynaptic neuron: allSpike(iSpk)
                        %Synapse model stores stp vars for each pre to post
                        %connection. iSpkSynGroup is synapsetype not the
                        %presynaptic group but the index of the synapse group.
                        relative_preID = IDMap.modelIDToCellIDMap(allSpike(iSpk));
                        
                        bufferIncomingSpikes( ...
                            SynModel{iPostGroup, iSpkSynGroup}, ...
                            ind, wArr{allSpike(iSpk)}(inGroup),relative_preID);
                    else
                        bufferIncomingSpikes( ...
                            SynModel{iPostGroup, iSpkSynGroup}, ...
                            ind, wArr{allSpike(iSpk)}(inGroup));
                    end
                    if isa(SynModel{iPostGroup, iSpkSynGroup}, 'STDPModel_delays')
                        relativeSpikeID = allSpike(iSpk) - TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk)));
                        relativepostneuronIDs = IDMap.modelIDToCellIDMap(synArr{allSpike(iSpk), 1}(inGroup), 1)';
                        processAsPreSynSpike(SynModel{iPostGroup, iSpkSynGroup},relativeSpikeID,neuronInGroup(allSpike(iSpk)),relativepostneuronIDs,tBufferLoc(inGroup) );
                        
                    elseif isa(SynModel{iPostGroup, iSpkSynGroup}, 'STDPModel')
                        %process spike as presynaptic spike, updating weights for
                        %post synaptic neurons in this synapse group.
                        %passing weights and group relative ids of post synaptic neurons.
                        processAsPreSynSpike(SynModel{iPostGroup, iSpkSynGroup}, allSpike(iSpk) -TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk))),neuronInGroup(allSpike(iSpk)));
                        relativepostneuronIDs = IDMap.modelIDToCellIDMap(synArr{allSpike(iSpk), 1}(inGroup), 1)';
                        wArr{allSpike(iSpk)}(inGroup) = updateweightsaspresynspike(SynModel{iPostGroup, iSpkSynGroup}, wArr{allSpike(iSpk)}(inGroup),relativepostneuronIDs);
                    end
                end
            end
            
        end
        
        
        %if we are using stdp on any synapses, then update weights on
        %connections presynaptic to the spiking neuron.
        
      
      if iterator.stdp
          %get all neurons presynaptic to the spiking neuron
          presynaptic = revSynArr{allSpike(iSpk),1};
          postsynapticlocation = revSynArr{allSpike(iSpk),2};
          preInGroup = neuronInGroup(presynaptic);
          %for each group get neurons presynaptic to the firing neuron
          for iPreGroup = 1:TP.numGroups
              inGroup = preInGroup == iPreGroup;
              if sum(inGroup ~= 0)
                  
                  postGroup = neuronInGroup(allSpike(iSpk));
                  iSpkSynGroup = synMap{postGroup}(iPreGroup);

                  if isa(SynModel{postGroup,iSpkSynGroup}, 'STDPModel')
                      
                      relativeind = allSpike(iSpk) -TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk)));
                      processAsPostSynSpike(SynModel{postGroup,iSpkSynGroup},relativeind);
                      %if the synapses from the preSynaptic group to the
                      %spiking group have stdp on them

                      %The neurons presynatpic to the one just fired and in
                      %the group currently being processed
                      presyningroup = presynaptic(inGroup);
                      
                      

                      postsynlocingroup = postsynapticlocation(inGroup);
                      %weights for connections to neurons presynaptic to
                      %the spiking neuron
                      wMat = zeros(length(presyningroup),1);
                      for synInd = 1:length(presyningroup)
                            wMat(synInd) = wArr{presyningroup(synInd)}(postsynlocingroup(synInd));
                      end
                      wMat = updateweightsaspostsynspike(SynModel{postGroup,iSpkSynGroup},...
                               wMat, presyningroup...
                              -TP.groupBoundaryIDArr(neuronInGroup(presyningroup(synInd))),neuronInGroup(presyningroup(synInd)) );
                          
                      for synInd = 1:length(presyningroup)
                            wArr{presyningroup(synInd)}(postsynlocingroup(synInd)) = wMat(synInd);
                      end

                  end
              end
          end
      end
        
    end
    
    
%     if simStep == RS.samplingSteps(iterator.sampleStepCounter)
%         if RecVar.recordWeights
%             disp('recording individual neuron weights')
%             RecVar = updateWeightsRecording(RecVar,recTimeCounter,wArr);
%  
%         end
%     end
    

    
    S.spikeCount = 0;
    iterator.comCount = SS.minDelaySteps;
else
    iterator.comCount = iterator.comCount - 1;
end

% write recorded variables to disk
if mod(simStep * SS.timeStep, 5) == 0
    disp(num2str(simStep * SS.timeStep));
end
if simStep == RS.dataWriteSteps(iterator.numSaves)
    if iterator.spikeRecCounter-1 ~= length(RecVar.spikeRecording)
        RecVar.spikeRecording{end} = {[], []};
    end
    iterator.recTimeCounter = 1;
    fName = sprintf('%sRecordings%d_%d.mat', outputDirectory, iterator.numSaves+iterator.nsaves,rgn);
    save(fName, 'RecVar','-v7.3');
    disp('saving')
    % Only imcrement numSaves if this isn't the last scheduled save point.
    if iterator.numSaves < length(RS.dataWriteSteps)
        iterator.numSaves = iterator.numSaves + 1;
    end
    
    iterator.spikeRecCounter = 1;
    
    if S.spikeLoad
        if iterator.numSaves <= length(RS.dataWriteSteps)
            fName = sprintf('%sRecordings%d_%d.mat',inputDirectory,iterator.numSaves+iterator.nsaves,rgn);
            iterator.loadedSpikes = load(fName);
            dataFieldName = fields(iterator.loadedSpikes);
            disp(size(iterator.loadedSpikes.(dataFieldName{1}).spikeRecording));
        end
    end
end


end % end of simulation time loop


%numSaves = numSaves - 1; % - no longer need this as numSaves is not
%updated beyond the final scheduled save point