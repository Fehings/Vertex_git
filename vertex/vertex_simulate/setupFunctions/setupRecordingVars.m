function [RS, RecordingVars, lineSourceModCell] = ...
  setupRecordingVars(TP, NP, SS, RS, IDMap, LSM,wArr,synArr)

groupBoundaryIDArr = TP.groupBoundaryIDArr;
neuronInGroup = createGroupsFromBoundaries(groupBoundaryIDArr);

if isfield(RS, 'LFP') && RS.LFP
  numElectrodes = length(RS.meaXpositions(:));
  RS.numElectrodes = numElectrodes;
else
  RS.LFP = false;
end

if ~isfield(RS, 'v_m')
  RS.v_m = [];
end

if ~isfield(RS, 'I_syn')
  RS.I_syn = [];
end

if ~isfield(RS, 'fac_syn')
  RS.fac_syn = [];
end
if ~isfield(RS, 'dep_syn')
  RS.dep_syn = [];
end

if ~isfield(RS,'stdpvars')
    RS.stdpvars = [];
end


if ~isfield(RS, 'weights_preN_IDs')
    RS.weights_preN_IDs = [];
end

if ~isfield(RS, 'weights_arr')
    RS.weights_arr = [];
end



% weights recording
if SS.parallelSim
    spmd
        if ~isempty(RS.weights_preN_IDs)
            recordWeights = true;
            preweightsRecLab = RS.weights_preN_IDs;
            weightsRec = cell(length(preweightsRecLab),1);
            for c = 1:length(weightsRec)
                weightsRec{c} = zeros(round(RS.maxRecSamples),length(wArr{preweightsRecLab(c)}));
                synapseIDs{c} = synArr{preweightsRecLab(c),1};
            end
            %RS.v_m=floor(RS.v_m);
            
            
            RecordingVars.preweightsRecCellIDArr = RS.weights_preN_IDs;
            RecordingVars.weightsRecording =  weightsRec;
            RecordingVars.synapsepostIDs = synapseIDs;
        else
            recordWeights = false;
        end
        RecordingVars.recordWeights = recordWeights;
    end
    
else
  if ~isempty(RS.weights_preN_IDs)
    recordWeights = true;
    preweightsRecLab = RS.weights_preN_IDs;
    
    weightsRec = cell(length(preweightsRecLab),1);
    for c = 1:length(weightsRec)
        weightsRec{c} = zeros(round(RS.maxRecSamples),length(wArr{preweightsRecLab(c)}));
        synapseIDs{c} = synArr{preweightsRecLab(c),1};
    end

    RecordingVars.preweightsRecCellIDArr = RS.weights_preN_IDs;
    RecordingVars.weightsRecording =  weightsRec;
    RecordingVars.synapsepostIDs = synapseIDs;
  else
    recordWeights = false;
  end
  RecordingVars.recordWeights = recordWeights;
end

if SS.parallelSim
    spmd
        if ~isempty(RS.weights_arr)
            recordWeightArr = true;
            for c = 1:length(recordWeightArr)
                WeightArrRec{c} = cell(wArr);
            end
            RecordingVars.WeightArrRec = WeightArrRec;
            RecordingVars.synArr = synArr;
        else
            recordWeightArr = false;
        end
        RecordingVars.recordWeightsArr = recordWeightArr;
        
    end
else
        if ~isempty(RS.weights_arr)
            recordWeightArr = true;
            for c = 1:length(recordWeightArr)
                WeightArrRec{c} = cell(wArr);
            end
            RecordingVars.synArr = synArr;
            RecordingVars.WeightArrRec = WeightArrRec;
        else
            recordWeightArr = false;
        end
        RecordingVars.recordWeightsArr = recordWeightArr;
        

end

% Intracellular recording:
if SS.parallelSim
  intraRecLab = SS.neuronInLab(RS.v_m);
  spmd
    if ismember(labindex(), unique(intraRecLab))
      recordIntra = true;
      p_intraRecModelIDArr = RS.v_m(intraRecLab == labindex());
      p_intraRecCellIDArr = ...
        IDMap.modelIDToCellIDMap(p_intraRecModelIDArr, :);
      p_numToRecordIntra = size(p_intraRecModelIDArr, 1);
      p_intraRecording = zeros(p_numToRecordIntra,  round(RS.maxRecSamples));
      
      RecordingVars.intraRecCellIDArr = p_intraRecCellIDArr;
      RecordingVars.intraRecording = p_intraRecording;
    else
      recordIntra = false;
    end
    RecordingVars.recordIntra = recordIntra;
  end
else
  if ~isempty(RS.v_m)
    recordIntra = true;
    %RS.v_m=floor(RS.v_m);
    intraRecCellIDArr = IDMap.modelIDToCellIDMap(RS.v_m, :);
    numToRecordIntra = size(intraRecCellIDArr, 1);
    intraRecording = zeros(numToRecordIntra, round(RS.maxRecSamples));
    
    RecordingVars.intraRecCellIDArr = intraRecCellIDArr;
    RecordingVars.intraRecording = intraRecording;
  else
    recordIntra = false;
  end
  RecordingVars.recordIntra = recordIntra;
end

if SS.parallelSim
fac_SynRecLab = SS.neuronInLab(RS.fac_syn);
  spmd
    if ismember(labindex(), unique(fac_SynRecLab))
      recordFac_syn = true;
      p_fac_synRecModelIDArr = RS.fac_syn(fac_SynRecLab == labindex());
      p_fac_synRecCellIDArr = ...
        IDMap.modelIDToCellIDMap(p_fac_synRecModelIDArr, :);
      p_numToRecordfac_syn = size(p_fac_synRecModelIDArr, 1);
      p_fac_synRecording{1} = zeros(p_numToRecordfac_syn, TP.numGroups, round(RS.maxRecSamples));
      p_fac_synRecording{2} = zeros(p_numToRecordfac_syn, TP.numGroups, round(RS.maxRecSamples));
      
      RecordingVars.fac_synRecCellIDArr = p_fac_synRecCellIDArr;
       RecordingVars.fac_synRecModelIDArr = p_fac_synRecModelIDArr;
       facGBA = groupBoundaryIDArr(neuronInGroup(p_fac_synRecModelIDArr))';
      RecordingVars.fac_synRecCellIDArr = [p_fac_synRecModelIDArr - facGBA; uint16(neuronInGroup(p_fac_synRecModelIDArr))'];
      
      RecordingVars.fac_synRecording = p_fac_synRecording;
    else
      recordFac_syn = false;
    end
    RecordingVars.recordFac_syn = recordFac_syn;
  end
else
  if ~isempty(RS.fac_syn)
    recordFac_syn = true;
   fac_synRecCellIDArr = IDMap.modelIDToCellIDMap(RS.fac_syn, :);
    numToRecordfac_syn = size(fac_synRecCellIDArr, 1);
    fac_synRecording{1} = zeros(numToRecordfac_syn, TP.numGroups, round(RS.maxRecSamples));
    fac_synRecording{2} = zeros(numToRecordfac_syn, TP.numGroups, round(RS.maxRecSamples));
    RecordingVars.fac_synRecCellIDArr = fac_synRecCellIDArr';
    RecordingVars.fac_synRecording = fac_synRecording;
  else
    recordFac_syn = false;
  end
  RecordingVars.recordFac_syn = recordFac_syn;
end

if SS.parallelSim
stdpvarsRecLab = SS.neuronInLab(RS.stdpvars);
  spmd
    if ismember(labindex(), unique(stdpvarsRecLab))
      recordstdpvars = true;
      p_stdpvarsRecModelIDArr = RS.stdpvars(stdpvarsRecLab == labindex());
      p_stdpvarsRecCellIDArr = ...
        IDMap.modelIDToCellIDMap(p_stdpvarsRecModelIDArr, :);
      p_numToRecordstdpvars = size(p_stdpvarsRecModelIDArr, 1);
      p_stdpvarsRecording{1} = zeros(p_numToRecordstdpvars, TP.numGroups, round(RS.maxRecSamples));
      p_stdpvarsRecording{2} = zeros(p_numToRecordstdpvars, TP.numGroups, round(RS.maxRecSamples));
      
      RecordingVars.stdpvarsRecCellIDArr = p_stdpvarsRecCellIDArr;
       RecordingVars.stdpvarsRecModelIDArr = p_stdpvarsRecModelIDArr;
      %stdpvarsGBA = groupBoundaryIDArr(neuronInGroup(p_stdpvarsRecModelIDArr))';
      %RecordingVars.stdpvarsRecCellIDArr = [p_stdpvarsRecModelIDArr - stdpvarsGBA; uint16(neuronInGroup(p_stdpvarsRecModelIDArr))'];
      
      RecordingVars.stdpvarsRecording = p_stdpvarsRecording;
    else
      recordstdpvars = false;
    end
    RecordingVars.recordstdpvars = recordstdpvars;
  end
else
  if ~isempty(RS.stdpvars)
    recordstdpvars = true;
   stdpvarsRecCellIDArr = IDMap.modelIDToCellIDMap(RS.stdpvars, :);
    numToRecordstdpvars = size(stdpvarsRecCellIDArr, 1);
    stdpvarsRecording{1} = zeros(numToRecordstdpvars, TP.numGroups, round(RS.maxRecSamples));
    stdpvarsRecording{2} = zeros(numToRecordstdpvars, TP.numGroups, round(RS.maxRecSamples));
    RecordingVars.stdpvarsRecCellIDArr = stdpvarsRecCellIDArr;
    RecordingVars.stdpvarsRecModelIDArr = RS.stdpvars;
    RecordingVars.stdpvarsRecording = stdpvarsRecording;
    
  else
    recordstdpvars = false;
  end
  RecordingVars.recordstdpvars = recordstdpvars;
end



% Synaptic current recording:
if SS.parallelSim
  I_SynRecLab = SS.neuronInLab(RS.I_syn);
  spmd
    if ismember(labindex(), unique(I_SynRecLab))
      recordI_syn = true;
      p_I_synRecModelIDArr = RS.I_syn(I_SynRecLab == labindex());
      p_I_synRecCellIDArr = ...
        IDMap.modelIDToCellIDMap(p_I_synRecModelIDArr, :);
      p_numToRecordI_syn = size(p_I_synRecModelIDArr, 1);
      p_I_synRecording = zeros(p_numToRecordI_syn, size(synArr,2), round(RS.maxRecSamples));
      RecordingVars.I_synRecCellIDArr = p_I_synRecCellIDArr;
      RecordingVars.I_synRecording = p_I_synRecording;
    else
      recordI_syn = false;
    end
    RecordingVars.recordI_syn = recordI_syn;
  end
else
  if ~isempty(RS.I_syn)
    recordI_syn = true;
    I_synRecCellIDArr = IDMap.modelIDToCellIDMap(RS.I_syn, :);
    numToRecordI_syn = size(I_synRecCellIDArr, 1);
    I_synRecording = zeros(numToRecordI_syn, size(synArr,2), round(RS.maxRecSamples));

    
    RecordingVars.I_synRecCellIDArr = I_synRecCellIDArr;
    RecordingVars.I_synRecording = I_synRecording;
  else
    recordI_syn = false;
  end
  RecordingVars.recordI_syn = recordI_syn;
end

% for LFPs:
if RS.LFP
  if SS.parallelSim
    spmd
      p_neuronInThisLab = SS.neuronInLab == labindex();
      p_neuronInGroup = neuronInGroup(p_neuronInThisLab);
      LFPRecording = cell(TP.numGroups, 1);
      lineSourceModCell = cell(TP.numGroups, numElectrodes);
      if isfield(RS, 'LFPoffline') && RS.LFPoffline
        for iGroup = 1:TP.numGroups
          LFPRecording{iGroup} = zeros(sum(p_neuronInGroup==iGroup,1), ...
            NP(iGroup).numCompartments, round(RS.maxRecSamples));
        end
      else
        for iGroup = 1:TP.numGroups
          LFPRecording{iGroup} = zeros(numElectrodes, round(RS.maxRecSamples));
        end
      end
      for iGroup = 1:TP.numGroups
        for iElectrode = 1:numElectrodes
          lineSourceModCell{iGroup, iElectrode} = ...
            cell2mat(LSM(neuronInGroup==iGroup, iElectrode)')';
        end
      end
      RecordingVars.LFPRecording = LFPRecording;
    end
  else
    LFPRecording = cell(TP.numGroups, 1);
    lineSourceModCell = cell(TP.numGroups, numElectrodes);
    if isfield(RS, 'LFPoffline') && RS.LFPoffline
      for iGroup = 1:TP.numGroups
        LFPRecording{iGroup} = zeros(sum(neuronInGroup==iGroup, 1), ...
          NP(iGroup).numCompartments, round(RS.maxRecSamples));
      end
    else
      for iGroup = 1:TP.numGroups
        LFPRecording{iGroup} = zeros(numElectrodes, round(RS.maxRecSamples));
      end
    end
    for iGroup = 1:TP.numGroups
      for iElectrode = 1:numElectrodes
        lineSourceModCell{iGroup, iElectrode} = ...
          cell2mat(LSM(neuronInGroup==iGroup, iElectrode)')';
      end
    end
    RecordingVars.LFPRecording = LFPRecording;
  end % if parallelSim
  RS.numElectrodes = numElectrodes;
else % if LFP
  lineSourceModCell = {};
end

% for spikes
if SS.parallelSim
  spmd
    RecordingVars.spikeRecording=cell(round(RS.maxRecSteps/SS.minDelaySteps),1);
  end
else
  RecordingVars.spikeRecording = cell(round(RS.maxRecSteps/SS.minDelaySteps),1);
end



