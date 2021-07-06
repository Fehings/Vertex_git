
cvc_tissue;
cvc_neurons_withdummy;
cvc_connectivity_withdummy;
cvc_recording;
cvc_simulation;
%cvc_field_stimulation;

SS.simulationTime = 200; % change back to 500 
SS.parallelSim = false;


% Change this directory to where you would like to save the results of the
% simulation
RS.saveDir = '~/Documents/MATLAB/Vertex_Results/cvc_multiregion';

%% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);

% Clone the other regions from the first!
params2 = params;
connections2 = connections;
electrodes2 = electrodes;
 
%% Region connectivity
 % defining the between region connectivity here. If you have connection (fibre) lengths
 % in mm then a matrix of fibre lengths can also be passed here, and delays will
 % be calculated automatically, assuming a transmission speed of 120mm/ms
 
 regionConnect.map = [1,1; 1,1];
 
 % for example [1,1;0,1] there are two regions and there is only an
 % external connection from region 1 to region 2, it is not returned, and
 % while they do connect to themselves internally for the sake of incoming external
 % connections the diagonals are set to 0.
 
 % Identify the neuron types (e.g. NP(1) in this instance are the
 % excitatory PY cells) which will export signals. Use [] if not exporting.
 regionConnect.exportingNeuronPops{1} = 1; 
 regionConnect.exportingNeuronPops{2} = 1;
 % identify which neuron pops are designated as dummy neurons to just
 % recieve external signals. (May need to change this if having a different
 % implementation of the dummy neurons.) Use [] if no dummy neurons are
 % present.
 regionConnect.dummyNeuronPops{1} = 16;
 regionConnect.dummyNeuronPops{2} = 16;
%% Stack parameters and run multiregion simulation
%stack the parameters for params, connections and electrodes into cell
%arrrays which can then be fed into runSimulationMultiregional
paramStacked = {params, params2};
connectionStacked = {connections,connections2};
electrodeStacked = {electrodes,electrodes2};

tic
runSimulationMultiregional(paramStacked,connectionStacked,electrodeStacked,regionConnect);
toc
%% Load the simulation results
Results = loadResultsMultiregions(RS.saveDir);

%% Plotting
% 
% % Slice schematic:
% rasterParams.colors = {'k','c','g','y','m','r','b','c','k','m','b','g','r','k','c'};
% pars.colors = rasterParams.colors;
% pars.opacity=0.6;
% pars.markers = {'^','p','h','*','x','^','p','h','d','v','p','h','d','v','p'};
% N = Results.params.TissueParams.N;
% pars.toPlot = 1:3:N;
% plotSomaPositions(Results.params.TissueParams,pars);
% 
% % LFP 
% figure
% plot(mean(Results.LFP))
% xlabel('time steps')
% ylabel('LFP mV')
% title('Mean LFP')
% % Might be good to plot for each layer?
% 
% % Spike Raster:
% plotSpikeRaster(Results,pars)
% xlabel('time steps')
% ylabel('Neuron ID')
% title('Spike Raster')
