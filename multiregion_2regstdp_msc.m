
% set up the two identical layers by calling the setup script and cloning
% the parameters for the second region.


setup_multiregion_allstdp;  % call the setup script

% set a save directory for the simulation results. 
%%% NB!! Modify this to fit your computer's file system %%%
RecordingSettings.saveDir = '~/Documents/MATLAB/Vertex_Results/VERTEX_results_multiregion/mr4reg_diamond_nodelay_stdp_nostim_05startweight_3kconnects';

RecordingSettings.LFP = false;  % we do want to record the local field potential
RecordingSettings.weights_preN_IDs = [1:966:3864,3865:171:4546,4547:50:5000]; % set connection weights to record
[meaX, meaY, meaZ] = meshgrid(0:100:2000, 5:95:395, 195:-95:5);  % make a grid of electrode positions
RecordingSettings.meaXpositions = meaX; % set the grid positions into the VERTEX readable structure
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20; 
RecordingSettings.v_m = 100:200:1200; % specify neuron IDs to record from directly
RecordingSettings.maxRecTime = 100; 
RecordingSettings.sampleRate = 1000; 
SimulationSettings.simulationTime = 100; % simulation time! Modify as you like.
SimulationSettings.timeStep = 0.03125; 
SimulationSettings.parallelSim = false; % run in parallel if you like, not neccessarily worth it for short simulations.
%SimultationSetings.onTopsy = true; % if running on a HPC use this option.
%Otherwise ignore.

% specify time points to take snapshots of the entire network weightings
RecordingSettings.weights_arr = [1 (SimulationSettings.simulationTime/SimulationSettings.timeStep)-1]; % simulation steps


%%% optional - step current stimulation to neurons to see spread of activity
%%% through region to region connections

NeuronParams(1).Input(2).inputType = 'i_step';
NeuronParams(1).Input(2).timeOn = 200;
NeuronParams(1).Input(2).timeOff = 250;
NeuronParams(1).Input(2).amplitude = 1000; 

%%% optional - electric field stimulation 

% [stlresult,model] = invitroSliceStim('tutorial2_3.stl',4);
% TissueParams.StimulationField = stlresult;
% TissueParams.StimulationOn = 0;
% TissueParams.StimulationOff = SimulationSettings.simulationTime;


%% initialise the network

[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);


%%  clone the slice to create an identical second region.

  
params2 = params;
connections2 = connections;
electrodes2 = electrodes;         
          
%%% NB: if wanting two differing regions you will need to call a second version
%%% of setup_multilayer with mofified parameters and then initialise this
%%% new network with another call of initNetwork. As commented out below:
 
% clear TissueParams NeuronParams ConnectionParams
% setup_multiregion_gexp;
% setup_multiregion_withinboundconnection;
% setup_multiregion_allstdp;
 
%%% this should overwrite the parameters used to initialise the first region
%%% with the parameters for the new region, which can then be initialised:

%  [params2, connections2, electrodes2] = ...
%   initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
%               RecordingSettings, SimulationSettings);
%   
          

          
%% Set the connectivity between regions

 % defining the between region connectivity here:
 regionConnect.map = [0,1;0,0];
 % for example [1,1;0,1] there are two regions and there is only an
 % external connection from region 1 to region 2, it is not returned, and
 % while they do connect to themselves internally for the sake of incoming external
 % connections the diagonals are set to 0.
 % NB: Values represent delays, so a binary connectivity map means no delay is
 % present. 
 
 % Identify the neuron types (e.g. NP(1) in this instance are the
 % excitatory PY cells) which will export signals. Use [] if not exporting.
 regionConnect.exportingNeuronPops{1} = 1; % 1 represents neuron population 1, the excitatory Pyramidal cells.
 regionConnect.exportingNeuronPops{2} = 1;
 regionConnect.exportingNeuronPops{3} = 1;
 regionConnect.exportingNeuronPops{4} = 1;
 
 
 % identify which neuron pops are designated as dummy neurons to just
 % recieve external signals. Use [] if no dummy neurons are present.
 regionConnect.dummyNeuronPops{1} = 3;
 regionConnect.dummyNeuronPops{2} = 3;
 regionConnect.dummyNeuronPops{3} = 3;
 regionConnect.dummyNeuronPops{4} = 3;
 
 
 
 %% Run the simulation
 
 %stack the parameters for params, connections and electrodes into cell
 % arrays which can then be fed into runSimulationMultiregional
 paramStacked = {params, params2};
 connectionStacked = {connections,connections2};
 electrodeStacked = {electrodes,electrodes2};
 
tic
runSimulationMultiregional(paramStacked,connectionStacked,electrodeStacked,regionConnect);
toc


%% Plotting!

% need to use a Multiregions variant of loadResults to load the results for
% every region in one structure: 
multiRegResults = loadResultsMultiregions(RecordingSettings.saveDir);

% plot the spike raster for each region
 plotSpikeRaster(multiRegResults(1))
 title('Region 1')
 plotSpikeRaster(multiRegResults(2))
 title('Region 2')

% plot the mean LFP for both regions, and the difference between them
 figure
 subplot(311)
 plot(mean(multiRegResults(1).LFP))
 title('Region 1 averaged LFP')
 subplot(312)
 plot(mean(multiRegResults(2).LFP))
 title('Region 2 averaged LFP')
 subplot(313)
 plot(mean(multiRegResults(1).LFP) - mean(multiRegResults(2).LFP))
 title('Difference in averaged LFP')


% get the weights for the whole network at the first and last time
% snapshots in a plottable form:
 r1time1weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{1},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);%
 r1time2weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{2},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);
 r2time1weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{1},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);
 r2time2weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{2},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);

% plot the weight differences between the start and end of the simulation
% for each network. Colours represent the weight changes.
figure
imagesc(r1time2weights - r1time1weights)
title('Region1 weight changes')
figure
imagesc(r2time2weights - r2time1weights)
title('Region2 weight changes')


