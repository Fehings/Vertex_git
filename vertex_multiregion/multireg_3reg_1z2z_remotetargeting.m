

% setting up parameters, in this case a simple IN + EX model
setup_multiregion_withinboundconnection; % I know it says 'multiregion' in the name here but it is also valid for a single region!

% uncomment for stdp
%setup_multiregion_allstdp;


% save results - change this for your computer:
RecordingSettings.saveDir = '~/Documents/MATLAB/Vertex_Results/thesis_results_multiregion/DCfield2reg_l23_zerostim';

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

%% Region 1
% optional - step current stimulation 
% uncomment for short burst of stimulation at a given time period

% NeuronParams(1).Input(2).inputType = 'i_step';
% NeuronParams(1).Input(2).timeOn = 200;
% NeuronParams(1).Input(2).timeOff = 250;
% NeuronParams(1).Input(2).amplitude = 1000; 


  stlresult = load('zerostimfield_cvc')
  TissueParams.StimulationField = stlresult.result;
  TissueParams.StimulationOn = 0;
  TissueParams.StimulationOff = SimulationSettings.simulationTime;
% SimulationSettings.RotateField.angle=3;
% SimulationSettings.RotateField.axis='x';
% set up the slice:

[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

%% second region

%  stlresult = load('zerostimfield_cvc')
%   TissueParams.StimulationField = stlresult.result;
%   TissueParams.StimulationOn = 0;
%   TissueParams.StimulationOff = SimulationSettings.simulationTime;
% SimulationSettings.RotateField.angle=3;
% SimulationSettings.RotateField.axis='x';
% set up the slice:

% [params2, connections2, electrodes2] = ...
%   initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
%               RecordingSettings, SimulationSettings);

params2 = params;
connections2 = connections;
electrodes2 = electrodes;


%% third region
          
clear TissueParams.StimulationField TissueParams.StimulationOn TissueParams.StimulationOff

% same again but with no stimulation:
   [params3, connections3, electrodes3] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings); 
          
          
%%  
 % defining the between region connectivity here:
 regionConnect.map =  [0,0,1;0,0,1;0,0,0];
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

formatspec = '/Users/a6028564/Documents/MATLAB/Vertex_Results/PaperResults_Multiregion/L23_3reg_1-3zero_2-3zero_noiseseed%d';

noises = 2:30;

for rseed = 1:length(noises)

    SimulationSettings.randomSeed = noises(rseed); % manually setting the noise seed, the default is 127.
    setRandomSeed(SimulationSettings);
    
    params.RecordingSettings.saveDir = sprintf(formatspec,noises(rseed));
    
   % run the simulation and time:
    tic
    runSimulationMultiregional({params,params2,params3},{connections, connections2, connections3},{electrodes, electrodes2, electrodes3},regionConnect);
    toc
end


%% Raster and LFP plots
% need to use loadResults to load the results 
% Results = loadResultsMultiregions(RecordingSettings.saveDir);
% 
%  plotSpikeRaster(Results(1))
% 
%  plotSpikeRaster(Results(2))
%  
%  figure
%  plot(mean(Results(1).LFP))
% hold on
%  plot(mean(Results(2).LFP))
