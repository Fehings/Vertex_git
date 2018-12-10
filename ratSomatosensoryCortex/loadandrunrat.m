
addpath(genpath('~/Vertex_git'))
loadRatTissueandNeuronParams;
loadRatConnectionParams;
setUpBipolarElectrodeStimulation
loadSimulationSettings
tic;
RecordingSettings.saveDir = '/nobackup/b3046588/without_axons/';

runRatSimulation
toc
