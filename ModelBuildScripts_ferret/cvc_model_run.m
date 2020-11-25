

cvc_tissue;
cvc_neurons_noisy;
cvc_connectivity_noisy;
cvc_recording;
cvc_simulation; 


% Change this directory to where you would like to save the results of the
% simulation
RS.saveDir = '~/Documents/MATLAB/Vertex_Results/cvc_noisytest';
% Change these settings if you need to use fewer cores or a different
% parallel profile, or if you want to run in serial mode (this will take a
% long time)
SS.parallelSim = false;% true;
SS.poolSize = 2; %was 12 in the original
SS.profileName = 'local';

%% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);

%% Run the simulation
tic
runSimulation(params, connections, electrodes);
toc
%% Load the simulation results
 Results = loadResults(RS.saveDir);
% 
% %% Plotting
% % 
% rasterParams.colors = {'k','c','g','y','m','r','b','c','k','m','b','g','r','k','c'};
% pars.colors = rasterParams.colors;
% pars.opacity=0.6;
% pars.markers = {'^','p','h','*','x','^','p','h','d','v','p','h','d','v','p'};
% N = Results.params.TissueParams.N;
% pars.toPlot = 1:3:N;
% plotSomaPositions(Results.params.TissueParams,pars);
