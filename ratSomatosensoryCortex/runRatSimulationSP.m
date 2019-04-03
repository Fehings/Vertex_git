

%Recording settings
%These describe which variables to record, we are interested in membrane
%potentials and local field potentials. 
% This file is for single pulse 
% A separate file has been set up for theta burst stimulation and paired
% pulse stimulation.

%% Recording LFP
RecordingSettings.LFP = false;
[meaX, meaY, meaZ] = meshgrid(1200:-100:500, 300, 1800:-100:300);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;


% We can record a number of variables from each cell such as membrane potential (v_m), 
% synaptic current (I_syn for total, I_synComp to record compartment currents seperately), 
% the transmembrane current for each compartment, and
% the synaptic variables (e.g. x,y,u for the MT model).
% The specific cells to record the variables from can be specified by NeuronID, by location (a location in the XZ plane, a number of nearest cells to record from, and groups to
% record from). 
% Depending on how much RAM you have you may not be able to record
% everything in one run.
% For the multiple runs of single pulse, only the LFP and the spiking
% activity are needed.
% Here we specify the recorded variables required to reproduce the figures
% from the paper.

%% I_syn required for figures 11 (B) 
% %Record synaptic currents from 50 group 13 and 50 group 14 cells nearest to X = 1150, Z = 1200.
% RecordingSettings.I_syn_location = [[1150 1200];[1150 1200]];
% RecordingSettings.I_syn_number = [50, 50];
% RecordingSettings.I_syn_group = [13, 14];
% RecordingSettings.I_syn_preGroups = [6:20];
% 
% %Record membrane potentials from 50 group 13 and 50 group 14 cells nearest to X = 1150, Z = 1200.
% RecordingSettings.v_m_location = [[1150 1200]; [1150 1200]];
% RecordingSettings.v_m_number = [50,50];
% RecordingSettings.v_m_group = [13,14];
% 
% %Record synaptic currents per compartment from 50 group 13 and 50 group 14 cells nearest to X 1150, Z = 1200.
% % This is required for figure 11 C
% RecordingSettings.I_synComp_location = [[1150 1200]; [1150 1200]];
% RecordingSettings.I_synComp_number = [50,50];
% RecordingSettings.I_synComp_groups = [13,14];
% 
% %Record the transmembrane currents for cells within box specified.
% % Required for figure 11 D and E
for iGroup = 1:29
    RecordingSettings.CSD_groups(iGroup) = iGroup;
    RecordingSettings.CSD_Xboundary(iGroup,:) = [1100 1200];
    RecordingSettings.CSD_Yboundary(iGroup,:) = [150 200];
    RecordingSettings.CSD_Zboundary(iGroup,:) = [300 1800];
end


RecordingSettings.maxRecTime = 2500;
RecordingSettings.sampleRate = 5000;

%Simulation settings:
SimulationSettings.maxDelaySteps = 80;
SimulationSettings.simulationTime = 2500;
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
