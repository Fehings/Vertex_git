% To run full simulation will require a high performance computing node.
% This has been run on 12 cores with 200GB RAM.
% Smaller scale models can be run by reducing the neuron density in
% loadRatTissueandNeuronParams.
% 
%% You May have to add the path 
% addpath(genpath('~/Vertex_git'))

% Setting the model Tissue, Neuron, and Connection parameters.
% These are based on the Neocortical Collaborative Portal and are stored in
% connectionslayers23to6.mat, rat_no_neurons.mat, and ratlayerthickness.mat

loadRatTissueandNeuronParams;
TissueParams.neuronDensity = 103730;
loadRatConnectionParams;
%% Load the stimulating electrode field and set on and off times
% Default times are for single pulse at 1500 ms.
setUpBipolarElectrodeStimulation
%% For paired pulse stimulation set the on and off times. 
% e.g. for 50 ms interval:
% TissueParams.StimulationOn = [500 550 ]; 
% TissueParams.StimulationOff = [ 500.5 550.5];
% e.g. for 100 ms interval:
% TissueParams.StimulationOn = [500 600 ]; 
% TissueParams.StimulationOff = [ 500.5 600.5];
% e.g. for 150 ms interval:
TissueParams.StimulationOn = [500 650 ]; 
TissueParams.StimulationOff = [ 500.5 650.5];
% e.g. for 200 ms interval:
% TissueParams.StimulationOn = [500 700 ]; 
% TissueParams.StimulationOff = [ 500.5 700.5];
% e.g. for 250 ms interval:
% TissueParams.StimulationOn = [500 750 ]; 
% TissueParams.StimulationOff = [ 500.5 750.5];

loadSimulationSettings

%% Set the random seed, this should go from 1001 to 1005 to reproduce results in the paper where they are based on repeated simulations. 
SimulationSettings.randomSeed = 1001;
%% Set the location to save results.
RecordingSettings.saveDir = ['~/F1000_Data/pairedpulse_' num2str(SimulationSettings.randomSeed)];
%% For single or paired pulse
runRatSimulationPP
% For theta burst stimulation
% runRatSimulationTBS

