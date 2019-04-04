%% slowOscillationsNoStimulation
% This script runs the ferret model with slow oscillations, with no
% stimulation. 
% You will need to have the main VERTEX scripts in your file path and
% visible to MATLAB.
%
% For further information contact Frances Hutchings at
% frances.hutchings@newcastle.ac.uk

set(0,'defaultfigurecolor',[1 1 1])
%% Load in the relevant parameters.
cvc_tissue;
cvc_neurons;
cvc_connectivity;
cvc_recording;
RS.v_m = []; % no need to record membrane voltages.
cvc_simulation;
SS.simulationTime = 15000; % to ensure simulation length
% load a zero value field.
TP.StimulationField = [];
TP.StimulationOn = 0;
TP.StimulationOff = SS.simulationTime;


% Change this directory to where you would like to save the results of the
% simulation:
RS.saveDir = '~/TCSpaperResults/cvc_slow_nostimfield';%AC30hz_long';
% Change these settings if you need to use fewer cores or a different
% parallel profile, or if you want to run in serial mode (this will take a
% long time):
SS.parallelSim =  true;%false;
SS.poolSize = 2;
SS.profileName = 'local';

%% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);
