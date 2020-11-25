function [NeuronModel, SynModel, InModel, numSaves, RecVar] = simulate(TP, NP, SS, RS, IDMap, ...
    NeuronModel, SynModel, InModel,DVModel, RecVar, lineSourceModCell, synArr, wArr, synMap, nsaves)

outputDirectory = RS.saveDir;

nIntSize = 'uint32';
tIntSize = 'uint16';

groupComparts = [NP.numCompartments];

numInGroup = diff(TP.groupBoundaryIDArr);
neuronInGroup = ...
    createGroupsFromBoundaries(TP.groupBoundaryIDArr);
bufferLength = SS.maxDelaySteps;
if ~isempty(DVModel)
    bufferLengthDV = SS.maxDelayStepsDV;
end
comCount = SS.minDelaySteps;
% vars to keep track of where we are in recording buffers:
recTimeCounter = 1;
sampleStepCounter = 1;
spikeRecCounter = 1;

% vars to keep track of spikes
S.spikes = zeros(TP.N * SS.minDelaySteps, 1, nIntSize);
S.spikeStep = zeros(TP.N * SS.minDelaySteps, 1, tIntSize);
S.spikeCount = zeros(1, 1, nIntSize);

numSaves = 1;
if nargin == 14
    nsaves = 0;
end
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
    fName = sprintf('%sRecordings%d.mat', inputDirectory, numSaves);
    loadedSpikes = load(fName);
    dataFieldName = fields(loadedSpikes);
end

recordIntra = RecVar.recordIntra;
recordI_syn = RecVar.recordI_syn;
recordstp_syn = RecVar.recordstp_syn;
recordWeights = RecVar.recordWeights;
recordWeightsArr = RecVar.recordWeightsArr;
recordstdpvars = RecVar.recordstdpvars;

weightsArrcount = 1;
stimcount = 1;
timeStimStep = 1;

% simulation loop
%disp(['max: ' num2str(max(StimParams.activation))]);
stdp = false;
for iPostGroup = 1:TP.numGroups
    for iGroup = 1:size(SynModel,2)
        if  ~isempty(SynModel{iPostGroup, iGroup})
            if isa(SynModel{iPostGroup, iGroup}, 'STDPModel')
                stdp = true;
            end
        end
    end
end
revSynArr = [];
if stdp
    disp('Using stdp, so calculating postsynaptic to presynaptic map');
    
    revSynArr = reverseSynArr(synArr);
    
    disp('Map calculated');
end
for simStep = 1:simulationSteps
    
    if isfield(TP, 'StimulationField')
        current_time = simStep * SS.timeStep;
        
        if current_time > TP.StimulationOn(stimcount) && current_time < TP.StimulationOff(stimcount)
            for iGroup = 1:TP.numGroups
                if  ~NeuronModel{iGroup}.incorporate_vext
                    stimulationOn(NeuronModel{iGroup});
                 end
                % For time varying stimulation, step through the time
                % dimension of the vext matrix for each simStep where
                % stimulation is active. The vext matrix should have
                % been previously interpolated in runSimulation.
                if isa(TP.StimulationField, 'pde.TimeDependentResults')
                    setVext(NeuronModel{iGroup},NP(iGroup).V_ext_mat(:,:,timeStimStep));
                elseif isfield(TP, 'tRNS')
                    setVext(NeuronModel{iGroup},NeuronModel{iGroup}.v_ext*TP.tRNS);
                end
                
            end
            if isfield(TP, 'tRNS')
                TP.tRNS = wgn(1,1,0); % generate a new random number for tRNS.
            end
            timeStimStep = timeStimStep+1;
            % reset timeStimStep if it gets passed the length of the
            % time dimension in the stimulation field, this will loop
            % back to the beginning of the time varying stimulation.
            if timeStimStep > size(TP.StimulationField.NodalSolution,2)
                timeStimStep = 1;
            end
        elseif current_time >= TP.StimulationOff(stimcount)
            for iGroup = 1:TP.numGroups
                if  NeuronModel{iGroup}.incorporate_vext
                    %stimulationOn(NeuronModel{iGroup});
                    stimulationOff(NeuronModel{iGroup});
                end
            end
            if stimcount < length(TP.StimulationOn)
               stimcount = stimcount+1;
            end
        end
    end
    %   if isa(TP.StimulationField, 'pde.TimeDependentResults')
    %       for i=1:TP.numGroups
    %            StimParams.activation{i} = StimParams.activationAll{i}(:,count);
    %       end
    %     count = count+1;
    %     if count > length(t)
    %         count = 1; % reset if getting to the end of the time steps.
    %         %NB: this will work so long as the pde was solved for the right
    %         %ntimesteps... so may well need some fixing as it is now!
    %     end
    %   else
    %        StimParams.trns = wgn(1,1,0); % set a value for multipling the stimulation field by at each timestep for tRNS.
    %        % this will exist for any non-time dependent stim (so DC as well as
    %        % RNS) but will only be used for tRNS later.
    %   end
    
    %Update weight recording
    if recordWeights
        if simStep == RS.samplingSteps(sampleStepCounter)
            RecVar = updateWeightsRecording(RecVar,recTimeCounter,wArr,SS);
        end
    end
    if recordWeightsArr
        if weightsArrcount <= length(RS.weights_arr) && simStep == RS.weights_arr(weightsArrcount)
            
            RecVar.WeightArrRec{weightsArrcount} = wArr;
            weightsArrcount = weightsArrcount+1;
            
        end
    end
    
    for iGroup = 1:TP.numGroups
        
        
        [NeuronModel, SynModel, InModel, wArr] = ...
            groupUpdateSchedule(NP,TP,SS,NeuronModel,SynModel,InModel,iGroup,synArr,wArr, IDMap, neuronInGroup);
        
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
                    updateI_synRecording(SynModel,synMap, RecVar,iGroup,recTimeCounter);
            end
            
            % for LFP:
            if RS.LFP && NP(iGroup).numCompartments ~= 1
                RecVar = ...
                    updateLFPRecording(RS,NeuronModel,RecVar,lineSourceModCell,iGroup,recTimeCounter);
            end
            
            if RS.CSD 
                RecVar = updateCSDRecording(RS, NeuronModel, RecVar, iGroup, recTimeCounter);
            end
            
            if recordstp_syn
                RecVar = updateSTPVarsRecording(SynModel,RecVar,iGroup,recTimeCounter,synMap,neuronInGroup,TP);
            end
            
            if recordstdpvars
                RecVar = updateSTDPVarsRecording(SynModel,RecVar,iGroup,recTimeCounter,synMap,neuronInGroup,TP);
            end
            
            if RS.I_synComp
                RecVar = updateI_synCompRecording(RS,SynModel,synMap, RecVar,iGroup,recTimeCounter);
            end
            
            
        end
        
    end % for each group
    if RS.DV
        if simStep == RS.samplingSteps(sampleStepCounter)
            RecVar = updateDVRecording(DVModel, RecVar,recTimeCounter);
        end
    end
    
    if ~isempty(DVModel)
        DVModel =updateDiseaseVectorModel(DVModel, SS.timeStep);
        DVModel = updateBuffer(DVModel);
    end
    % increment the recording sample counter
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
        if ~S.spikeLoad
            if S.spikeCount ~= 0
                allSpike = S.spikes(1:S.spikeCount);
                allSpikeTimes = S.spikeStep(1:S.spikeCount);
            else
                allSpike = zeros(0, nIntSize);
                allSpikeTimes = zeros(0, tIntSize);
            end
        else
            tt = loadedSpikes.(dataFieldName{1}).spikeRecording{spikeRecCounter};
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
        RecVar.spikeRecording{spikeRecCounter} = {allSpike, allSpikeTimes};
        spikeRecCounter = spikeRecCounter + 1;

            
        %[SynModel, wArr] = processSpikes(allSpike,allSpikeTimes,TP,wArr,groupComparts, IDMap,synArr,revSynArr, neuronInGroup, synMap, SynModel, bufferLength,numInGroup, stdp);
        %updatePresynapticCellsAfterSpike(DVModel, allSpike);
        % Go through spikes and insert events into relevant buffers
        % mat3d(ii+((jj-1)*x)+((kk-1)*y)*x))
        for iSpk = 1:length(allSpike)
            % Get which groups the targets are in
            postInGroup = neuronInGroup(synArr{allSpike(iSpk), 1});
            if ~isempty(DVModel)

                    tBufferLoc = synArr{allSpike(iSpk), 3} + ...
                            DVModel.bufferCount - allSpikeTimes(iSpk);
                    tBufferLoc(tBufferLoc > bufferLength) = ...
                            tBufferLoc(tBufferLoc > bufferLength) - bufferLength;
                    pCBufferLoc = DVModel.pCTraceInd - synArr{allSpike(iSpk),4};
                    pCBufferLoc(pCBufferLoc < 1) = ...
                            pCBufferLoc(pCBufferLoc < 1) + bufferLengthDV;
                bufferVectorFlow(DVModel, synArr{allSpike(iSpk), 1},tBufferLoc,...
                    wArr{allSpike(iSpk)},DVModel.pC(pCBufferLoc,allSpike(iSpk)));
                
            end
            % Eac
            for iPostGroup = 1:TP.numGroups

                iSpkSynGroup = synMap{iPostGroup}(neuronInGroup(allSpike(iSpk)));
                
                if ~isempty(SynModel{iPostGroup, iSpkSynGroup})
                    % Adjust time indeces according to circular buffer index
                    % and according the the delay speicifc to the synapse type,
                    % specified by: synArr{allSpike(iSpk), 3}
                    tBufferLoc = synArr{allSpike(iSpk), 3} + ...
                        SynModel{iPostGroup, iSpkSynGroup}.bufferCount - allSpikeTimes(iSpk);
                    tBufferLoc(tBufferLoc > bufferLength) = ...
                        tBufferLoc(tBufferLoc > bufferLength) - bufferLength;
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
                            uint32(numInGroup(iPostGroup)) + ...
                            (uint32(tBufferLoc(inGroup)) - ...
                            uint32(1)) .* ...
                            uint32(groupComparts(iPostGroup)) .* ...
                            uint32(numInGroup(iPostGroup));
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
                                ind, wArr{allSpike(iSpk)}(inGroup),relative_preID,neuronInGroup(allSpike(iSpk)));
                        else
                            bufferIncomingSpikes( ...
                                SynModel{iPostGroup, iSpkSynGroup}, ...
                                ind, wArr{allSpike(iSpk)}(inGroup));
                        end
                        if isa(SynModel{iPostGroup, iSpkSynGroup}, 'STDPModel_delays')
                            relativeSpikeID = allSpike(iSpk) - TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk)));
                            relativepostneuronIDs = IDMap.modelIDToCellIDMap(synArr{allSpike(iSpk), 1}(inGroup), 1)';
                            processAsPreSynSpike(SynModel{iPostGroup, iSpkSynGroup},relativeSpikeID,neuronInGroup(allSpike(iSpk)),relativepostneuronIDs,tBufferLoc(inGroup) );
                        %else if ensures that only one is processing is
                        %done (STDPModel_delays inherits from STDPModel)
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
            
            if stdp
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
                            
                            %weights array mirrors synArr, it is a cell array containing an
                            %entry for each pre synaptic neuron, containing
                            %the weights of its connections to all of its
                            %post synaptic neurons. The post synaptic
                            %neuron IDs can be found in the same location
                            %in synArr. One might think that the weights 
                            % array and syn array could be sparse matrices,
                            % but to allow multiple synapses between a
                            % single pair of neurons it must be a cell
                            % array.
                            wMat = zeros(length(presyningroup),1);
                            for synInd = 1:length(presyningroup)
                                wMat(synInd) = wArr{presyningroup(synInd)}(postsynlocingroup(synInd));
                            end
                            
                            if isa(SynModel{postGroup,iSpkSynGroup}, 'STDPModel_delays')
                                tBufferLoc =  cast(revSynArr{allSpike(iSpk), 3}, 'int16') + cast(SynModel{postGroup,iSpkSynGroup}.STDPbufferCount,'int16')...
                                    - cast(allSpikeTimes(iSpk), 'int16');
                                
                                tBufferLoc(tBufferLoc > bufferLength) = ...
                                    tBufferLoc(tBufferLoc > bufferLength) - bufferLength;
                                
                                tBufferLoc(tBufferLoc<1) = bufferLength + tBufferLoc(tBufferLoc<1);
                                
                                wMat = updateweightsaspostsynspike(SynModel{postGroup,iSpkSynGroup},...
                                    wMat, presyningroup...
                                    -TP.groupBoundaryIDArr(neuronInGroup(presyningroup))',neuronInGroup(presyningroup),tBufferLoc(inGroup) );
                            else
                                wMat = updateweightsaspostsynspike(SynModel{postGroup,iSpkSynGroup},...
                                    wMat, presyningroup...
                                    -TP.groupBoundaryIDArr(neuronInGroup(presyningroup))',neuronInGroup(presyningroup));
                            end
                            
                            for synInd = 1:length(presyningroup)
                                wArr{presyningroup(synInd)}(postsynlocingroup(synInd)) = wMat(synInd);
                            end
                            
                        end
                    end
                    end
                end
            
            
        end
        
        
        if simStep == RS.samplingSteps(sampleStepCounter)
            if RecVar.recordWeights
                
                RecVar = updateWeightsRecording(wArr,RecVar,recTimeCounter);
            end
        end
        
        
        S.spikeCount = 0;
        comCount = SS.minDelaySteps;
    else
        comCount = comCount - 1;
    end
    
    
    
    
    % write recorded variables to disk
    if mod(simStep * SS.timeStep, 5) == 0
        disp(num2str(simStep * SS.timeStep));
    end
    if simStep == RS.dataWriteSteps(numSaves)
        if spikeRecCounter-1 ~= length(RecVar.spikeRecording) && ~isfield(SS,'optimisation')
            RecVar.spikeRecording{end} = {[], []};
            
        end
        recTimeCounter = 1;
        fName = sprintf('%sRecordings%d.mat', outputDirectory, numSaves+nsaves);
        save(fName, 'RecVar','-v7.3');
        % Only imcrement numSaves if this isn't the last scheduled save point.
        if numSaves < length(RS.dataWriteSteps)
            numSaves = numSaves + 1;
        end
        
        spikeRecCounter = 1;
        
        if S.spikeLoad
            if numSaves <= length(RS.dataWriteSteps)
                fName = sprintf('%sRecordings%d.mat',inputDirectory,numSaves+nsaves);
                loadedSpikes = load(fName);
                dataFieldName = fields(loadedSpikes);
                disp(size(loadedSpikes.(dataFieldName{1}).spikeRecording));
            end
        end
    end
    
end
% end of simulation time loop
if isfield(RS,'LFPoffline') && RS.LFPoffline 
    save(outputDirectory, 'LineSourceConsts.mat', lineSourceModCell);
end

end
%numSaves = numSaves - 1; % - no longer need this as numSaves is not
%updated beyond the final scheduled save point