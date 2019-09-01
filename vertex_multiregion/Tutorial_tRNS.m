

% setting up parameters, in this case a simple IN + EX model
setup_multiregion; % I know it says 'multiregion' in the name here but it is also valid for a single region!

% uncomment for stdp
%setup_multiregion_allstdp;


% save results - change this for your computer:
RecordingSettings.saveDir = '~/Documents/MATLAB/Vertex_Results/VERTEX_results_tRNS/trns_test';

%% recording settings 

% times to record weights
%RecordingSettings.weights_arr = 1:1000:50000;
% which weights to record (a subset)
%RecordingSettings.weights_preN_IDs = 4950:10:5000;
%RecordingSettings.samplingSteps = 1:10:10000;
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(0:100:2000, 5:95:395, 195:-95:5);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.v_m = 100:200:1200;%100:1000:4000;%250:250:4750;
RecordingSettings.maxRecTime = 1000;
RecordingSettings.sampleRate = 1000;

% how long the simulation runs for... 
SimulationSettings.simulationTime = 1000; %ms
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;

%% Stimulation
% optional - step current stimulation 
% uncomment for short burst of stimulation at a given time period

% NeuronParams(1).Input(2).inputType = 'i_step';
% NeuronParams(1).Input(2).timeOn = 200;
% NeuronParams(1).Input(2).timeOff = 250;
% NeuronParams(1).Input(2).amplitude = 1000; 



% uncomment for field stimulation
% 
  value_to_change = 6; % field strength
  [stlresult,model] = invitroSliceStim('tutorial2_3.stl',value_to_change);
%stlresult = load('ACpderesult40hz10mv')
%  TissueParams.StimulationField = stlresult.result;
  TissueParams.StimulationOn = 0;
  TissueParams.StimulationOff = SimulationSettings.simulationTime;
%  TissueParams.tRNS = wgn(1,1,0); % initialising the tRNS
% SimulationSettings.RotateField.angle=3;
% SimulationSettings.RotateField.axis='x';
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
