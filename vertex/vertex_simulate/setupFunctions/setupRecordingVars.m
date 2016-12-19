function [RS, RecordingVars, lineSourceModCell] = ...
  setupRecordingVars(TP, NP, SS, RS, IDMap, LSM)

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

if ~isfield(RS,'apre_syn')
    RS.apre_syn = [];
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
      p_intraRecording = zeros(p_numToRecordIntra, RS.maxRecSamples);
      
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
    intraRecCellIDArr = IDMap.modelIDToCellIDMap(RS.v_m, :);
    numToRecordIntra = size(intraRecCellIDArr, 1);

    intraRecording = zeros(numToRecordIntra, RS.maxRecSamples);
    
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
      p_fac_synRecording = zeros(p_numToRecordfac_syn, TP.numGroups, RS.maxRecSamples);
      
      RecordingVars.fac_synRecCellIDArr = p_fac_synRecCellIDArr;
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
    fac_synRecording = zeros(numToRecordfac_syn, TP.numGroups, RS.maxRecSamples);
    
    RecordingVars.fac_synRecCellIDArr = fac_synRecCellIDArr;
    RecordingVars.fac_synRecording = fac_synRecording;
  else
    recordFac_syn = false;
  end
  RecordingVars.recordFac_syn = recordFac_syn;
end

%STDP variables recording
if SS.parallelSim
apre_SynRecLab = SS.neuronInLab(RS.apre_syn);
  spmd
    if ismember(labindex(), unique(apre_SynRecLab))
      recordapre_syn = true;
      p_apre_synRecModelIDArr = RS.apre_syn(apre_SynRecLab == labindex());
      p_apre_synRecCellIDArr = ...
        IDMap.modelIDToCellIDMap(p_apre_synRecModelIDArr, :);
      p_numToRecordapre_syn = size(p_apre_synRecModelIDArr, 1);
      p_apre_synRecording = cell(p_numToRecordapre_syn, TP.numGroups, RS.maxRecSamples);
      
      RecordingVars.apre_synRecCellIDArr = p_apre_synRecCellIDArr;
      RecordingVars.apre_synRecording = p_apre_synRecording;
    else
      recordapre_syn = false;
    end
    RecordingVars.recordapre_syn = recordapre_syn;
  end
else
  if ~isempty(RS.apre_syn)
    recordapre_syn = true;
   apre_synRecCellIDArr = IDMap.modelIDToCellIDMap(RS.apre_syn, :);
    numToRecordapre_syn = size(apre_synRecCellIDArr, 1);
    apre_synRecording = zeros(numToRecordapre_syn, TP.numGroups, RS.maxRecSamples);
    
    RecordingVars.apre_synRecCellIDArr = apre_synRecCellIDArr;
    RecordingVars.apre_synRecording = apre_synRecording;
  else
    recordapre_syn = false;
  end
  RecordingVars.recordapre_syn = recordapre_syn;
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
      p_I_synRecording = zeros(p_numToRecordI_syn, TP.numGroups, RS.maxRecSamples);
      
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
    I_synRecording = zeros(numToRecordI_syn, TP.numGroups, RS.maxRecSamples);
    
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
            NP(iGroup).numCompartments, RS.maxRecSamples);
        end
      else
        for iGroup = 1:TP.numGroups
          LFPRecording{iGroup} = zeros(numElectrodes, RS.maxRecSamples);
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
          NP(iGroup).numCompartments, RS.maxRecSamples);
      end
    else
      for iGroup = 1:TP.numGroups
        LFPRecording{iGroup} = zeros(numElectrodes, RS.maxRecSamples);
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



