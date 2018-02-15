% Neocortical slice model from Tomsett et al. 2014

cvc_tissue;
%cvc_neurons_nonoise;
%cvc_connectivity_none;
cvc_neurons_noisy;
cvc_connectivity_noisy;
%cvc_neurons_beta;
%cvc_connectivity_beta;
%cvc_neurons;
%cvc_connectivity_alpha;
%cvc_neurons_gamma;
%cvc_connectivity_gamma_update;
%cvc_step_current;
cvc_recording;
cvc_simulation;

% Change this directory to where you would like to save the results of the
% simulation
RS.saveDir = '~/Documents/MATLAB/Vertex_Results/';%AC30hz_long';
% Change these settings if you need to use fewer cores or a different
% parallel profile, or if you want to run in serial mode (this will take a
% long time)
SS.parallelSim = true; 
SS.poolSize = 2; %was 12 in the original
SS.profileName = 'local';

%% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);




