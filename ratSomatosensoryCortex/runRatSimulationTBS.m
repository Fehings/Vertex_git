

%Recording settings
%These describe which variables to record, we are interested in membrane
%potentials and local field potentials. 
% This file is for theta burst stimulation.
% It will result in the recording of all variables needed to produce the
% figures in the paper.

%% Recording LFP
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(1200:-100:500, 300, 1800:-100:1600);
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
%% I_syn required for figures 11 (B) and 13
%Record synaptic weights from 25 group 13 and 25 group 14 and 25 group 20 cells.
% Group 13 and group 14 cells are close to the electrode and so directly
% recruited. Group 20 cells are secondarily recruited.
RecordingSettings.weights_preN_IDs_location = [[775 1225];[775 1225]];
RecordingSettings.weights_preN_IDs_number = [25, 25];
RecordingSettings.weights_preN_IDs_group = [6,13];

%Record membrane potentials from 25 group 13 and 25 group 14 cells nearest to X = 775, Z = 1225.
%Record membrane potentials from 25 group 20  cells nearest to X = 1150, Z = 1225.
RecordingSettings.v_m_location = [[775 1600]; [775 1225];[775 1225]];
RecordingSettings.v_m_number = [500,25,25];
RecordingSettings.v_m_group = [1,6,13];

% Record 4 snapshots of the weights, one a the beggning, one just before
% TBS, one just after TBS and one at the end.
RecordingSettings.weights_arr = [1,38000,89000,155000];

RecordingSettings.maxRecTime = 5500;
RecordingSettings.sampleRate = 2500;

%Simulation settings:
%Keep max delay steps at 80, 
%Simulation time can be varied, it is in milliseconds, currently running
%for 500 ms.
%We want to run this simulation in parallel, this means that all cpu cores
%will be utilised in the simulations, with the neurons being distributed
%across them, as this simulation is large this is necessary to minimize the
%run time of the simulation. 
SimulationSettings.maxDelaySteps = 80;
SimulationSettings.simulationTime = 5500;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim =true;
SimulationSettings.stdp =true;

%%
%This initialises the network and sets up other variables. 
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

%%

tic;
runSimulation(params, connections, electrodes);
toc;
