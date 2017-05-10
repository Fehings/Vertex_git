
% set up the two identical layers by calling setup_multilayer and cloning
% the parameters for the second region.

%setup_multiregion;

RecordingSettings.saveDir = '~/VERTEX_results_multiregion';
SimulationSettings.simulationTime = 500;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;

% [params, connections, electrodes] = ...
%   initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
%               RecordingSettings, SimulationSettings);

 % clone the slice to create an identical second region.\
 % (if wanting two differing regions you will need to call a second version
 % of setup_multilayer with mofified parameters and then initialise this
 % new network with another call of initNetwork. As commented out below:
 
 setup_multiregion_withinboundconnection;
 %this should overwrite the parameters used to initialise the first region
 %with the parameters for the new region, which can then be initialised:
  [params2, connections2, electrodes2] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
 
 
 % do I need to define the connectivity between the regions here? 
 
 regionConnect = [0,1;0,0];
 % in this case [1,1;0,1] there are two regions and there is only an
 % external connection from region 1 to region 2, it is not returned, and
 % while they do connect to themselves internally for the sake of incoming external
 % connections the diagonals are set to 0.
 
 %stack the parameters for params, connections and electrodes into cell
 %arrrays which can then be fed into runSimulationMultiregional
 paramStacked = {params2}%,params2};
 connectionStacked = {connections2}%,connections2};
 electrodeStacked = {electrodes2} %,electrodes2};
 
runSimulationMultiregional(paramStacked,connectionStacked,electrodeStacked,regionConnect);

Results = loadResultsMultiregions(RecordingSettings.saveDir);