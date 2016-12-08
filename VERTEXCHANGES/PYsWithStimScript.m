%% VERTEX Stimulation Tutorial
% In this tutorial we will create a model arranged into several cortical
% layers. The model represents a simplified neocortical circuit containing
% cortical layers 3, 4 and 5. Note that this tutorial may take some time to run
% as it implements a model containing more than 10,000 neurons.
%
%% BEFORE running this script please run the tissuestimulation.m script to simulate
%the electric field in the slice. Export the solution: u, as well as the
%mesh: p,e, and t

%clear vars
%% Tissue parameters
% Our tissue parameters are similar to the previous tutorials:

TissueParams.X = 200; %2000
TissueParams.Y = 40;  %400
TissueParams.Z = 65;  %650
TissueParams.neuronDensity = 50000;
TissueParams.numStrips = 50;
TissueParams.tissueConductivity = 0.3;
TissueParams.maxZOverlap = [-1 , -1];

%% Show VERTEX where the electric field solution and mesh are

modstl = 'sidesidestim2.stl';

[TissueParams.StimulationField,model] = invitroSliceStim('sidesidestim2.stl')%,stimstrength); % slicecutoutsmallnew chrismodelmod9
%%
% However, we need to set the number of layers to 3 and make sure we set
% the layer boundaries to create a 200 micron thick layer 3, a 300 micron
% thick layer 4 and a 150 micron thick layer 5:

TissueParams.numLayers = 1;
TissueParams.layerBoundaryArr = [TissueParams.Z,0];

%%
% As the total Z-depth of the model is 650, we specify the top boundary of our
% layer three (the model's first layer) to be 650 microns, then the top of
% layer 4 to be 450 microns, and the top of layer 5 to be 150 microns.
%
%% Neuron group parameters
% Next we need to set up our neuron groups. Groups are allocated to a
% layer, and we will include pyramidal cells and basket interneurons in layer 3,
% spiny stellate cells and basket interneurons in layer 4, and pyramidal
% cells and basket interneurons in layer 5. We therefore need six neuron
% groups. We take the proportion of the total number of neurons that each
% group makes up (very) approximately from the data in Binzegger et al. 2004.
% Basket cells and spiny stellate cells share the same morphology, but have
% different firing dynamics (see Tomsett et al. 2014 for the firing responses of
% the cell models).

NeuronParams(1).somaLayer = 1; % Pyramidal cells in layer 3
NeuronParams(1).modelProportion = 1;
NeuronParams(1).neuronModel = 'adex';
NeuronParams(1).V_t = -50;
NeuronParams(1).delta_t = 2;
NeuronParams(1).a = 2.6;
NeuronParams(1).tau_w = 65;
NeuronParams(1).b = 220;
NeuronParams(1).v_reset = -60;
NeuronParams(1).v_cutoff = -45;
NeuronParams(1).numCompartments = 8;
NeuronParams(1).compartmentParentArr = [0, 1, 2, 2, 4, 1, 6, 6];
NeuronParams(1).compartmentLengthArr = [13 48 124 145 137 40 143 143];
NeuronParams(1).compartmentDiameterArr = ...
  [29.8, 3.75, 1.91, 2.81, 2.69, 2.62, 1.69, 1.69];
NeuronParams(1).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  124;
    0,    0;
    0,    0;
    0,    0;
    0, -139;
    0,  139];
NeuronParams(1).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(1).compartmentZPositionMat = ...
[ -13,    0;
    0,   48;
   48,   48;
   48,  193;
  193,  330;
  -13,  -53;
  -53, -139;
  -53, -139];
NeuronParams(1).axisAligned = 'z';
NeuronParams(1).C = 1.0*2.96;
NeuronParams(1).R_M = 20000/2.96;
NeuronParams(1).R_A = 150;
NeuronParams(1).E_leak = -70;
NeuronParams(1).somaID = 1;
NeuronParams(1).basalID = [6, 7, 8];
NeuronParams(1).apicalID = [2 3 4 5];


%% Stimuli

% providing all neurons with background current input - taken from the
% VERTEX website tutorials:
% 
NeuronParams(1).Input(1).inputType = 'i_ou';
NeuronParams(1).Input(1).meanInput = 330;
NeuronParams(1).Input(1).stdInput = 80;
NeuronParams(1).Input(1).tau = 2;
    
NeuronParams(1).Input(2).inputType = 'i_efield';
NeuronParams(1).Input(2).timeOn = 0;
NeuronParams(1).Input(2).timeOff = 100;
NeuronParams(1).Input(2).timeDependence = 'rand';


%% Connectivity
% Connectivity parameteres are specified as before, except that now we have
% several layers, the numbers can be specified per layer. Parameters that
% can specified on a per-layer basis are |axonArborRadius|,
% |axonArborLimit|, and |numConnectionsToAllFromOne|: 

ConnectionParams(1).axonArborRadius = 300;
ConnectionParams(1).axonArborLimit = 600;

%%
% The above code sets the axons arbor radius of the layer 3 pyramidal cells to
% 250 microns in layer 3, 200 microns in layer 4 and 100 microns in layer
% 5, as well as setting the axon arbor limit to 500, 400 and 200 microns in
% those layers, respectively. To set the number of connections between
% neuron groups in different layers, we use the same syntax:

ConnectionParams(1).numConnectionsToAllFromOne{1} = 1500;


%%
% Most neurons only reside in their soma layer, so many of the values are
% zero. However, layer 5 neurons are large and so span all three layers.
% Layer 3 pyramidal neurons can make connections with layer 5 pyramidal
% neurons in layer 3 and layer 5. VERTEX automatically calculates which
% compartments of each neuron type are in each layer.
%
% The other connection parameters are specified as before:

ConnectionParams(1).synapseType = ...
  {'i_exp'};
ConnectionParams(1).targetCompartments = ...
  {NeuronParams(1).basalID,NeuronParams(1).apicalID};
ConnectionParams(1).weights = {2};
ConnectionParams(1).tau = {2};

ConnectionParams(1).axonArborSpatialModel = 'gaussian';
ConnectionParams(1).sliceSynapses = true;
ConnectionParams(1).axonConductionSpeed = 0.3;
ConnectionParams(1).synapseReleaseDelay = 0.5;

%%
% And now we set the connectivity parameters for the other neuron groups:


%%
% The connectivity statistics are influenced by the data in Binzegger et
% al. 2004, while the weights are set arbitrarily to produce some
% interesting spiking behaviour in the network (oscillations). Note that when
% there are no connections between groups (e.g. neurons in group 6 make no
% connections to neurons in groups 1-4), the relevant cells in the connection
% parameters are set to be empty matrices.

%% Recording and simulation settings
% These are set in the same way as previous tutorials. This time we
% position the electrodes so as to cover the larger z-depth of the model.

RecordingSettings.saveDir = '~/VERTEX_results_stimulation_3D_2/';
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(0:500:2000, 200, 700:-100:0);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;

if isfield(TissueParams,'R')
    totNeurons = floor(pi*((TissueParams.R/1000)^2)*(TissueParams.Z/1000)*TissueParams.neuronDensity);
else
    totNeurons = floor(TissueParams.X/1000)*(TissueParams.Y/1000)*(TissueParams.Z/1000)*TissueParams.neuronDensity;
end

RecordingSettings.v_m = 1:1:totNeurons;
RecordingSettings.maxRecTime = 100;
RecordingSettings.sampleRate = 18000;

SimulationSettings.simulationTime = 50;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;

SimulationSettings.ef_stimulation = true;
SimulationSettings.fu_stimulation = false;


%% Run simulation and load results
% We run the simulation and load results as before. Note that this simulation
% will take some time, as it contains more than 10,000 spiking neurons.

[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
%%
runSimulation(params, connections, electrodes);
Results = loadResults(RecordingSettings.saveDir);


firingRates = groupRates(Results, 10, 50);

%%
% Note that much of the high frequency content in these plots comes from
% the spiking mechanism of the neurons, which is not physiologically
% realistic. Therefore we would recommend rerunning the simulation with the
% spike loading functionality introduced in tutorial 3 and purely passive
% neurons to remove this unrealistic contribution to the LFP before
% performing more in-depth LFP analyses.
%

%% References
% Binzegger T, Douglas RJ, Martin KAC (2004) A quantitative map of the circuit
% of cat primary visual cortex. J Neurosci 24(39):8441?8453
%
% Tomsett RJ, Ainsworth M, Thiele A, Sanayei M, Chen X et al. (2014)
% Virtual Electrode Recording Tool for EXtracellular potentials (VERTEX):
% comparing multi-electrode recordings from simulated and biological
% mammalian cortical tissue, Brain Structure and Function.
% doi:10.1007/s00429-014-0793-x