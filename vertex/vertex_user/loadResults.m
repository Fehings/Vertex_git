function [Results] = loadResults(saveDir, combineLFPs, numRuns)
%LOADRESULTS loads the results of a simulation run.
%   RESULTS = LOADRESULTS(SAVEDIR) loads the simulation results saved by
%   runSimulation(). SAVEDIR is a character array (string) specifying the
%   directory where the simulation results were saved. RESULTS is a
%   structure with several fields that store the loaded results.
%
%   RESULTS.spikes contains the spike times of all neurons in the model in
%   an n by 2 matrix (where n is the total number of spikes from all
%   neurons). Its first column contains the IDs of the neurons that spiked,
%   and its second column contains the corresponding spike times in
%   milliseconds.
%
%   RESULTS.v_m contains the soma membrane potentials of any neurons that
%   were recorded during the simulation run. Each row contains the data for
%   one recorded neuron, and each column is a membrane potential sample.
%
%   RESULTS.LFP contains the simulated local field potentials at each
%   electrode. Each row contains the data for one electrode, and each
%   column contains an extracellular potential sample. If you specified for
%   the LFP to be calculated offline, then the LFP will be calculated by
%   LOADRESULTS from the saved membrane currents of all the neurons. This
%   can take some time, depending on the size of the model and the number
%   of electrodes.
%
%   RESULTS.params is another structure containing the model parameters,
%   including extra values that were calculated by VERTEX during
%   initialisation such as the neuron group boundaries, and the lab index
%   that each neuron was on if running in parallel mode.
%
%   RESULTS = LOADRESULTS(SAVEDIR, COMBINELFPS) also allows you to
%   tell LOADRESULTS whether to combine the LFP due to each group into a
%   total compound LFP (as done by default), or whether to keep the group
%   LFP contributions separate. If COMBINELFPS is set to true, then
%   RESULTS.LFP will be a numGroups x 1 cell array, with each group's
%   (postsynaptic) contribution to the LFP in each cell. The contents of
%   the cells can be summed to get the total LFP.
%
%   RESULTS = LOADRESULTS(SAVEDIR, COMBINELFPS, NUMRUNS) is for use when you have
%   modified runSimulation() to perform several simulation runs (for example,
%   to keep the variable values from the end of the previous simulation run
%   but change some model parameters). NUMRUNS is the number of simulation
%   runs you performed within your implementation of runSimulation().

if ~strcmpi(saveDir(end), '/')
    saveDir = [saveDir '/'];
end

if nargin == 1
    numRuns = 1;
    combineLFPs = true;
elseif nargin == 2
    numRuns = 1;
end

params = load([saveDir 'parameters.mat']);
pFields = fields(params);

% Order of cells in parameterCell:
% TissueParams, NeuronParams, ConnectionParams, RecordingSettings,
% SimulationSettings
TP = params.(pFields{1}){1};
NP = params.(pFields{1}){2};
CP = params.(pFields{1}){3};
RS = params.(pFields{1}){4};
SS = params.(pFields{1}){5};
%Sarr = params.(pFields{1}){6};
%StP = params.(pFields{1}){7};

% Calculate relevant numbers for loading recordings
SS.simulationTime = SS.simulationTime * numRuns;
numSaves = floor(SS.simulationTime/RS.maxRecTime);
maxRecSamples = round(RS.maxRecSamples);
maxRecSteps = RS.maxRecSteps;
minDelaySteps = SS.minDelaySteps;
simulationSamples = length(RS.samplingSteps)+1; %(SS.simulationTime*(RS.sampleRate / 1000));

if SS.parallelSim
    numLabs = SS.poolSize;
else
    numLabs = 1;
end

% Has v_m been recorded?
if isfield(RS, 'v_m')
    v_m = RS.v_m;
else
    v_m = false;
end

% Has I_syn been recorded?
if isfield(RS, 'I_syn')
    I_syn = RS.I_syn;
else
    I_syn = false;
end

if isfield(RS, 'I_synComp')
    I_synComp = RS.I_synComp;
else
    I_synComp = false;
end
if isfield(RS, 'stp_syn')
    stp_syn = RS.stp_syn;
else
    stp_syn = false;
end


if isfield(RS, 'stdpvars')
    stdpvars = RS.stdpvars;
else
    stdpvars = false;
end
if isfield(RS, 'weights_preN_IDs')
    weights = RS.weights_preN_IDs;
else
    weights = false;
end
if isfield(RS, 'weights_arr')
    weightsarr = true;
else
    weightsarr = false;
end
if ~isfield(RS, 'CSD')
    RS.CSD = 0;
end

if ~RS.CSD
    CSD = [];
end
if ~isfield(RS, 'I_synComp')
    RS.I_synComp = 0;
end

if ~isfield(RS, 'DV')
    RS.DV = 0;
end
% Are we to calculate the LFP offline?
if isfield(RS, 'LFPoffline') && RS.LFPoffline
    LFPoffline = true;
    LineSourceConsts = cell(numLabs, 1);
    for iLab = 1:numLabs
        if SS.parallelSim
            fName = sprintf('%sLineSourceConsts_%d.mat', saveDir, iLab);
        else
            fName = sprintf('%sLineSourceConsts.mat', saveDir);
        end
        lsc = load(fName);
        ff = fields(lsc);
        LineSourceConsts{iLab} = lsc.(ff{1});
    end
else
    LFPoffline = false;
end

% Create matrix to store loaded LFP
if RS.LFP
    numElectrodes = length(RS.meaXpositions(:));
    if combineLFPs
        LFP = zeros(numElectrodes, simulationSamples);
    else
        LFP = cell(TP.numGroups, 1);
        for iGroup = 1:TP.numGroups
            LFP{iGroup} = zeros(numElectrodes, simulationSamples);
        end
    end
else
    LFP = [];
end

% Create matrix to store loaded v_m
if v_m
    v_m_recording = zeros(length(RS.v_m), simulationSamples);
    if SS.parallelSim
        intraCount = 0;
        intraIDmap = zeros(length(v_m), 1);
    end
else
    v_m_recording = [];
end

if RS.DV
    DV_recording = zeros(length(RS.DV), simulationSamples);
    if SS.parallelSim
        DVCount = 0;
        DVIDmap = zeros(length(RS.DV), 1);
    end
else
    DV_recording = [];
end

spikeCell = cell(numSaves*ceil(maxRecSteps / minDelaySteps), 1);

% Create matrix to store loaded I_syn
if I_syn
    I_syn_recording = cell(TP.numGroups, 1);
    for iGroup=1:TP.numGroups
        I_syn_recording{iGroup} = zeros(length(RS.I_syn), simulationSamples);
    end
    if SS.parallelSim
        I_synCount = 0;
        I_synIDmap = zeros(length(I_syn), 1);
    end
else
    I_syn_recording = [];
end

if stp_syn
    stp_syn_recording = cell(2, TP.numGroups);
    for iType=1:2
        for iPostGroup = 1:TP.numGroups
            stp_syn_recording{iType, iPostGroup} = zeros(length(RS.stp_syn), simulationSamples);
        end
    end
    if SS.parallelSim
        stp_synCount = 0;
        stp_synIDmap = [];
    end
else
    stp_syn_recording = [];
end

if stdpvars
    stdpvars_recording = cell(2, TP.numGroups);
    for iType=1:2
        for iPostGroup = 1:TP.numGroups
            stdpvars_recording{iType, iPostGroup} = zeros(length(RS.stdpvars), simulationSamples);
        end
    end
    if SS.parallelSim
        stdpvarsCount = 0;
        stdpvarsIDmap = [];
    end
else
    stdpvars_recording = [];
end

if weights
    weights_recording = cell(length(RS.weights_preN_IDs),1);
    postNIDs = cell(length(RS.weights_preN_IDs),1);
    if SS.parallelSim
        weights_syn_count = ones(length(weights_recording),1);
        weights_synIDmap = [];
    end
else
    weights_recording = [];
    postNIDs = [];
end
    synArr = [];
    weights_arr= [];
if weightsarr
    wcount = cell(length(RS.weights_arr),1);
    for i = 1:length(wcount)
        wcount{i} =  zeros(TP.N,1);
    end
    syncount = zeros(TP.N,1);
    synArr = cell(TP.N,1);
    allpost = cell(length(RS.weights_arr),1);
    allpre = cell(length(RS.weights_arr),1);
    allweight = cell(length(RS.weights_arr),1);
    weightsarr_rec= cell(length(RS.weights_arr),1);
    
else
    synArr = [];
    weights_arr= [];
    
end

if RS.CSD 
    CSD = cell(TP.numGroups,1);
    if SS.parallelSim
        csdCount = cell(TP.numGroups,1);
        CSDIDMap = cell(TP.numGroups,1);
        
        for iGroup = 1:TP.numGroups
            csdCount{iGroup} = 0;
            CSDIDMap{iGroup} = zeros(length(RS.CSD_NeuronIDs{iGroup}),1);
        end
    end
end

if RS.I_synComp 
    I_synComp = cell(length(RS.I_synComp_groups),1);
    if SS.parallelSim
        I_synCompCount = cell(length(RS.I_synComp_groups),1);
        I_synCompIDMap = cell(length(RS.I_synComp_groups),1);
        
        for i = 1:length(RS.I_synComp_groups)
            I_synCompCount{i} = 0;
            I_synCompIDMap{i} = zeros(length(RS.I_synComp_NeuronIDs{i}),1);
        end
    end
end
    

%Recording number
sampleCount = 0;

% Load each save file in turn and store in the relevant matrices
numSpikeTransmissions = 0;
for iSaves = 1:numSaves
    for iLab = 1:numLabs
        disp(['Lab: ' num2str(iLab)]);
        if SS.parallelSim
            fName = sprintf('%sRecordings%d_%d.mat', saveDir, iSaves, iLab);
        else
            fName = sprintf('%sRecordings%d', saveDir, iSaves);
        end
        
        loadedData = load(fName);
        ff = fields(loadedData);
        
        RecordingVars = loadedData.(ff{1});
        % Load
        if v_m
            if SS.parallelSim
                if isfield(RecordingVars, 'intraRecording')
                    ir = RecordingVars.intraRecording;
                    v_m_recording(intraCount+1:intraCount+size(ir,1), ...
                        sampleCount+1:sampleCount+size(ir, 2)) = ir;
                    
                    intraID = find(SS.neuronInLab(v_m) == iLab);
                    intraIDmap(intraCount+1:intraCount+size(intraID)) = intraID;
                    intraCount = intraCount+size(ir,1);
                end
            else
                ir = RecordingVars.intraRecording;
                v_m_recording(:, sampleCount+1:sampleCount+size(ir, 2)) = ir;
            end
        end
        if I_syn
            if SS.parallelSim
                if isfield(RecordingVars, 'I_synRecording')
                    i_Syn = RecordingVars.I_synRecording;
                    for iGroup = 1:size(i_Syn, 2)
                        I_syn_recording{iGroup}(I_synCount+1:I_synCount+size(i_Syn,1), ...
                            sampleCount+1:sampleCount+size(i_Syn, 3)) = ...
                            squeeze(i_Syn(:,iGroup,:));
                    end
                    I_synID = find(SS.neuronInLab(I_syn) == iLab);
                    I_synIDmap(I_synCount+1:I_synCount+size(I_synID)) = I_synID;
                    I_synCount = I_synCount+size(i_Syn,1);
                end
            else
                i_Syn = RecordingVars.I_synRecording;
                for iGroup = 1:TP.numGroups
                    I_syn_recording{iGroup}(:, sampleCount+1:sampleCount+size(i_Syn, 3)) = ...
                        squeeze(i_Syn(:,iGroup,:));
                end
            end
        end
        
        if stp_syn
            if SS.parallelSim
                if isfield(RecordingVars, 'stp_synRecording')
                    stp_Syn = RecordingVars.stp_synRecording;
                    for itype = 1:size(stp_Syn{1},2)
                        for iPostGroup = 1:TP.numGroups
                            stp_syn_recording{itype,iPostGroup}(stp_synCount+1:stp_synCount+size(stp_Syn{iPostGroup},1), ...
                                sampleCount+1:sampleCount+size(stp_Syn{iPostGroup}, 3)) = ...
                                squeeze(stp_Syn{iPostGroup}(:,itype,:));
                        end
                    end
                    
                    stp_synID = find(SS.neuronInLab(stp_syn) == iLab);
                    stp_synIDmap(stp_synCount+1:stp_synCount+size(stp_synID)) = stp_synID;
                    stp_synCount = stp_synCount+size(stp_Syn{1},1);
                end
            else
                stp_Syn = RecordingVars.stp_synRecording;
                for itype = 1:size(stp_Syn{1},2)
                    stp_syn_recording{itype, iPostGroup}(:, sampleCount+1:sampleCount+size(stp_Syn{itype}, 3)) = ...
                        squeeze(stp_Syn{itype}(:,iPostGroup,:));
                end
            end
        end
        if stdpvars
            if SS.parallelSim
                if isfield(RecordingVars, 'stdpvarsRecording')
                    stdpVars = RecordingVars.stdpvarsRecording;
                    for itype = 1:2
                        for neuronGroup = 1:TP.numGroups
                            stdpvars_recording{itype, neuronGroup}(stdpvarsCount+1:stdpvarsCount+size(stdpVars{itype},1), ...
                                sampleCount+1:sampleCount+size(stdpVars{itype}, 3)) = ...
                                squeeze(stdpVars{itype}(:,neuronGroup,:));
                        end
                    end
                    
                    stdpvarsID = find(SS.neuronInLab(stdpvars) == iLab);
                    stdpvarsIDmap(stdpvarsCount+1:stdpvarsCount+size(stdpvarsID)) = stdpvarsID;
                    stdpvarsCount = stdpvarsCount+size(stdpvarsID);
                end
            else
                stdpVars = RecordingVars.stdpvarsRecording;
                for itype = 1:2
                    for neuronGroup = 1:TP.numGroups
                        stdpvars_recording{itype, neuronGroup}(:, sampleCount+1:sampleCount+size(stdpVars{itype}, 3)) = ...
                            squeeze(stdpVars{itype}(:,neuronGroup,:));
                    end
                end
            end
        end
        if weights
            if SS.parallelSim
                if isfield(RecordingVars, 'weightsRecording')
                    weightsRec = RecordingVars.weightsRecording;
                    synapseIDs = RecordingVars.synapsepostIDs;
                    for preID = 1:length(weightsRec)
                        weights_recording{preID}(weights_syn_count(preID):weights_syn_count(preID)+ size(weightsRec{preID},2)-1,sampleCount+1:sampleCount+size(weightsRec{preID}, 1)) = ...
                            weightsRec{preID}';
                        postNIDs{preID}(weights_syn_count(preID):weights_syn_count(preID)+size(weightsRec{preID},2)-1) = synapseIDs{preID};
                        weights_syn_count(preID) = weights_syn_count(preID) + size(weightsRec{preID},2);
                    end
                end
                
            else
                weightsRec = RecordingVars.weightsRecording;
                synapseIDs = RecordingVars.synapsepostIDs;
                for preID = 1:length(weightsRec)
                    weights_recording{preID}(:,sampleCount+1:sampleCount+size(weightsRec{preID}, 1)) = ...
                        weightsRec{preID}';
                    postNIDs{preID} = synapseIDs{preID};
                end
            end
        end
        
        if weightsarr
            if SS.parallelSim
                if isfield(RecordingVars, 'WeightArrRec')
                    for iRec = 1:length(RecordingVars.WeightArrRec)
                        
                        for iN = 1:length(RecordingVars.WeightArrRec{iRec})
                            weights_arr{iRec}{iN}(wcount{iRec}(iN)+1:wcount{iRec}(iN)+length(RecordingVars.WeightArrRec{iRec}{iN})) = RecordingVars.WeightArrRec{iRec}{iN};
                            wcount{iRec}(iN) = wcount{iRec}(iN) + length(RecordingVars.WeightArrRec{iRec}{iN});
                        end
                    end
                    for iN = 1:length(RecordingVars.synArr(:,1))
                        synArr{iN,1}(syncount(iN)+1:syncount(iN)+length(RecordingVars.synArr{iN})) =  RecordingVars.synArr{iN,1};
                        synArr{iN,2}(syncount(iN)+1:syncount(iN)+length(RecordingVars.synArr{iN})) =  RecordingVars.synArr{iN,2};
                        synArr{iN,3}(syncount(iN)+1:syncount(iN)+length(RecordingVars.synArr{iN})) =  RecordingVars.synArr{iN,3};
                        
                        syncount(iN) = syncount(iN)+ length(RecordingVars.synArr{iN,1});
                    end
                    
                end
                
            else
                if isfield(RecordingVars, 'WeightArrRec')
                    weights_arr = RecordingVars.WeightArrRec;
                    synArr = RecordingVars.synArr;
                end
            end
        end
        if RS.I_synComp
            I_synCompCurrent = RecordingVars.I_synCompRecording;
            for i = 1:length(RS.I_synComp_groups)
                iGroup = RS.I_synComp_groups(i);
                I_synCompID = find(SS.neuronInLab(RS.I_synComp_NeuronIDs{i}) == iLab);
                I_synCompIDMap{i}(I_synCompCount{i}+1:I_synCompCount{i}+size(I_synCompID)) = I_synCompID;
                I_synComp{i}(I_synCompCount{i}+1:I_synCompCount{i}+size(I_synCompCurrent{iGroup},1), 1:NP(iGroup).numCompartments,sampleCount+1:sampleCount+size(I_synCompCurrent{iGroup},3)) = I_synCompCurrent{iGroup};
                I_synCompCount{i} = I_synCompCount{i}+size(I_synCompCurrent{iGroup},1);
            end
            
        end
        if RS.DV
            if SS.parallelSim
                if isfield(RecordingVars, 'DVRecording')
                    dv = RecordingVars.DVRecording;
                    DV_recording(DVCount+1:DVCount+size(dv,1), ...
                        sampleCount+1:sampleCount+size(dv, 2)) = dv;
                    
                    DVID = find(SS.neuronInLab(RS.DV) == iLab);
                    DVIDmap(DVCount+1:DVCount+size(DVID)) = DVID;
                    DVCount = DVCount+size(dv,1);
                end
            else
                dv = RecordingVars.DVRecording;
                DV_recording(:, sampleCount+1:sampleCount+size(dv, 2)) =dv;
            end
        end
        if RS.CSD 
            csd = RecordingVars.CSDRecording;
            for iGroup = 1:TP.numGroups
                CSDID = find(SS.neuronInLab(RS.CSD_NeuronIDs{iGroup}) == iLab);
                CSDIDMap{iGroup}(csdCount{iGroup}+1:csdCount{iGroup}+size(CSDID)) = CSDID;
                CSD{iGroup}(csdCount{iGroup}+1:csdCount{iGroup}+size(csd{iGroup},1), 1:NP(iGroup).numCompartments,sampleCount+1:sampleCount+size(csd{iGroup},3)) = csd{iGroup};
                csdCount{iGroup} = csdCount{iGroup}+size(csd{iGroup},1);
            end
            
        end
        if RS.LFP
            lr = RecordingVars.LFPRecording;
            if LFPoffline
                for iGroup = 1:TP.numGroups
                    for iElec = 1:numElectrodes
                        if combineLFPs
                            LFP(iElec, sampleCount+1:sampleCount+maxRecSamples) = ...
                                LFP(iElec, sampleCount+1:sampleCount+maxRecSamples) +...
                                squeeze(sum(sum( bsxfun(@times, ...
                                lr{iGroup},LineSourceConsts{iLab}{iGroup,iElec}))))';
                        else
                            LFP{iGroup}(iElec, sampleCount+1:sampleCount+maxRecSamples) = ...
                                LFP{iGroup}(iElec, sampleCount+1:sampleCount+maxRecSamples) + ...
                                squeeze(sum(sum( bsxfun(@times, ...
                                lr{iGroup},LineSourceConsts{iLab}{iGroup,iElec}))))';
                        end
                    end
                end
            else
                for iGroup = 1:TP.numGroups
                    if combineLFPs

                        LFP(:, sampleCount+1:sampleCount+size(lr{iGroup},2)) = ...
                            LFP(:, sampleCount+1:sampleCount+size(lr{iGroup},2)) + ...
                            lr{iGroup};
                    else
                        LFP{iGroup}(:, sampleCount+1:sampleCount+size(lr{iGroup},2)) = ...
                            LFP{iGroup}(:, sampleCount+1:sampleCount+size(lr{iGroup},2)) + ...
                            lr{iGroup};
                    end
                end
            end
        end
        
        sr = RecordingVars.spikeRecording;
        for iSpk = 1:size(sr, 1)
            if ~isempty(sr{iSpk})
                d = cell2mat(sr{iSpk}(1, 2));
                d = double(minDelaySteps - d) + ...
                    ((iSpk-1) * double(minDelaySteps)) + ...
                    ((iSaves-1) * double(maxRecSteps));
                id = double(cell2mat(sr{iSpk}(1, 1)));
                
                spikeCell{iSpk + numSpikeTransmissions} = ...
                    [spikeCell{iSpk + numSpikeTransmissions}; ...
                    [double(id), double(d).*SS.timeStep]];
            end
        end
    end % numLabs
    numSpikeTransmissions = numSpikeTransmissions + size(sr,1);
    %numSpikeTransmissions = 0;
    sampleCount = sampleCount + maxRecSamples;
    intraCount = 0;
    DVCount = 0;
end % numSaves

spikes = cell2mat(spikeCell);
if SS.parallelSim && ~isempty(v_m_recording)
    v_m_recording(intraIDmap, :) = v_m_recording;
end
if SS.parallelSim && ~isempty(DV_recording)
    DV_recording(DVIDmap, :) = DV_recording;
end
if SS.parallelSim && ~isempty(I_syn_recording)
    for iGroup = 1:TP.numGroups
        I_syn_recording{iGroup}(I_synIDmap, :) = I_syn_recording{iGroup};
    end
end
if SS.parallelSim && ~isempty(stp_syn_recording)
    
    for iPostGroup = 1:TP.numGroups
        for itype = 1:2
            temp = zeros(max(stp_synIDmap),size(stp_syn_recording{itype,iPostGroup},2));
            count = 1;
            for i = stp_synIDmap
                temp(i,:) = temp(i,:) + stp_syn_recording{itype,iPostGroup}(count,:);
                count = count+1;
            end
            stp_syn_recording{itype,iPostGroup} = temp;
        end
    end
end
if SS.parallelSim && ~isempty(stdpvars_recording)
    for iPostGroup = 1:TP.numGroups
        for itype = 1:2
            stdpvars_recording{itype,iPostGroup}(stdpvarsIDmap, :) = stdpvars_recording{itype,iPostGroup};
        end
    end
end
if SS.parallelSim && ~isempty(CSD)
    for iGroup = 1:TP.numGroups
       CSD{iGroup}(CSDIDMap{iGroup}, :,:) = CSD{iGroup};
    end
end
if SS.parallelSim && ~isempty(I_synComp)
    if iscell(I_synComp)
        for iGroup = 1:length(RS.I_synComp_groups)
           I_synComp{iGroup}(I_synCompIDMap{iGroup}, :,:) = I_synComp{iGroup};
        end
    end
end
% Store loaded results in cell array to return
Results.spikes = spikes;
Results.LFP = LFP;
Results.v_m = v_m_recording;
Results.DV = DV_recording;
Results.I_syn = I_syn_recording;
Results.stp_syn = stp_syn_recording;
Results.stdpvars = stdpvars_recording;
Results.weights = weights_recording;
Results.synapsePostIDs = postNIDs;
Results.weights_arr = weights_arr;
Results.syn_arr = synArr;
Results.I_synComp = I_synComp;
Results.csd = CSD;
Results.params.TissueParams = TP;
Results.params.NeuronParams = NP;
Results.params.ConnectionParams = CP;
Results.params.RecordingSettings = RS;
Results.params.SimulationSettings = SS;
% Results.params.SynArr= Sarr;
% Results.params.StimParams = StP;