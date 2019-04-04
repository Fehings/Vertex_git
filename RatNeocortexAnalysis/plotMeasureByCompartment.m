function [outputArg1,outputArg2] = plotMeasureByCompartment(Results,times)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Results.params.SimulationSettings.parallelSim=false;
[~, electrodes] = setupLFPConstants(Results.params.NeuronParams, Results.params.RecordingSettings, Results.params.SimulationSettings, Results.params.TissueParams);
%%
[~, NeuronIDs] = getNeuronsBetween(Results.params.TissueParams, 14, Results.params.RecordingSettings.CSD_Xboundary(2,:),Results.params.RecordingSettings.CSD_Yboundary(2,:), Results.params.RecordingSettings.CSD_Zboundary(2,:));
iElectrode = 18;
iGroup = 14;
    LSM= ...
        cell2mat(electrodes(NeuronIDs, iElectrode)')';
  
%%
%%
NP = Results.params.NeuronParams(14);
NP.labelnames = {'somaID','basalID','obliqueID','apicalID','trunkID','tuftID'};
figure;
plotCSDSingleNeuron(Results,Results.csd{14},times,NP);
figure;
plotCSDSingleNeuron(Results,Results.csd{14},times,NP,LSM);
end

