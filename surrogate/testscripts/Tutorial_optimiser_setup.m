%function [params,connections,electrodes] = Tutorial_optimiser_setup()

% setting up parameters, in this case a simple IN + EX model
setup_multiregion_gexp; % I know it says 'multiregion' in the name here but it is also valid for a single region!

% uncomment for stdp
%setup_multiregion_allstdp;

it=length(dir('~/Documents/MATLAB/Vertex_Results/VERTEX_results_surrogate'))
% save results - change this for your computer:
savenm = sprintf('~/Documents/MATLAB/Vertex_Results/VERTEX_results_surrogate/opttest%d',it);
RecordingSettings.saveDir = savenm;

%% recording settings 

% times to record weights
%RecordingSettings.weights_arr = 1:500:1000;
% which weights to record (a subset)
%RecordingSettings.weights_preN_IDs = 4950:10:5000;
%RecordingSettings.samplingSteps = 1:10:10000;
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(0:100:2000, 5:95:395, 195:-95:5);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.v_m = [];%100:200:1200;%100:1000:4000;%250:250:4750;
RecordingSettings.maxRecTime = 5000;
RecordingSettings.sampleRate = 1000;
RecordingSettings.nosave = true;
% how long the simulation runs for... 
SimulationSettings.simulationTime = 1000; %ms
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
SimulationSettings.optimisation = true;

%% Stimulation
% optional - step current stimulation 
% uncomment for short burst of stimulation at a given time period

% NeuronParams(1).Input(2).inputType = 'i_step';
% NeuronParams(1).Input(2).timeOn = 200;
% NeuronParams(1).Input(2).timeOff = 250;
% NeuronParams(1).Input(2).amplitude = 1000; 



% uncomment for field stimulation

%value_to_change = 4; % field strength
 %[stlresult,model] = invitroSliceStim('tutorial2_3.stl',value_to_change);
 TissueParams.StimulationField = [];
 TissueParams.StimulationOn = 0;
 TissueParams.StimulationOff = SimulationSettings.simulationTime;
 %TissueParams.tRNS = wgn(1,1,0); % initialising the tRNS

% set up the slice:
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

 save('Tutorial_optimiser_setup','params','connections','electrodes','-v7.3')

%end

