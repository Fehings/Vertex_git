addpath(genpath('~/Vertex_git'))
loadRatTissueandNeuronParamsDefault;
TissueParams.neuronDensity = 103730;
loadRatConnectionParams;
setUpBipolarElectrodeStimulation
tic;
RecordingSettings.saveDir = '/nobackup/b3046588/with_axons/';
runRatSimulation
toc

disp('finished running rat neocortex')