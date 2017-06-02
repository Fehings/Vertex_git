

tutorial_3_params;

RecordingSettings.saveDir = '~/VERTEX_results_multiregion_test';
%RecordingSettings.weights_arr = 1:500:1000;
SimulationSettings.simulationTime = 300;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = true;
 
regionConnect.map = 0;
regionConnect.exportingNeuronPops{1} = []; 
regionConnect.dummyNeuronPops{1} = [];

TissueParams.StimulationField = invitroSliceStim('tutorial2_3.stl',100);
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = SimulationSettings.simulationTime;

          
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
 
paramsS{1}= params;
connectionsS{1}= connections;
electrodesS{1}=electrodes;

          
 runSimulationMultiregional(paramsS, connectionsS, electrodesS, regionConnect);          
 Results1 = loadResultsMultiregions(RecordingSettings.saveDir);

runSimulation(params, connections, electrodes);
Results2 = loadResults(RecordingSettings.saveDir);          

% [result,model] = invitroSliceStim('tutorial2_3.stl',50);
%  pdeplot3D(model,'ColorMapData', result.NodalSolution, 'FaceAlpha', 0.2);
%  hold on
%  plotSomaPositions(Results2.params.TissueParams)
%  
 
 hold off
 plotSpikeRaster(Results1)
 plotSpikeRaster(Results2)