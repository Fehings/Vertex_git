

% set up the two identical layers by calling setup_multilayer and cloning
% the parameters for the second region.
 
 setup_multiregion_withinboundconnection;
 
RecordingSettings.saveDir = '~/VERTEX_results_2regionconnected/stim1000R1toR2';
RecordingSettings.weights_arr = 1:4000:16000;

[meaX, meaY, meaZ] = meshgrid(0:100:2000, 5:95:395, 195:-95:5);  % make a grid of electrode positions
RecordingSettings.meaXpositions = meaX; % set the grid positions into the VERTEX readable structure
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.LFP = true;  % we do want to record the local field potential
RecordingSettings.maxRecTime = 100; 
RecordingSettings.sampleRate = 1000; 

SimulationSettings.simulationTime = 500;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
% 
[TissueParams.StimulationField,model] = invitroSliceStim('tutorial2_3.stl',100);
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 0;%SimulationSettings.simulationTime;
 
% optional - step current stimulation to neurons to see spread of activity
% through region to region connections
% 
%  NeuronParams(1).Input(2).inputType = 'i_step';
%  NeuronParams(1).Input(2).timeOn = 50;
%  NeuronParams(1).Input(2).timeOff = 100;
%  NeuronParams(1).Input(2).amplitude = 1000; 
 
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
 
 % clone the slice to create an identical second region.\
 % (if wanting two differing regions you will need to call a second version
 % of setup_multilayer with mofified parameters and then initialise this
 % new network with another call of initNetwork. As commented out below:
 
 clear TissueParams NeuronParams ConnectionParams
 
 
 setup_multiregion_withinboundconnection;
 
 [params2, connections2, electrodes2] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
 
% params2 = params;
% connections2 = connections;
% electrodes2 = electrodes;
 
params3 = params2;
connections3 = connections2;
electrodes3 = electrodes2;

 params4 = params2;
connections4 = connections2;
electrodes4 = electrodes2;

params5 = params2;
connections5 = connections2;
electrodes5 = electrodes2;

 
%%  
 % defining the between region connectivity here. If you have connection (fibre) lengths
 % in mm then a matrix of fibre lengths can also be passed here, and delays will
 % be calculated automatically, assuming a transmission speed of 120mm/ms
 
 regionConnect.map = [0,1,0,0,0; 0,0,1,0,0; 0,0,0,1,0; 0,0,0,0,1; 1,0,0,0,0];
 % for example [1,1;0,1] there are two regions and there is only an
 % external connection from region 1 to region 2, it is not returned, and
 % while they do connect to themselves internally for the sake of incoming external
 % connections the diagonals are set to 0.
 
 % Identify the neuron types (e.g. NP(1) in this instance are the
 % excitatory PY cells) which will export signals. Use [] if not exporting.
 regionConnect.exportingNeuronPops{1} = 1; 
 regionConnect.exportingNeuronPops{2} = 1;
 regionConnect.exportingNeuronPops{3} = 1;
 regionConnect.exportingNeuronPops{4} = 1;
 regionConnect.exportingNeuronPops{5} = 1;
 % identify which neuron pops are designated as dummy neurons to just
 % recieve external signals. (May need to change this if having a different
 % implementation of the dummy neurons.) Use [] if no dummy neurons are
 % present.
 regionConnect.dummyNeuronPops{1} = [];
 regionConnect.dummyNeuronPops{2} = 3;
 regionConnect.dummyNeuronPops{3} = 3;
 regionConnect.dummyNeuronPops{4} = 3;
 regionConnect.dummyNeuronPops{5} = 3;

 %stack the parameters for params, connections and electrodes into cell
 %arrrays which can then be fed into runSimulationMultiregional
 paramStacked = {params, params2};
 
 paramStacked = {params, params2, params3, params4, params5};
 connectionStacked = {connections, connections2, connections3, connections4, connections5};
 electrodeStacked = {electrodes, electrodes2, electrodes3, electrodes4, electrodes5};



 
runSimulationMultiregional(paramStacked,connectionStacked,electrodeStacked,regionConnect);
 
% need to use a Multiregions variant of loadResults to load the results for
% every region in one structure. 
Results = loadResultsMultiregions(RecordingSettings.saveDir);
% 
 
[TissueParams.StimulationField,model] = invitroSliceStim('tutorial2_3.stl',100);
figure; 
pdeplot3D(model,'ColorMapData', TissueParams.StimulationField.NodalSolution, 'FaceAlpha', 0.2);
hold on
plotSomaPositions(Results(1).params.TissueParams)
hold on
scatter3(RecordingSettings.meaXpositions(:),RecordingSettings.meaYpositions(:),RecordingSettings.meaZpositions(:),'*')
 
 
plotSpikeRaster(Results(1))
title('Region 1')
plotSpikeRaster(Results(2))
title('Region 2')
plotSpikeRaster(Results(3))
title('Region 3')
plotSpikeRaster(Results(4))
title('Region 4')
plotSpikeRaster(Results(5))
title('Region 5')

figure
plot(mean(Results(1).LFP,2))
hold on
plot(mean(Results(2).LFP,2))
hold on
plot(mean(Results(3).LFP,2))
hold on
plot(mean(Results(4).LFP,2))
hold on
plot(mean(Results(5).LFP,2))

