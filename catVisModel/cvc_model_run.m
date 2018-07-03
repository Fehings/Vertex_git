

cvc_tissue;
cvc_neurons_nonoise;
%cvc_connectivity_none;
%vc_neurons_noisy;
%cvc_connectivity_noisy;
%cvc_neurons_beta;
%cvc_connectivity_beta;
%cvc_neurons;
cvc_connectivity;
%cvc_connectivity_alpha;
%cvc_neurons_gamma;
%cvc_connectivity_gamma_update;
%cvc_step_current;
cvc_recording;
cvc_simulation;
%cvc_field_stimulation; 
load('zerostimfield_cvc.mat');
TP.StimulationField = result;
TP.StimulationOn = 0;
TP.StimulationOff = SS.simulationTime;

% Change this directory to where you would like to save the results of the
% simulation
RS.saveDir = '~/Documents/MATLAB/Vertex_Results/PaperResults/cvc_slow_nonoise_sideside4mvmmstim';%AC30hz_long';
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


%%
% If you have experienced any problems when trying to run this code, please
% email Richard Tomsett: r _at_ autap _dot_ se

%% Reference
% Tomsett RJ, Ainsworth M, Thiele A, Sanayei M, Chen X et al. (2014)
% Virtual Electrode Recording Tool for EXtracellular potentials (VERTEX):
% comparing multi-electrode recordings from simulated and biological
% mammalian cortical tissue, Brain Structure and Function.
% doi:10.1007/s00429-014-0793-x