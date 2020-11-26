
% set up the two regions by calling setup scripts for the parameters

% setting up parameters, in this case with non-stdp synapses, oscillations, in simple IN + EX
% model
setup_multiregion_withinboundconnection;


% save results - change this:
RecordingSettings.saveDir = '~/Documents/MATLAB/Vertex_Results/VERTEX_results_multiregion/hetreg_test';

%% recording settings 


%RecordingSettings.weights_arr = 1:500:1000;
%RecordingSettings.weights_preN_IDs = 2972:3000;
%RecordingSettings.samplingSteps = 1:10:10000;
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(0:100:2000, 5:95:395, 195:-95:5);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.v_m = 100:200:1200;%100:1000:4000;%250:250:4750;
RecordingSettings.maxRecTime = 1000;
RecordingSettings.sampleRate = 500;

% how long the simulation runs for... 
SimulationSettings.simulationTime = 100;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;

% optional - step current stimulation 
% uncomment for short burst of stimulation at a given time period
% can use to show that the connections are working

% NeuronParams(1).Input(2).inputType = 'i_step';
% NeuronParams(1).Input(2).timeOn = 200;
% NeuronParams(1).Input(2).timeOff = 250;
% NeuronParams(1).Input(2).amplitude = 1000; 


% set up the slice:
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

          
          
 %% set up a second region

 % clone the slice to create an identical second region.\
 % (if wanting two differing regions you will need to call a second version
 % of setup_multilayer with mofified parameters and then initialise this
 % new network with another call of initNetwork.
 
clear TissueParams NeuronParams ConnectionParams
% wipe the previous parameters and establish some new ones:
setup_multiregion_noisy;

% number of synapses from external region connections
ConnectionParams(3).numConnectionsToAllFromOne{1} = 3000;
 % interregional connection weights
ConnectionParams(3).weights{1} = 0.5;
 
 %this should overwrite the parameters used to initialise the first region
 %with the parameters for the new region, which can then be initialised:
   [params2, connections2, electrodes2] = ...
   initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
  

         
%%  Connectivity between regions

 % defining the between region connectivity here:
 regionConnect.map = [0,1;0,0];
 % for example [0,1;0,0] there are two regions and there is only an
 % external connection from region 1 to region 2, it is not returned, and
 % while they do connect to themselves internally for the sake of incoming external
 % connections the diagonals are set to 0.
 
 % Identify the neuron types (e.g. NP(1) in this instance are the
 % excitatory PY cells) which will export signals. Use [] if not exporting.
 regionConnect.exportingNeuronPops{1} = 2; 
 regionConnect.exportingNeuronPops{2} = [];
 
 % identify which neuron pops are designated as dummy neurons to just
 % recieve external signals. Use [] if no dummy neurons are
 % present.
 regionConnect.dummyNeuronPops{1} = [];
 regionConnect.dummyNeuronPops{2} = 3;

 
 
 %%  Run the simulation
 %stack the parameters for params, connections and electrodes into cell
 %arrrays which can then be fed into runSimulationMultiregional
 paramStacked = {params, params2};
 connectionStacked = {connections,connections2};
 electrodeStacked = {electrodes,electrodes2};
 
runSimulationMultiregional(paramStacked,connectionStacked,electrodeStacked,regionConnect);

%% Load and plot
% need to use a Multiregions variant of loadResults to load the results for
% every region in one structure. 
multiRegResults = loadResultsMultiregions(RecordingSettings.saveDir);

% spike raster plots
 plotSpikeRaster(multiRegResults(1))
 title('Region 1')
 plotSpikeRaster(multiRegResults(2))
 title('Region 2')

 % average local field potential
 figure
 plot(mean(multiRegResults(1).LFP))
 hold on
 plot(mean(multiRegResults(2).LFP))

 % could also do a frequency plot to compare oscillation frequencies in the
 % different regions? Look up fft!
