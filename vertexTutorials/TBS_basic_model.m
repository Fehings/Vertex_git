%% TBS applied to a basic L23 model
% In this tutorial we will use the same network setup as in VERTEX tutorial
% 2 (see http://vertexsimulator.org/category/tutorials/ ) adding a flag
% which can swtich Spike Timing Dependent Plasticity (STDP) dynamics on or off.
% We are also including a noiseScaler and a synapticScaler to make changing
% parameters of interest easier. 
% The TissueParams, NeuronParams and ConnectionParams are defined in a
% separate function 'readTutorial2Params' which will need to be present in
% your workspace.


clear vars
%% Options:

% Are we using STDP?
isSTDP = 1; % 1 is true, we are using STDP. 0 is false, no STDP.

noiseScaler = 1; % Scaling parameter for the background noise in the model

synapticScaler =  1; % Scaling parameter for initial synaptic weights

SimulationSettings.parallelSim = true; % turn this to true if you want to run in parallel, false for serial.

% Please change this to match your directory structure:
RecordingSettings.saveDir = '~/VERTEX_results_Coursework/';
% you will need to change the save name each time you run or it will
% overwrite the previously saved results.

%% Now read in all the background parameters

[TissueParams,NeuronParams,ConnectionParams] = readL23Params_ratmodelsized(isSTDP,noiseScaler,synapticScaler);

%% Recording and simulation settings
% We will use the same recording and simulation settings as in the previous
% tutorial. Note that the simulation will take longer to run than in
% tutorial 1, as the AdEx dyamics add complexity to the calculations.

RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(0:1000:2000, 200, 600:-300:0);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.maxRecTime = 500;
RecordingSettings.sampleRate = 1000;

if isSTDP
    % Specifying which neurons to record the weights for 
    % weights_preN_IDs specifies the presynaptic neuron IDs of the connections
    % we are interested in. This will record the weights over time for all
    % connections for which there are the pre synaptic ID.
    RecordingSettings.weights_preN_IDs = [1:5:400];
    % Recording the variables related to the STDP model. This
    % will record Apre and Apost for all connections where the specified IDs
    % are the presynaptic neuron.
    RecordingSettings.stdpvars = [1:2:500];
    % Recording a snapshot of the weights of the entire network at the
    % specified timestep. 
    RecordingSettings.weights_arr = [1,16000];
    
    SimulationSettings.stdp = true; % We need to tell the simulation to make the weight changes.
else
    SimulationSettings.stdp = false;
end

SimulationSettings.simulationTime = 500;
SimulationSettings.timeStep = 0.03125;


%% Load the stimulating electrode field and set on and off times
% Default times are for single pulse at 1500 ms.
%setUpBipolarElectrodeStimulation
[TissueParams.StimulationField,model] = invitroSliceStim('6layermodelstiml4placedinnobacktrueunits.stl',500); % slicecutoutsmallnew

%% For theta burst stimulation set the on and off times.  
TissueParams.StimulationOn = [100,110,120,130,140];
TissueParams.StimulationOff = [105,115,125,135,145];


%% Generate the network
% We generate the network in exactly the same way as in tutorial 1, by
% calling the |initNetwork| function:

[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

%% Run the simulation
% Now we can run the simulatio, and load the results:

runSimulation(params, connections, electrodes);

Results = loadResults(RecordingSettings.saveDir);

%% Plot the results
result = solvepde(model);
u = result.NodalSolution; % so u is the solution
pdeplot3D(model,'ColorMapData', u,'FaceAlpha',0.3);

hold on
% Slice schematic:
rasterParams.colors = {'g','c'};
pars.colors = rasterParams.colors;
pars.opacity=0.6;
pars.markers = {'^','*'};
N = Results.params.TissueParams.N;
pars.toPlot = 1:N;
plotSomaPositions(Results.params.TissueParams,pars);


%% Raster
% Rather than manually plotting the spike raster, we will make use of
% VERTEX's |plotSpikeRaster| function, which does some automatic
% prettyfication of spike raster plots. |plotSpikeRaster| accepts the
% Results structure we loaded using |loadResults| and a structure of
% parameters that set some properties of the figure. It returns a handle to
% the created figure.
%
% We can add some further fields to the parameter structure for enhanced
% prettiness. |groupBoundaryLines| is a color value, which if set will make
% |plotSpikeRaster| draw separating lines between the neuron groups in this
% color. You can also set a |title|, |xlabel| and |ylabel|. Finally, we can
% specify which Matlab figure number to use. If we don't specify this,
% a new figure window will be opened.

rasterParams.groupBoundaryLines = [0.7, 0.7, 0.7];
rasterParams.title = 'Spike Raster';
rasterParams.xlabel = 'Time (ms)';
rasterParams.ylabel = 'Neuron ID';
rasterParams.figureID = 1;

rasterFigureImproved = plotSpikeRaster(Results, rasterParams);

%%
% The spike raster shows a gamma oscillation occurring in the population
% (for details on the mechanism of this oscillation, see Tomsett et al.
% 2014). The precise details of the spiking in your simulation will depend
% on the random number generation, which we did not seed explicitly
% (seeding random numbers in VERTEX is covered in tutorial 5). The
% oscillation can be seen in the LFP:

figure(2)
plot(Results.LFP', 'LineWidth', 2)
set(gcf,'color','w');
set(gca,'FontSize',16)
title('LFP at all electrodes', 'FontSize', 16)
xlabel('Time (ms)', 'FontSize', 16)
ylabel('LFP (mV)', 'FontSize', 16)
%%
% For simulations involving spike timing depedent plasticity, we can plot 
% the synaptic weight changes for a given connection over time. 
% We can do this for connections from cells that we have specified in weights_preN_IDs
% If the post synaptic connection requested does not exist then the 
% plotstdpchangesandspikes function will tell us which post synaptic IDs
% this presynaptic cell does connect to.

if isSTDP

    % If stdp is being used we can also plot the snapshots of the entire network of connections,
    % recorded at the time points specified in weights_arr.
    % To get the first snapshot we can do:
    w1 = getSparseConnectivityWeights(Results.weights_arr{1}, Results.syn_arr, Results.params.TissueParams.N);
    figure(4);
    imagesc(w1);
    % To get the second snaptshot we can do:
    w2 = getSparseConnectivityWeights(Results.weights_arr{2}, Results.syn_arr, Results.params.TissueParams.N);
    figure(5);
    imagesc(w2);
    % We then might wish to show the weight change between these two times:
    figure(6);
    imagesc(w2-w1);
end


