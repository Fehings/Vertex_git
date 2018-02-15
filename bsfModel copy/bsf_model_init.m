%% Neocortical slice model from Tomsett et al. 2014

bsf_tissue;
bsf_neurons;
bsf_connectivity;
bsf_recording;
bsf_simulation;
%bsf_field_stimulation;

% Change this directory to where you would like to save the results of the
% simulation
RS.saveDir = '/Users/a6028564/Documents/MATLAB/VERTEX_bsf_results/bsf_defaultparams_right5An_left3Cath_stim5s';

% Change these settings if you need to use fewer cores or a different
% parallel profile, or if you want to run in serial mode (this will take a
% long time)
SS.parallelSim = true;
SS.poolSize = 2; %was 12 in the original
SS.profileName = 'local';

% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);
