% A model with 3 regions, connected sequentially (A -> B -> C)
% Including a step current stimulation in the first region (A)

% setting up parameters, in this case a simple IN + EX model
setup_multiregion_withinboundconnection; % I know it says 'multiregion' in the name here but it is also valid for a single region!

% uncomment for stdp
%setup_multiregion_allstdp;

% save results - change this for your computer:
RecordingSettings.saveDir = '~/Documents/MATLAB/Vertex_Results/results_multiregion/reg3_l23_stim_sequential';

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
RecordingSettings.v_m = 100:200:1200;
RecordingSettings.maxRecTime = 1000;
RecordingSettings.sampleRate = 1000;

% how long the simulation runs for... 
SimulationSettings.simulationTime = 500; %ms
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;

%% Stimulation
% optional - step current stimulation 
% uncomment for short burst of stimulation at a given time period

NeuronParams(1).Input(2).inputType = 'i_step'; % step current
NeuronParams(1).Input(2).timeOn = 200;         
NeuronParams(1).Input(2).timeOff = 250;
NeuronParams(1).Input(2).amplitude = 1000; 

%% Region 1: set up the slice:

[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

%% second region

clear NeuronParams % need to clear the stimulation

setup_multiregion_withinboundconnection; 


[params2, connections2, electrodes2] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);



%% third region
          
params3 = params2;
connections3 = connections2;
electrodes3 = electrodes2;

          
%% Connecting them up! 
 % defining the between region connectivity here:
 regionConnect.map =  [0,1,0;0,0,1;0,0,0];
 % there are two regions and there is only an
 % external connection from region 1 to region 2, it is not returned, and
 % while they do connect to themselves internally for the sake of incoming external
 % connections the diagonals are set to 0.
 
 % Identify the neuron types (e.g. NP(1) in this instance are the
 % excitatory PY cells) which will export signals. Use [] if not exporting.
 regionConnect.exportingNeuronPops{1} = 1; 
 regionConnect.exportingNeuronPops{2} = 1; 
 regionConnect.exportingNeuronPops{3} = []; 

 
 % identify which neuron pops are designated as dummy neurons to just
 % recieve external signals. (May need to change this if having a different
 % implementation of the dummy neurons.) Use [] if no dummy neurons are
 % present.
 regionConnect.dummyNeuronPops{1} = 3;
 regionConnect.dummyNeuronPops{2} = 3;
 regionConnect.dummyNeuronPops{3} = 3;


%% simulation loop

SimulationSettings.randomSeed = 127; % manually setting the noise seed, the default is 127.
setRandomSeed(SimulationSettings);

% run the simulation and time:
tic
runSimulationMultiregional({params, params2, params3},{connections, connections2, connections3},{electrodes, electrodes2, electrodes3},regionConnect);
toc


%% Raster and LFP plots
% need to use loadResults to load the results 
 Results = loadResultsMultiregions(RecordingSettings.saveDir);

 plotSpikeRaster(Results(1))
 plotSpikeRaster(Results(3))
 
 %%
 figure
 plot(mean(Results(1).LFP))
 hold on
 plot(mean(Results(2).LFP))
 hold on
 plot(mean(Results(3).LFP))
 legend('Region 1','Region 2','Region 3')
 xlabel('Time (ms)')
 ylabel('LFP (mV)')
