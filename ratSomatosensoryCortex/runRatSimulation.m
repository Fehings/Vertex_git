

%Recording settings
%These describe which variables to record, we are interested in membrane
%potentials and local field potentials. 
%We save the results of the simulation in this folder, they can be loaded
%at any time after the simulation has finished by loading into memory the
%Results file. Use Results = loadResults(RecordingSettings.saveDir); to do
%this.
%RecordingSettings.saveDir = '~/pulse_test/';

RecordingSettings.LFP = false;
[meaX, meaY, meaZ] = meshgrid(1200:-100:500, 300, 1800:-100:300);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;

%RecordingSettings.v_m = 1:100:33312;
%RecordingSettings.stp_syn = 1:100:33312;
%RecordingSettings.I_syn = 1:100:33312;
%post synaptic recruitment 1450 1200
%  RecordingSettings.I_syn_location = [[1150 1200];[1150 1200];[1150 1200]];
% RecordingSettings.I_syn_number = [50, 50, 50];
% RecordingSettings.I_syn_group = [13, 14, 8];
%  RecordingSettings.v_m_location = [[1150 1200];[1150 1200];[1150 1200]];
% RecordingSettings.v_m_number = [50, 50, 50];
% RecordingSettings.v_m_group = [13, 14, 8];
%  RecordingSettings.stp_syn_location = [[1150 1200];[1150 1200];[1150 1200]];
% RecordingSettings.stp_syn_number = [50, 50, 50];
% RecordingSettings.stp_syn_group = [13, 14, 8];
% RecordingSettings.I_syn_preGroups = [6:20];
for iGroup = 1:29
    RecordingSettings.CSD_groups(iGroup) = iGroup;
    RecordingSettings.CSD_Xboundary(iGroup,:) = [1100 1200];
    RecordingSettings.CSD_Yboundary(iGroup,:) = [150 200];
    RecordingSettings.CSD_Zboundary(iGroup,:) = [300 1800];
end
RecordingSettings.maxRecTime = 2500;
RecordingSettings.sampleRate = 5000;

%Simulation settings:
%Keep max delay steps at 80, 
%Simulation time can be varied, it is in milliseconds, currently running
%for 500 ms.
%We want to run this simulation in parallel, this means that all cpu cores
%will be utilised in the simulations, with the neurons being distributed
%across them, as this simulation is large this is necessary to minimize the
%run time of the simulation. 
SimulationSettings.maxDelaySteps = 80;
SimulationSettings.simulationTime = 200;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim =true;


%%
%This initialises the network and sets up other variables. 
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

%%

tic;
runSimulation(params, connections, electrodes);
toc;