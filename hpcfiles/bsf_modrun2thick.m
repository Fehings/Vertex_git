%% Neocortical slice model from Tomsett et al. 2014

addpath(genpath('/home/a6028564/Vertex_git'));

bsf_tissue;

TP.Z = 2600*0.7693;
TP.neuronDensity = 38335;
TP.layerBoundaryArr = [2600 2362 1835 1122 832 0]*0.7963;

bsf_neurons;
bsf_connectivity;
bsf_recording;
bsf_simulation;
%bsf_field_stimulation;

% Change this directory to where you would like to save the results of the
% simulation
RS.saveDir = '/home/a6028564/VERTEX_Results/bsf_cshpc_thickness2mm_nostim';
% Change these settings if you need to use fewer cores or a different
% parallel profile, or if you want to run in serial mode (this will take a
% long time)
SS.parallelSim = true;
SS.poolSize =12; %was 12 in the original
SS.profileName = 'local';

% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);

% Run the simulation
runSimulation(params, connections, electrodes);

% Load the simulation results
Results = loadResults(RS.saveDir);
%%
% If you have experienced any problems when trying to run this code, please
% email Richard Tomsett: r _at_ autap _dot_ se

%% Reference
% Tomsett RJ, Ainsworth M, Thiele A, Sanayei M, Chen X et al. (2014)
% Virtual Electrode Recording Tool for EXtracellular potentials (VERTEX):
% comparing multi-electrode recordings from simulated and biological
% mammalian cortical tissue, Brain Structure and Function.
% doi:10.1007/s00429-014-0793-x
