Results.params.SimulationSettings.parallelSim=false;
[~, electrodes] = setupLFPConstants(Results.params.NeuronParams, Results.params.RecordingSettings, Results.params.SimulationSettings, Results.params.TissueParams);
%%
[~, NeuronIDs] = getNeuronsBetween(Results.params.TissueParams, 14, Results.params.RecordingSettings.CSD_Xboundary(2,:),Results.params.RecordingSettings.CSD_Yboundary(2,:), Results.params.RecordingSettings.CSD_Zboundary(2,:));
iElectrode = 2;
iGroup = 14;
    LSM= ...
        cell2mat(electrodes(NeuronIDs, iElectrode)')';
  
%%
%%
% For the figure the couple of neurons that spike during the stimulation
% period were removed to make the graph clearer. This removes the couple of
% spikes seen here, in the trunk and soma.
NP = Results.params.NeuronParams(14);
NP.labelnames = {'somaID','basalID','obliqueID','apicalID','trunkID','tuftID'};
times = [7500 9500];
figure;
plotCSDSingleNeuron(Results,(Results.csd{14}),times,NP);
figure;
plotCSDSingleNeuron(Results,(Results.csd{14}),times,NP,LSM);