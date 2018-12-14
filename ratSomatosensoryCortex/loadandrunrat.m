%% May have to add the path 
% addpath(genpath('~/Vertex_git'))
loadRatTissueandNeuronParams;
loadRatConnectionParams;
%% Load the stimulating electrode field and set on and off times
% Default times are for single pulse at 1500 ms.
setUpBipolarElectrodeStimulation
%% For paired pulse stimulation set the on and off times. 
% e.g. for 150 ms interval:
% TissueParams.StimulationOn = [500 650 ]; 
% TissueParams.StimulationOff = [ 500.5 650.5];
%% For theta burst stimulation set the on and off times.  
% TissueParams.StimulationOn = [1500,2700,2710,2720,2730,2740,2900,2910,2920,2930,2940,3100,3110,3120,3130,3140,3300,3310,3320,3330,3340,3500,3510,3520,3530,3540,3700,3710,3720,3730,3740,4940]
% TissueParams.StimulationOff = [1500.50000000000,2700.50000000000,2710.50000000000,2720.50000000000,2730.50000000000,2740.50000000000,2900.50000000000,2910.50000000000,2920.50000000000,2930.50000000000,2940.50000000000,3100.50000000000,3110.50000000000,3120.50000000000,3130.50000000000,3140.50000000000,3300.50000000000,3310.50000000000,3320.50000000000,3330.50000000000,3340.50000000000,3500.50000000000,3510.50000000000,3520.50000000000,3530.50000000000,3540.50000000000,3700.50000000000,3710.50000000000,3720.50000000000,3730.50000000000,3740.50000000000,4940.50000000000]

loadSimulationSettings
tic;
%% Set the location to save results.
RecordingSettings.saveDir = '~/Results';
%% Set the random seed, this should go from 1001 to 1005 to reproduce results in the paper.
SimulationSettings.randomSeed = 1001;

runRatSimulation
toc
