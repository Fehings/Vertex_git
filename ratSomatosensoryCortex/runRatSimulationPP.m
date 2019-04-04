

%Recording settings
%These describe which variables to record, we are interested in membrane
%potentials and local field potentials. 
% This file is for single pulse and paired pulse
% A separate file has been set up for theta burst stimulation.

%% Recording LFP
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(1200:-100:500, 300, 1800:-100:300);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;


% We can record a number of variables from each cell such as membrane potential (v_m), 
% synaptic current (I_syn for total, I_synComp to record compartment currents seperately), 
% the transmembrane current for each compartment, and
% the synaptic variables (e.g. x,y,u for the MT model).
% The specific cells to record the variables from can be specified by NeuronID, by location (a 
% triple of a location in the XZ plane, a number of nearest cells to record from, and groups to
% record from). 
% Depending on how much RAM you have you may not be able to record
% everything. 

% For Figure 13 Record stp_syn (short term plasticity synaptic variables).
% The recording location of these is specified to be around the location of
% the stimulating electrode.
% To reproduce recording pairedpulse1001_detailed
RecordingSettings.stp_syn_location = [[775 1225]; [775 1225];[1150 1225]];
RecordingSettings.stp_syn_number = [50,50,50];
RecordingSettings.stp_syn_group = [13,14,20];

% Record synaptic currents per pre synaptic group. This is required for
% generating the results files in /pairedPulse/multipleRuns/. It allows us
% to measure the residual inhibitory current arriving during the second
% pulse.
RecordingSettings.I_syn_location = [[775 1225]; [775 1225];[1150 1225]];
RecordingSettings.I_syn_number = [50,50,50];
RecordingSettings.I_syn_group = [13,14,20];

%Record synaptic currents per compartment from 50 group 13 and 50 group 14 cells nearest to X 1150, Z = 1200.
%This is required for figure 13. This records the synaptic current on the
%post synaptic side near the recording electrode.
RecordingSettings.I_synComp_location = [[1150 1200]; [1150 1200]];
RecordingSettings.I_synComp_number = [50,50];
RecordingSettings.I_synComp_groups = [13,14];


RecordingSettings.maxRecTime = 2500;
RecordingSettings.sampleRate = 5000;

%Simulation settings:
SimulationSettings.maxDelaySteps = 80;
SimulationSettings.simulationTime = 1400;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim =true;
SimulationSettings.stdp =false;

%%
%This initialises the network and sets up other variables. 
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

%%

tic;
runSimulation(params, connections, electrodes);
toc;
