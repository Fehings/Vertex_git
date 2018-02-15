

%Recording settings
%These describe which variables to record, we are interested in membrane
%potentials and local field potentials. 
%We save the results of the simulation in this folder, they can be loaded
%at any time after the simulation has finished by loading into memory the
%Results file. Use Results = loadResults(RecordingSettings.saveDir); to do
%this.
RecordingSettings.LFP = false;
[meaX, meaY, meaZ] = meshgrid(1500:-100:800, 300, 2000:-200:300);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
%RecordingSettings.v_m = 1:100:33312;
RecordingSettings.maxRecTime = 2400;
RecordingSettings.sampleRate = 2500;
%RecordingSettings.weights_preN_IDs = 1:1:100;
RecordingSettings.weights_arr = [1 25568 57600 70400];
RecordingSettings.v_m = [6400:6600];
RecordingSettings.weights_preN_IDs = [6400:6600];
RecordingSettings.stdpvars = [6400:6600];
%RecordingSettings.I_syn = [6200:1:6500];
%RecordingSettings.v_m = [18000:18200 39700:39900];
%RecordingSettings.weights_preN_IDs = [39700:39900];
%RecordingSettings.stdpvars = [18000:18200 39700:39900];
%Simulation settings:
%Keep max delay steps at 80, 
%Simulation time can be varied, it is in milliseconds, currently running
%for 500 ms.
%We want to run this simulation in parallel, this means that all cpu cores
%will be utilised in the simulations, with the neurons being distributed
%across them, as this simulation is large this is necessary to minimize the
%run time of the simulation. 
SimulationSettings.maxDelaySteps = 80;
SimulationSettings.simulationTime = 80;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim =true;

%%
%This initialises the network and sets up other variables. 
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

%%
runSimulation(params, connections, electrodes);