% To run full simulation will require a high performance computing node.
% This has been run on 12 cores with 200GB RAM.
% Smaller scale models can be run by reducing the neuron density in
% loadRatTissueandNeuronParams. A Neuron density of 20000 should run fine
% on a machine with 32GB RAM.
% 
%% You May have to add the path 
% addpath(genpath('~/Vertex_git'))

% Setting the model Tissue, Neuron, and Connection parameters.
% These are based on the Neocortical Collaborative Portal and are stored in
% connectionslayers23to6.mat, rat_no_neurons.mat, and ratlayerthickness.mat

loadRatTissueandNeuronParams;
TissueParams.neuronDensity = 103730;
loadRatConnectionParamsNoSyn;
%% Load the stimulating electrode field and set on and off times
% Default times are for single pulse at 1500 ms.
setUpBipolarElectrodeStimulation

loadSimulationSettings
%% Set the random seed, this should go from 1001 to 1005 to reproduce results in the paper where they are based on repeated simulations. 
SimulationSettings.randomSeed = 1001;
%% Set the location to save results.
RecordingSettings.saveDir = ['~/F1000_Data/nosynapse' num2str(SimulationSettings.randomSeed)];
runRatSimulationSP;

