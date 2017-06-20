

%Recording settings
%These describe which variables to record, we are interested in membrane
%potentials and local field potentials. 
%We save the results of the simulation in this folder, they can be loaded
%at any time after the simulation has finished by loading into memory the
%Results file. Use Results = loadResults(RecordingSettings.saveDir); to do
%this.
RecordingSettings.saveDir = '~/VERTEX_rat_somatosensory_sliceSTDP/';
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(500, 200, 200:300:2000);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
%RecordingSettings.v_m = 1:100:33312;
RecordingSettings.maxRecTime = 10000;
RecordingSettings.sampleRate = 2500;
%RecordingSettings.weights_preN_IDs = 1:1:100;
RecordingSettings.weights_arr = 1:32000:320000;
RecordingSettings.v_m = 1:1:10000;
RecordingSettings.weights_preN_IDs = 6000:1:6100;
%Simulation settings:
%Keep max delay steps at 80, 
%Simulation time can be varied, it is in milliseconds, currently running
%for 500 ms.
%We want to run this simulation in parallel, this means that all cpu cores
%will be utilised in the simulations, with the neurons being distributed
%across them, as this simulation is large this is necessary to minimize the
%run time of the simulation. 
SimulationSettings.maxDelaySteps = 80;
SimulationSettings.simulationTime = 10001;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim =true;

%%
%This initialises the network and sets up other variables. 
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

%%
runSimulation(params, connections, electrodes);