

% setting up parameters, in this case a simple IN + EX model
setup_multiregion_allstdp; 
% I know it says 'multiregion' in the name here but it is also valid for a single region! 
% This setup script pulls in all the tissue, neuron and connection paramters
% which are generally left unchanged, and in this case it includes spike timing dependent plasticity enabled synapses. 



% save results - change this for your computer:
RecordingSettings.saveDir = '~/Documents/MATLAB/Vertex_Results/stdp_test';

%% recording settings 

RecordingSettings.weights_arr = 1:1000:50000; % times to record weights for the whole network
%RecordingSettings.weights_preN_IDs = 4950:10:5000; % Neuron IDs of individual neurons to record weights from
%RecordingSettings.samplingSteps = 1:10:10000; % time steps to record these neurons at
RecordingSettings.LFP = true; % we do want to record the LFP
[meaX, meaY, meaZ] = meshgrid(0:100:2000, 5:95:395, 195:-95:5); % set up the electrode positions to record the LFP at
RecordingSettings.meaXpositions = meaX; % assign these electrode positions
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20; 
%RecordingSettings.v_m = 100:200:1200; % neuron IDs to record the soma membrane potential from during the simulation
RecordingSettings.maxRecTime = 1000; 
RecordingSettings.sampleRate = 1000;

% how long the simulation runs for... 
SimulationSettings.simulationTime = 1000; % miliseconds
SimulationSettings.timeStep = 0.03125; 
SimulationSettings.parallelSim = false; %true

% uncomment to set a noise seed other than the default (127 twister)
% SimulationSettings.randomSeed = 1;

%% Stimulation
% optional - step current stimulation 
% uncomment for short burst of stimulation at a given time period

% NeuronParams(1).Input(2).inputType = 'i_step';
% NeuronParams(1).Input(2).timeOn = 200;
% NeuronParams(1).Input(2).timeOff = 250;
% NeuronParams(1).Input(2).amplitude = 1000; 

% optional - electric field stimulation
% uncomment for field stimulation
% 
  value_to_change = 6; % field strength
  [stlresult,model] = invitroSliceStim('tutorial2_3.stl',value_to_change);
  TissueParams.StimulationField = stlresult;
  TissueParams.StimulationOn = 0;
  TissueParams.StimulationOff = SimulationSettings.simulationTime;

% optional - rotate the electric field around a given axis
% uncomment for field rotation
%
% SimulationSettings.RotateField.angle=3;
% SimulationSettings.RotateField.axis='x';

%% Initialise the network
% set up the slice:
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);


%% run the thing 
 
runSimulation(params,connections,electrodes);

%% Raster and LFP plots
% need to use loadResults to load the results 
Results = loadResults(RecordingSettings.saveDir);

 plotSpikeRaster(Results)

 figure
 plot(mean(Results.LFP))
