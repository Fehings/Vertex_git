function [NeuronModel, SynModel, InModel, numSaves, StimParams] = simulate(TP, NP, SS, RS, IDMap, ...
                       NeuronModel, SynModel, InModel, RecVar, lineSourceModCell, synArr, wArr, synMap, nsaves)

outputDirectory = RS.saveDir;

nIntSize = 'uint32';
tIntSize = 'uint16';

groupComparts = [NP.numCompartments];

numInGroup = diff(TP.groupBoundaryIDArr);
neuronInGroup = ...
  createGroupsFromBoundaries(TP.groupBoundaryIDArr);
bufferLength = SS.maxDelaySteps;
comCount = SS.minDelaySteps;
% vars to keep track of where we are in recording buffers:
recTimeCounter = 1;
sampleStepCounter = 1;
spikeRecCounter = 1;

% va rs to keep track of spikes
S.spikes = zeros(TP.N * SS.minDelaySteps, 1, nIntSize);
S.spikeStep = zeros(TP.N * SS.minDelaySteps, 1, tIntSize);
S.spikeCount = zeros(1, 1, nIntSize);

numSaves = 1;
if nargin == 13
  nsaves = 0;
end
disp(SynModel)
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
recordFac_syn = RecVar.recordFac_syn;
record_apre_syn = RecVar.recordapre_syn;
stimulation =  isfield(TP,'StimulationField');
if ~stimulation
    SS.ef_stimulation = false;
    SS.fu_stimulation = false;
end
%disp(['Stimulation field: ' num2str(stimulation)]);

StimParams = {};
%if we are applying an electric field stimulus
if SS.ef_stimulation
    % get compartments locations in suitable vectorised form
    for iGroup = 1:TP.numGroups
        [StimParams.compartmentlocations{iGroup,1}, StimParams.compartmentlocations{iGroup,2}] = ...
            convertcompartmentlocations({TP.compartmentlocations{neuronInGroup==iGroup,1}},...
            {TP.compartmentlocations{neuronInGroup==iGroup,2}},{TP.compartmentlocations{neuronInGroup==iGroup,3}});
    end
    %Calculate the activation function for each compartment
    %Can be called on each iteration if the input field is time varying
    disp('Getting extraceluu');
    StimParams.activation = getExtracellularInput(TP, StimParams,0,NeuronModel,NP);
    disp('Got extraceluu');
    max(max(StimParams.activation{1}))
   
   
end

%if we are applying an focussed ultrasound
if SS.fu_stimulation
    %Get compartments in suitable  vectorised form
    for iGroup = 1:TP.numGroups
        [StimParams.compartmentlocations{iGroup,1}, StimParams.compartmentlocations{iGroup,2}] = ...
            convertcompartmentlocations({TP.compartmentlocations{neuronInGroup==iGroup,1}},...
            {TP.compartmentlocations{neuronInGroup==iGroup,2}},{TP.compartmentlocations{neuronInGroup==iGroup,3}});
    end
    %Calculate the ultrasound value function for each compartment
    %Can be called on each iteration if the input field is time varying
    StimParams.ultrasound{iGroup} = getUltraSoundAtCompartments(TP);
end

% simulation loop
%disp(['max: ' num2str(max(StimParams.activation))]);
stdp = false;
if stdp
    posttoprearr = getPosttoPreSynArr(synArr);
end
for simStep = 1:simulationSteps
  if isa(TP.StimulationField, 'pde.TimeDependentResults')
    StimParams.activation = getExtracellularInput(TP, StimParams,simStep);
  end

  for iGroup = 1:TP.numGroups
    
    
    [NeuronModel, SynModel, InModel] = ...
      groupUpdateSchedule(NP,SS,NeuronModel,SynModel,InModel,iGroup,StimParams);
    
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
          RecVar = updateFac_synRecording(SynModel,RecVar,iGroup,recTimeCounter);
      end
      
      if record_apre_syn
          RecVar = updateApre_synRecording(SynModel, RecVar, iGroup, recTimeCounter);
      end
      
    end
    
  end % for each group
  
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
            if isa(SynModel{iPostGroup, iSpkSynGroup}, 'SynapseModel_g_stp') 
                %synapse model function updates the stp variables and adds
                %spikes to the buffers.
                %we pass the id of the presynaptic neuron: allSpike(iSpk)
                %Synapse model stores stp vars for each pre to post
                %connection. iSpkSynGroup is the presynaptic group.
                bufferIncomingSpikes( ...
                    SynModel{iPostGroup, iSpkSynGroup}, ...
                    ind, wArr{allSpike(iSpk)}(inGroup),allSpike(iSpk), TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk))));
            else
                bufferIncomingSpikes( ...
                    SynModel{iPostGroup, iSpkSynGroup}, ...
                    ind, wArr{allSpike(iSpk)}(inGroup));
            end
            if isa(SynModel{iPostGroup, iSpkSynGroup}, 'SynapseModel_g_stdp')
                %process spike as presynaptic spike, updating weights for
                %post synaptic neurons in this synapse group. 
                %passing weights and group relative ids of post synaptic neurons.
                processAsPreSynSpike(SynModel{iPostGroup, iSpkSynGroup}, allSpike(iSpk) -TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk))));
                postneurons = synArr{allSpike(iSpk),1}(inGroup);
                
                wArr{allSpike(iSpk)}(inGroup) = updateweightsaspresynspike(SynModel{iPostGroup, iSpkSynGroup}, wArr{allSpike(iSpk)}(inGroup),postneurons -...
                    TP.groupBoundaryIDArr(neuronInGroup(postneurons(1))) );
            end
          end
        end

      end
      if stdp
          %get all neurons presynaptic to the spiking neuron
          presynaptic = posttoprearr{allSpike(iSpk)};
          preInGroup = neuronInGroup(presynaptic);
          
          for iPreGroup = 1:TP.numGroups
              inGroup = preInGroup == iPreGroup;
              if sum(inGroup ~= 0)
                  
                  if isa(SynModel{iSpkSynGroup,iPreGroup}, 'SynapseModel_g_stdp')
                      
                      relativeind = allSpike(iSpk) -TP.groupBoundaryIDArr(neuronInGroup(allSpike(iSpk)));
                      processAsPostSynSpike(SynModel{iSpkSynGroup, iPreGroup},relativeind);
                      %if the synapses from the preSynaptic group to the
                      %spiking group have stdp on them
                      presyningroup = presynaptic(inGroup);
                      for synInd = 1:length(presyningroup)
                           wArr{presyningroup(synInd)}(synArr{presyningroup(synInd)}==allSpike(iSpk)) = updateweightsaspostsynspike(SynModel{iSpkSynGroup,iPreGroup}, wArr{presyningroup(synInd)}(synArr{presyningroup(synInd)}==allSpike(iSpk)), presyningroup(synInd)...
                              -TP.groupBoundaryIDArr(neuronInGroup(presyningroup(synInd))) );
                      end
                  end
              end
          end
      end
      
      
    end
    
%     if stdp 
%         for iPreGroup = 1:TP.numGroups
%             preinGroup = neuronInGroup(allSpike) == iPreGroup;
%             for iPostGroup = 1:TP.numGroups
%                 
%                 neuronsfiringinpregroup = preinGroup(neuronInGroup(synArr{preinGroup, 1}) == iPostGroup);
%                 processAsPreSynSpike(SynModel{iPostGroup, iPreGroup}, neuronsinSynGroup -TP.groupBoundaryIDArr(neuronInGroup(inGroup(1))));
% 
%                 postinGroup = neuronInGroup(allSpike) == iPostGroup;
%                 neuronsfiringinpostgroup = postinGroup(neuronInGroup(synArr{postinGroup, 1})== iPreGroup);
%                 processAsPostSynSpike(SynModel{iPostGroup, iPreGroup}, allSpike(preinGroup) -TP.groupBoundaryIDArr(neuronInGroup(inGroup(1))));
%             end
%         end
%     end

    
    
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
    if spikeRecCounter-1 ~= length(RecVar.spikeRecording)
      RecVar.spikeRecording{end} = {[], []};
    end
    recTimeCounter = 1;
    fName = sprintf('%sRecordings%d.mat', outputDirectory, numSaves+nsaves);
    save(fName, 'RecVar');
    
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
end % end of simulation time loop
if isfield(RS,'LFPoffline') && RS.LFPoffline
  save(outputDirectory, 'LineSourceConsts.mat', lineSourceModCell);
end
%numSaves = numSaves - 1; % - no longer need this as numSaves is not
%updated beyond the final scheduled save point