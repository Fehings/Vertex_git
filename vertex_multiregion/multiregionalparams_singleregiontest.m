
setup_multiregion_allstdp;


RecordingSettings.saveDir = '~/VERTEX_results_multiregion';
RecordingSettings.weights_arr = 1:100:6000;
RecordingSettings.LFP = true;
RecordingSettings.weights_preN_IDs = 1:500:5000;
%RecordingSettings.samplingSteps = 1:10:10000;
[meaX, meaY, meaZ] = meshgrid(0:100:2000, 5:95:395, 195:-95:5);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.v_m = 250:250:4750;
RecordingSettings.maxRecTime = 500;
RecordingSettings.sampleRate = 1000;
SimulationSettings.simulationTime = 50;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;


[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

runSimulation(params,connections,electrodes);
%%
Results = loadResults(RecordingSettings.saveDir);

