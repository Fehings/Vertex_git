function [NeuronModel, SynModel, InModel, numSaves] = simulate(TP, NP, SS, RS, IDMap, ...
                       NeuronModel, SynModel, InModel, RecVar, lineSourceModCell, synArr, wArr, synMap, nsaves)

outputDirectory = RS.saveDir;

nIntSize = 'uint32'; % 32 bit unsigned integer
tIntSize = 'uint16'; % 16 bit unsigned integer

groupComparts = [NP.numCompartments];

numInGroup = diff(TP.groupBoundaryIDArr);
% diff calculates differences between adjacent elements of
% TP.groupBoundaryIDArr, which I think contains the first and last neuron
% IDs for each layer (or is it neuron type?).
neuronInGroup = ...
  createGroupsFromBoundaries(TP.groupBoundaryIDArr);
% the above function call created NeuronInGroup which is an array the
% length of the number of neurons, and for each neuron gives a number
% representing the group (layer) they are in, so 1 for the first layer, 2
% for the second, etc.
bufferLength = SS.maxDelaySteps;
comCount = SS.minDelaySteps;
% vars to keep track of where we are in recording buffers:
recTimeCounter = 1;
sampleStepCounter = 1;
spikeRecCounter = 1;

% vars to keep track of spikes
S.spikes = zeros(TP.N * SS.minDelaySteps, 1, nIntSize);
S.spikeStep = zeros(TP.N * SS.minDelaySteps, 1, tIntSize);
% TP.N is the numberof neurons, so the above two vectors are the min number
% of delay steps per neuron in size.
S.spikeCount = zeros(1, 1, nIntSize);

numSaves = 1;
if nargin == 13
  nsaves = 0;
end
% in the runSimulation script (as per the official DL) there are 13
% arguments for simulate and nsaves is missed, so this if statement is
% true.

simulationSteps = round(SS.simulationTime / SS.timeStep);
% the SS values are both floats, so this will create one integer
% representing the number of time steps.

% this next bit checks whether there are preset spikes to be loaded, and if
% there are it loads them and creates a filename from the input directory. 
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
  
% simulation loop
for simStep = 1:simulationSteps  % for each simulation step
  for iGroup = 1:TP.numGroups    % for each group
    [NeuronModel, SynModel, InModel] = ...
      groupUpdateSchedule(NP,SS,NeuronModel,SynModel,InModel,iGroup);
    % This is the main part of the code, where in a per group manner the
    % currents are calculated, see the groupUpdateSchedule function for
    % more info.
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
    if ~S.spikeLoad % if there are no preloaded spikes
      if S.spikeCount ~= 0 % and if the spikeCount is not zero 
          % (Spike count is initialised to zero, but is presumably updated earlier in the loop when 'addGroupSpikesToSpikeList' is called.)
        allSpike = S.spikes(1:S.spikeCount);
        allSpikeTimes = S.spikeStep(1:S.spikeCount);
      else
        allSpike = zeros(0, nIntSize);
        allSpikeTimes = zeros(0, tIntSize);
      end
    else % if there are preloaded spikes load the spikes
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
          tBufferLoc = synArr{allSpike(iSpk), 3} + ...
            SynModel{iPostGroup, iSpkSynGroup}.bufferCount - allSpikeTimes(iSpk);
          tBufferLoc(tBufferLoc > bufferLength) = ...
            tBufferLoc(tBufferLoc > bufferLength) - bufferLength;
          inGroup = postInGroup == iPostGroup;
          if sum(inGroup ~= 0)
            ind = ...
              uint32(IDMap.modelIDToCellIDMap(synArr{allSpike(iSpk), 1}(inGroup), 1)') + ...
              (uint32(synArr{allSpike(iSpk), 2}(inGroup)) - ...
              uint32(1)) .* ...
              uint32(numInGroup(iPostGroup)) + ...
              (uint32(tBufferLoc(inGroup)) - ...
              uint32(1)) .* ...
              uint32(groupComparts(iPostGroup)) .* ...
              uint32(numInGroup(iPostGroup));
            
            bufferIncomingSpikes( ...
              SynModel{iPostGroup, iSpkSynGroup}, ...
              ind, wArr{allSpike(iSpk)}(inGroup));
          end
        end
      end
    end
    
    S.spikeCount = 0; % reset the spike count
    comCount = SS.minDelaySteps; % so comCount tics down from the delay steps until it reaches 1, and that's when spikes are counted?
  else
    comCount = comCount - 1; % if comCount was not equal to 1, reduce it by 1
  end

  % write recorded variables to disk
  if mod(simStep * SS.timeStep, 5) == 0
   disp(num2str(simStep * SS.timeStep));  % this bit prints a count out in steps of 5
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