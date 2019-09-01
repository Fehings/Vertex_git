%% Figure 1 B, C and D 
% This script runs the ferret model with slow oscillations, with a DC field
% stimulation. 
% YHou will need to have the main VERTEX scripts in your file path and
% visible to MATLAB.
%
%Depending on your computer architecture you may need to change the
%parallel simulation flag to 'false' or the poolsize to match the number of
%available cores. 
%The simulation is conducted for a large number of time steps and so may
%take a long time to run, depending on your computer. Up to a couple of
%hours.
%
% The figures generated show: B) the soma positions with
% different colours and shapes according to neuron type. Please see the
% figure legend in the paper for details on what colour-shape combination
% represents what neuron. Details of neurons can be found in the
% cvc_neurons script which is loaded in the preamble. The larger
% morphologies in the paper figure were overlaid afterwards to show example
% neuron shapes, and so are not included in this plot.
% C) The local field potential averaged over all recording electrodes for 
% 5000 time steps taken towards the end of the simulation. This is because
% it takes some time for the oscillations to stabilise.
% D) The spike raster plot, shown for the same time span as the local field
% potential. This shows the time points of spikes for individual neurons
% grouped by layer and type.
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
brainslice3Dorig;
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

%% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);

%% Run the simulation
tic
runSimulation(params, connections, electrodes);
toc
%% Load the simulation results
 Results = loadResults(RS.saveDir);
 
%% Plotting
% 1 B)
rasterParams.colors = {'k','c','g','y','m','r','b','c','k','m','b','g','r','k','c'};
pars.colors = rasterParams.colors;
pars.opacity=0.6;
pars.markers = {'^','p','h','*','x','^','p','h','d','v','p','h','d','v','p'};
N = Results.params.TissueParams.N;
pars.toPlot = 1:3:N;
plotSomaPositions(Results.params.TissueParams,pars);
view(25,20)


figure
plot(mean(Results.LFP));
%xlim([10000,15000])
xlabel('Time')
ylabel('mV')


plotSpikeRaster(Results,rasterParams)
xlabel('Time')
ylabel('Neuron ID')
