
% set up the two identical layers by calling setup_multilayer and cloning
% the parameters for the second region.

% setting up parameters, in this case with stdp synapses and simple IN + EX
% model
setup_multiregion_allstdp;


% save results - change this:
RecordingSettings.saveDir = '~/Documents/MATLAB/Vertex_Results/VERTEX_results_multiregion/mk01_test';

%% recording settings 

% only need to worry about weights!
% times to record weights
RecordingSettings.weights_arr = 1:500:1000;

% which weights to record (a subset)
RecordingSettings.weights_preN_IDs = 4547:5:5000;

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
SimulationSettings.simulationTime = 10;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;

% optional - step current stimulation 
% uncomment for short burst of stimulation at a given time period


% NeuronParams(1).Input(2).inputType = 'i_step';
% NeuronParams(1).Input(2).timeOn = 200;
% NeuronParams(1).Input(2).timeOff = 250;
% NeuronParams(1).Input(2).amplitude = 1000; 



% uncomment for field stimulation

%   [stlresult,model] = invitroSliceStim('tutorial2_3.stl',4);
%   TissueParams.StimulationField = stlresult;
%   TissueParams.StimulationOn = 0;
%  TissueParams.StimulationOff = SimulationSettings.simulationTime;

% set up the slice:
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);


 % clone the slice to create an identical second region.\
 % (if wanting two differing regions you will need to call a second version
 % of setup_multilayer with mofified parameters and then initialise this
 % new network with another call of initNetwork. As commented out below:
 
 %% set up a second region
clear TissueParams NeuronParams ConnectionParams

setup_multiregion_allstdp;


% uncomment for field stimulation

%  TissueParams.StimulationField = stlresult;
%  TissueParams.StimulationOn = 0;
% TissueParams.StimulationOff = SimulationSettings.simulationTime;

 
 %this should overwrite the parameters used to initialise the first region
 %with the parameters for the new region, which can then be initialised:
   [params2, connections2, electrodes2] = ...
   initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
  

         
%%  Connectivity between regions

 % defining the between region connectivity here:
 regionConnect.map = [0,1;1,0];
 % for example [1,1;0,1] there are two regions and there is only an
 % external connection from region 1 to region 2, it is not returned, and
 % while they do connect to themselves internally for the sake of incoming external
 % connections the diagonals are set to 0.
 
 % Identify the neuron types (e.g. NP(1) in this instance are the
 % excitatory PY cells) which will export signals. Use [] if not exporting.
 regionConnect.exportingNeuronPops{1} = 1; 
 regionConnect.exportingNeuronPops{2} = 1;
 
 % identify which neuron pops are designated as dummy neurons to just
 % recieve external signals. Use [] if no dummy neurons are
 % present.
 regionConnect.dummyNeuronPops{1} = 3;
 regionConnect.dummyNeuronPops{2} = 3;

 
 
 %% stack the parameters for params, connections and electrodes into cell
 %arrrays which can then be fed into runSimulationMultiregional
 paramStacked = {params, params2};
 connectionStacked = {connections,connections2};
 electrodeStacked = {electrodes,electrodes2};
 
runSimulationMultiregional(paramStacked,connectionStacked,electrodeStacked,regionConnect);

%%
% need to use a Multiregions variant of loadResults to load the results for
% every region in one structure. 
multiRegResults = loadResultsMultiregions(RecordingSettings.saveDir);

 plotSpikeRaster(multiRegResults(1))
 title('Region 1')
 plotSpikeRaster(multiRegResults(2))
 title('Region 2')

 figure
 plot(mean(multiRegResults(1).LFP))
 hold on
 plot(mean(multiRegResults(2).LFP))


hold off
 
r1time1weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{1},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);
r1time2weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{2},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);

r2time1weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{1},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);
r2time2weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{2},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);
 

%nnz - number of non- zero elements, check for changes
%nnz(r1time2weights - r1time1weights)

% spy - plots white for zero, black for non-zero
% spy(r1time2weights - r1time1weights)

figure
imagesc(r1time2weights - r1time1weights)
title('Region1 weight changes')
figure
imagesc(r2time2weights - r2time1weights)
title('Region2 weight changes')
