% static soma stim

set(0,'defaultfigurecolor',[1 1 1])
%% Load in the relevant parameters.
cvc_tissue;
cvc_neurons_nonoise;
cvc_connectivity_none;
cvc_recording;
cvc_simulation;
RS.v_m = 1:10:20000; % we need to record from a large subset of neurons!
SS.simulationTime = 200; % to ensure simulation length
brainslice3Dzerostim;
TP.StimulationField = result;
TP.StimulationOn = 0;
TP.StimulationOff = SS.simulationTime;


% Change this directory to where you would like to save the results of the
% simulation:
RS.saveDir = '~/TCSpaperResults/cvc_slow_4mVmmDCfield';%AC30hz_long';
% Change these settings if you need to use fewer cores or a different
% parallel profile, or if you want to run in serial mode (this will take a
% long time):
SS.parallelSim =  true;%false;
SS.poolSize = 2;
SS.profileName = 'local';

% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);

% Run the simulation
tic
runSimulation(params, connections, electrodes);
toc
% Load the simulation results
 ResultsNoStim = loadResults(RS.saveDir);
 
 
%% Rerun with stimulation

brainslice3Dorig;
TP.StimulationField = result;
TP.StimulationOn = 0;
TP.StimulationOff = SS.simulationTime;

% for a different field orientation, uncomment below:
%SS.RotateField.angle = 180;
%SS.RotateField.axis = 'z';


% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);

% Run the simulation
tic
runSimulation(params, connections, electrodes);
toc
% Load the simulation results
 ResultsAnodalStim = loadResults(RS.saveDir);


%% Plotting

pars.toPlot = RS.v_m;
plotSomaPositionsMembranePotential(ResultsNoStim.params.TissueParams,pars,ResultsAnodalStim.v_m(:,end-1)-ResultsNoStim.v_m(:,end-1));



