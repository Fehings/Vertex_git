
% set up the two identical layers by calling setup_multilayer and cloning
% the parameters for the second region.

%tutorial_3_params;
%setup_multiregion_withinboundconnection;
setup_multiregion_allstdp;

RecordingSettings.saveDir = '~/VERTEX_results_multiregion/stimstdp2reg';
RecordingSettings.weights_arr = 1:5000:6000;
RecordingSettings.LFP = true;
RecordingSettings.weights_preN_IDs = 2972:3000;
%RecordingSettings.samplingSteps = 1:10:10000;
[meaX, meaY, meaZ] = meshgrid(0:100:2000, 5:95:395, 195:-95:5);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.v_m = 100:200:1200;%100:1000:4000;%250:250:4750;
RecordingSettings.maxRecTime = 100;
RecordingSettings.sampleRate = 1000;
SimulationSettings.simulationTime = 800;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
%SimultationSetings.onTopsy = true;

% optional - step current stimulation to neurons to see spread of activity
% through region to region connections

% NeuronParams(1).Input(2).inputType = 'i_step';
% NeuronParams(1).Input(2).timeOn = 50;
% NeuronParams(1).Input(2).timeOff = 100;
% NeuronParams(1).Input(2).amplitude = 1000; 

% % 
  [stlresult,model] = invitroSliceStim('tutorial2_3.stl',4);
  TissueParams.StimulationField = stlresult;
  %invitroSliceStimAC('tutorial2_3.stl',SimulationSettings.timeStep,4,40);
  TissueParams.StimulationOn = 0;
 TissueParams.StimulationOff = SimulationSettings.simulationTime;
% 

[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

 % clone the slice to create an identical second region.\
 % (if wanting two differing regions you will need to call a second version
 % of setup_multilayer with mofified parameters and then initialise this
 % new network with another call of initNetwork. As commented out below:
 
 clear TissueParams NeuronParams ConnectionParams
 %setup_multiregion_withinboundconnection;
 setup_multiregion_allstdp;
 
   TissueParams.StimulationField = stlresult;
     TissueParams.StimulationOn = 0;
 TissueParams.StimulationOff = SimulationSettings.simulationTime;
%NeuronParams(1).Input(1).meanInput = 50;
ConnectionParams(1).tau{1} = 20;
ConnectionParams(1).tau{2} = 10;
ConnectionParams(1).tau{3} = 10;
%NeuronParams(2).Input(1).meanInput = 20;
ConnectionParams(2).tau{1} = 60;
ConnectionParams(2).tau{2} = 30;
ConnectionParams(2).tau{3} = 10;
 
 %this should overwrite the parameters used to initialise the first region
 %with the parameters for the new region, which can then be initialised:
   [params2, connections2, electrodes2] = ...
   initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
%  
%   params2 = params;
%   connections2 = connections;
%   electrodes2 = electrodes;    
         
         
%%  
 % defining the between region connectivity here:
 regionConnect.map = [0,1000;0,0];%
 % for example [1,1;0,1] there are two regions and there is only an
 % external connection from region 1 to region 2, it is not returned, and
 % while they do connect to themselves internally for the sake of incoming external
 % connections the diagonals are set to 0.
 
 % Identify the neuron types (e.g. NP(1) in this instance are the
 % excitatory PY cells) which will export signals. Use [] if not exporting.
 regionConnect.exportingNeuronPops{1} = 1; 
 regionConnect.exportingNeuronPops{2} = 1;
 %regionConnect.exportingNeuronPops{3} = [];
 % identify which neuron pops are designated as dummy neurons to just
 % recieve external signals. (May need to change this if having a different
 % implementation of the dummy neurons.) Use [] if no dummy neurons are
 % present.
 regionConnect.dummyNeuronPops{1} = 3;
 regionConnect.dummyNeuronPops{2} = 3;
% regionConnect.dummyNeuronPops{3} = 3;
 
 
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
% 
 plotSpikeRaster(multiRegResults(1))
 title('Region 1')
 plotSpikeRaster(multiRegResults(2))
 title('Region 2')
% % plotSpikeRaster(Results(3))
% % title('Region 3')
% figure
% plot(mean(multiRegResults(1).LFP))
% hold on
% plot(mean(multiRegResults(2).LFP))
%plot(mean(Results(3).LFP,2))

% hold off
% 
% r1time1weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{1},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);
% %r1time2weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{4},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);
% %r1time3weights=getSparseConnectivityWeights(Results(1).weights_arr{3},Results(1).syn_arr,Results(1).params.TissueParams.N);
% r1time4weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{4},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);
% r2time1weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{1},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);
% %r2time2weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{4},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);
% %r2time3weights=getSparseConnectivityWeights(Results(2).weights_arr{3},Results(2).syn_arr,Results(2).params.TissueParams.N);
% r2time4weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{4},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);
% 
% figure
% imagesc(r1time2weights - r1time1weights)
% title('Region1 weight changes')
% figure
% imagesc(r2time2weights - r2time1weights)
% title('Region2 weight changes')
