%% Ferret visual cortex model

% right click and select 'open cvc_---' to modify the below parameters
cvc_tissue; % read in the tissue parameters, including the slice dimensions and the neuron density
cvc_neurons_gamma; % read in the neurons and their properties, in this case they are set with noise input to approximate gamma oscillations
cvc_connectivity_gamma_update; % load in the connectivity parameters for the network and synapse constants, in this case they are set to approximate gamma oscillations
cvc_recording; % load the recording parameters, by default only records LFP and spikes.
cvc_simulation; % load the simulation parameters, including crucially the simulation time.

cvc_field_stimulation; % optional, this script loads electric field stimulation. Comment this out to have no stimulation.

% Change this directory to where you would like to save the results of the
% simulation:
RS.saveDir = '~/Documents/MATLAB/Vertex_Results/cvc_gamma_test';
% Change these settings if you need to use fewer cores or a different
% parallel profile, or if you want to run in serial mode (this will take a
% long time):
SS.parallelSim = false;% true;
SS.poolSize = 2; % set to the number of cores on your computer
SS.profileName = 'local';

%% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);

%% Run the simulation
tic
runSimulation(params, connections, electrodes);
toc
%% Load the simulation results
 Results = loadResults(RS.saveDir); % automatically load the results to the workspace with the name 'Results'
% 
% %% Plotting
% 
rasterParams.colors = {'k','c','g','y','m','r','b','c','k','m','b','g','r','k','c'};
pars.colors = rasterParams.colors;
pars.opacity=0.6;
pars.markers = {'^','p','h','*','x','^','p','h','d','v','p','h','d','v','p'};
N = Results.params.TissueParams.N;
pars.toPlot = 1:3:N;
plotSomaPositions(Results.params.TissueParams,pars);


figure
plotSpikeRaster(Results);


