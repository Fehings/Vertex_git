
% set up the two identical layers by calling setup_multilayer and cloning
% the parameters for the second region.

%tutorial_3_params;
%setup_multiregion_withinboundconnection;
setup_multiregion_allstdp;
%setup_multiregion_gexp;



RecordingSettings.saveDir = '~/Documents/MATLAB/Vertex_Results/VERTEX_results_multiregion/mr2reg_nodelay_stdp_r1stim_linearconnect_2s';
%RecordingSettings.weights_arr = 
RecordingSettings.LFP = true;
RecordingSettings.weights_preN_IDs = [1:966:3864,3865:171:4546,4547:50:5000];%2972:3000;
%RecordingSettings.samplingSteps = 1:10:10000;
[meaX, meaY, meaZ] = meshgrid(0:100:2000, 5:95:395, 195:-95:5);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.v_m = 100:200:1200;%100:1000:4000;%250:250:4750;
RecordingSettings.maxRecTime = 100;
RecordingSettings.sampleRate = 1000;
SimulationSettings.simulationTime = 2000;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
%SimultationSetings.onTopsy = true;
RecordingSettings.weights_arr = 1:10000:SimulationSettings.simulationTime/SimulationSettings.timeStep; % simulation steps

% optional - step current stimulation to neurons to see spread of activity
% through region to region connections

% NeuronParams(1).Input(2).inputType = 'i_step';
% NeuronParams(1).Input(2).timeOn = 400;
% NeuronParams(1).Input(2).timeOff = 420;
% NeuronParams(1).Input(2).amplitude = 1000; 

% 
  %[stlresult,model] = invitroSliceStim('tutorial2_3.stl',4);


[params2, connections2, electrodes2] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);


 % clone the slice to create an identical second region.\
 % (if wanting two differing regions you will need to call a second version
 % of setup_multilayer with mofified parameters and then initialise this
 % new network with another call of initNetwork. As commented out below:
 
    brainslice3Dorig
 TissueParams.StimulationField = result;
  %invitroSliceStimAC('tutorial2_3.stl',SimulationSettings.timeStep,4,40);
 TissueParams.StimulationOn = 0;
 TissueParams.StimulationOff = SimulationSettings.simulationTime;
       
 
 [params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

 
 
%clear TissueParams NeuronParams ConnectionParams
 %setup_multiregion_gexp;
 %setup_multiregion_withinboundconnection;
%setup_multiregion_allstdp;
 
 %  TissueParams.StimulationField = stlresult;
 %    TissueParams.StimulationOn = 0;
% TissueParams.StimulationOff = SimulationSettings.simulationTime;
%NeuronParams(1).Input(1).meanInput = 50;
%ConnectionParams(1).tau{1} = 20;
%ConnectionParams(1).tau{2} = 10;
%ConnectionParams(1).tau{3} = 10;
%NeuronParams(2).Input(1).meanInput = 20;
%ConnectionParams(2).tau{1} = 60;
%ConnectionParams(2).tau{2} = 30;
%ConnectionParams(2).tau{3} = 10;
%  
 % params2 = params;
 % connections2 = connections;
 % electrodes2 = electrodes;         
% could overwrite the parameters used to initialise the first region
% with the parameters for the new region, which can then be initialised:
%    [params2, connections2, electrodes2] = ...
%    initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
%               RecordingSettings, SimulationSettings);
          
%     params2 = params3;
%    connections2 = connections3;
%    electrodes2 = electrodes3;  
%           
%           
% %    params3 = params2;
% %    connections3 = connections2;
% %    electrodes3 = electrodes2;    
%        
%    params4 = params2;
%    connections4 = connections2;
%    electrodes4 = electrodes2; 
   
         
%%  
 % defining the between region connectivity here:
 regionConnect.map = [0,1;1,0];
  % [0,1,0,0;0,0,1,0;0,0,0,1;1,0,0,0];% [0,5000,5000,0;0,0,0,5000;0,0,0,5000;5000,0,0,0]%
 % for example [1,1;0,1] there are two regions and there is only an
 % external connection from region 1 to region 2, it is not returned, and
 % while they do connect to themselves internally for the sake of incoming external
 % connections the diagonals are set to 0.
 
 % Identify the neuron types (e.g. NP(1) in this instance are the
 % excitatory PY cells) which will export signals. Use [] if not exporting.
 regionConnect.exportingNeuronPops{1} = 1; 
 regionConnect.exportingNeuronPops{2} = 1;
% regionConnect.exportingNeuronPops{3} = 1;
% regionConnect.exportingNeuronPops{4} = 1;
 
 
 % identify which neuron pops are designated as dummy neurons to just
 % recieve external signals. (May need to change this if having a different
 % implementation of the dummy neurons.) Use [] if no dummy neurons are
 % present.
 regionConnect.dummyNeuronPops{1} = 3;
 regionConnect.dummyNeuronPops{2} = 3;
% regionConnect.dummyNeuronPops{3} = 3;
% regionConnect.dummyNeuronPops{4} = 3;
 
 
 %% stack the parameters for params, connections and electrodes into cell
 %arrrays which can then be fed into runSimulationMultiregional
 paramStacked = {params2, params}%,params3,params4};
 connectionStacked = {connections2,connections}%,connections3,connections4};
 electrodeStacked = {electrodes2,electrodes}%,electrodes3,electrodes4};
 
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
 % plotSpikeRaster(multiRegResults(3))
 %title('Region 3')
%   plotSpikeRaster(multiRegResults(4))
%  title('Region 4')
% plotSpikeRaster(Results(3))
% title('Region 3')
 figure
 plot(mean(multiRegResults(1).LFP))
 hold on
 plot(mean(multiRegResults(2).LFP))
 %plot(mean(multiRegResults(3).LFP))
 %plot(mean(multiRegResults(4).LFP))

 
%% 
hold off
% 
r1time1weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{1},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);
%r1time2weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{4},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);
%r1time3weights=getSparseConnectivityWeights(Results(1).weights_arr{3},Results(1).syn_arr,Results(1).params.TissueParams.N);
r1time4weights=getSparseConnectivityWeights(multiRegResults(1).weights_arr{4},multiRegResults(1).syn_arr,multiRegResults(1).params.TissueParams.N);
r2time1weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{1},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);
%r2time2weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{4},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);
%r2time3weights=getSparseConnectivityWeights(Results(2).weights_arr{3},Results(2).syn_arr,Results(2).params.TissueParams.N);
r2time4weights=getSparseConnectivityWeights(multiRegResults(2).weights_arr{4},multiRegResults(2).syn_arr,multiRegResults(2).params.TissueParams.N);

%r3time1weights=getSparseConnectivityWeights(multiRegResults(3).weights_arr{1},multiRegResults(3).syn_arr,multiRegResults(3).params.TissueParams.N);
%r3time4weights=getSparseConnectivityWeights(multiRegResults(3).weights_arr{4},multiRegResults(3).syn_arr,multiRegResults(3).params.TissueParams.N);


figure
subplot(1,2,1)
imagesc(abs(r1time4weights - r1time1weights))
title('Region1 weight changes')
subplot(1,2,2)
imagesc(abs(r2time4weights - r2time1weights))
title('Region2 weight changes')
%figure
%imagesc(abs(r3time4weights - r3time1weights))
%title('Region3 weight changes')
