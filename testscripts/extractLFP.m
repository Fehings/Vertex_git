function LFP = extractLFP(RecVar,params)

%numSaves = floor(params.SimulationSettings.simulationTime/params.RecordingSettings.maxRecTime);
%maxRecSamples = round(params.RecordingSettings.maxRecSamples);

if params.SimulationSettings.parallelSim
    numLabs = params.SimulationSettings.poolSize;
else
    numLabs = 1;
end

simulationSamples = length(params.RecordingSettings.samplingSteps)+1;

numElectrodes = length(params.RecordingSettings.meaXpositions(:));
LFP = zeros(numElectrodes, simulationSamples);


sampleCount = 0;

for iLab = 1:numLabs
    if numLabs>1
        labrec = RecVar{iLab};
    else
        labrec=RecVar;
    end
    lr=labrec.LFPRecording;
    for iGroup = 1:params.TissueParams.numGroups
        LFP(:, 1:size(lr{iGroup},2)) = ...
            LFP(:,1:size(lr{iGroup},2)) + ...
            lr{iGroup};
        
    end
    
%    sampleCount=sampleCount+maxRecSamples;
end

end