%% Anodal DC field stimulation comparison 
% This script runs the ferret model with slow oscillations, comparing a DC
% field stimulation with an unstimulated run of the same model.
%
% The figures generated show: 
%
% For further information contact Frances Hutchings at
% frances.hutchings@newcastle.ac.uk
%
% You will need to have the main VERTEX scripts in your file path and
% visible to MATLAB. You will also need to have run
% Fig1_slowOscillations_SliceSchematic before running this script, as it
% loads the results from that simulation. If you haven't already run the
% Fig1 script then uncomment the line below:
%
% Fig1_slowOscillations_SliceSchematic
% 
% If you have already run the simulation, then either keep the results in
% your workspace, or load them with the below command, changing the file
% structure as appropriate:
Results = load('~/TCSpaperResults/cvc_slow_4mVmmDCfield');
%
% Then we need to run a simulation without stimulation. To do so, call the
% following script to load the parameters:

slowOscillationsNoStimulation

%Depending on your computer architecture you may need to change the
%parallel simulation flag to 'false' or the poolsize to match the number of
%available cores. 
%The simulation is conducted for a large number of time steps and so may
%take a long time to run, depending on your computer. Up to a couple of
%hours.

% run the model:
tic
runSimulation(params, connections, electrodes);
toc
% Load the simulation results
Results_NoStim = loadResults(RS.saveDir);

% this should run, and then load the results into your workspace as
% 'Results_NoStim' which should then be accessible for plotting.


%% Plotting

figure
plot(mean(Results.LFP));
xlim([500,1000])
xlabel('Time')
ylabel('mV')


plotSpikeRaster(Results,rasterParams)
xlabel('Time')
ylabel('Neuron ID')

plotSpikeCounts(Results)




