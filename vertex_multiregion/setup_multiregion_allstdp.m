
% Set up script for the tutorial 2 style single layer network with coupled inhibitory and excitatory populations. 

%% Tissue parameters
% First we specify the same tissue parameters as in tutorial 1:

stdprate=0.1;

TissueParams.X = 2500;
TissueParams.Y = 400;
TissueParams.Z = 200;
TissueParams.neuronDensity = 25000;
TissueParams.numLayers = 1;
TissueParams.layerBoundaryArr = [200, 0];
TissueParams.numStrips = 10;
TissueParams.tissueConductivity = 0.3;
TissueParams.maxZOverlap = [-1 , -1];

%% Neuron parameters
% Next we will specify the parameters for our two neuron groups. We will
% use the neuron models described in (Tomsett et al. 2014) for layer 2/3
% pyramidal neurons and basket interneurons. We are going to set 85% of the
% neurons to be pyramidal cells, in neuron group 1.clear al

NeuronParams(1).modelProportion = 0.85;
NeuronParams(1).somaLayer = 1;

%%
% We are going to use the adaptive exponential (AdEx) model to generate
% spiking dynamics (Brette & Gerstner 2005). Our models will be different
% from the original AdEx model as they will also contain dendritic
% compartments so that they can generate an extracellular potential. The
% AdEx dynamics are in the soma compartment, while the dendrites are
% passive. The AdEx model requires us to specify some extra parameters that
% control the model dynamics:

NeuronParams(1).neuronModel = 'adex';
NeuronParams(1).V_t = -50;
NeuronParams(1).delta_t = 2;
NeuronParams(1).a = 2.6;
NeuronParams(1).tau_w = 65;
NeuronParams(1).b = 220;
NeuronParams(1).v_reset = -60;
NeuronParams(1).v_cutoff = -45;

%%
% |V_t| is the spike generation threshold (in mV), |delta_t| is the spike
% steepness parameter (in mV), |a| is the scale factor of the spike
% after-hyperpolarisation (AHP) current (in nanoSiemens), |tau_w| is the
% AHP current time constant (in ms), |b| is the instantaneous change in the
% AHP current after a spike (in pA), |v_reset| is the membrane potential
% that the soma compartment is reset to after firing a spike (in mV), and
% |v_cutoff| is the membrane potential at which a spike is detected (in
% mV). We recommend that this parameter is set to |V_t + 5|; if it is set 
% much higher, the exponential term in the AdEx equations can lead to the 
% membrane potentialexploding to a not-a-number (NaN) value, which breaks 
% things.
%
% The remaining parameters defining the structure and passive properties
% are the same as in Tutorial 1:
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
NeuronParams(1).labelNames = {'somaID', 'basalID','apicalID'};
NeuronParams(1).minCompartmentSize = 0.8;
%%
% In order to generate spikes, we need to provide the neurons with some
% input. We set the inputs to our neuron group in another structure array,
% called Inptut, that we create as a field in our NeuronParams(1)
% structure. Input is a structure array rather than just a structure
% so that we can specify multiple different inputs to the neurons in
% multiple Input array elements. For the moment, we're just going to use
% one input type: random currents with a mean value of 330 pA, a standard
% deviation of 90 pA, and a time constant of 2 ms. The type of random
% current we use is an Ornstein Uhlenbeck process, so the input type is set
% to |'i_ou'| (we could also apply our input as a conductance |'g_ou'|, in
% which case we would also need to set an |E_reversal| parameter to set the
% reversal potential).

NeuronParams(1).Input(1).inputType = 'i_ou';
NeuronParams(1).Input(1).meanInput = 330;
NeuronParams(1).Input(1).stdInput = 90;
NeuronParams(1).Input(1).tau = 2;

%%
% Next we set the parameters for the 2nd neuron group, which represent
% basket interneurons. These cells' dendrites are not aligned along a
% particular axis, so we set the |axisAligned| parameters to be empty. We
% set the parameters to give this neuron type fast-spiking behaviour.

NeuronParams(2).modelProportion = 0.15;
NeuronParams(2).somaLayer = 1;
NeuronParams(2).axisAligned = '';
NeuronParams(2).neuronModel = 'adex';
NeuronParams(2).V_t = -50;
NeuronParams(2).delta_t = 2;
NeuronParams(2).a = 0.04;
NeuronParams(2).tau_w = 10;
NeuronParams(2).b = 40;
NeuronParams(2).v_reset = -65;
NeuronParams(2).v_cutoff = -45;
NeuronParams(2).numCompartments = 7;
NeuronParams(2).compartmentParentArr = [0 1 2 2 1 5 5];
NeuronParams(2).compartmentLengthArr = [10 56 151 151 56 151 151];
NeuronParams(2).compartmentDiameterArr = ...
  [24 1.93 1.95 1.95 1.93 1.95 1.95];
NeuronParams(2).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  107;
    0, -107; 
    0,    0; 
    0, -107;
    0,  107];
NeuronParams(2).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(2).compartmentZPositionMat = ...
[ -10,    0;
    0,   56;
   56,  163;
   56,  163; 
  -10,  -66;
  -66, -173;
  -66, -173];
NeuronParams(2).C = 1.0*2.93;
NeuronParams(2).R_M = 15000/2.93;
NeuronParams(2).R_A = 150;
NeuronParams(2).E_leak = -70;
NeuronParams(2).dendritesID = [2 3 4 5 6 7];
NeuronParams(2).labelNames = {'dendritesID'};
NeuronParams(2).minCompartmentSize = 0.8;
NeuronParams(2).Input(1).inputType = 'i_ou';
NeuronParams(2).Input(1).meanInput = 190;
NeuronParams(2).Input(1).tau = 0.8;
NeuronParams(2).Input(1).stdInput = 50;


%% 
%Now setting up passive neurons which are dummy representatives of the inputs from other areas

NeuronParams(3) = NeuronParams(1); 
% they are going to be excitatory pyramidal dummy cells in this
% instance. Modify this to have them be whatever the incoming signals are
% generated by.
NeuronParams(3).neuronModel = 'passive'; %but with passive dynamics
NeuronParams(3).modelProportion = 0.1; 
NeuronParams(3).Input(1).inputType = 'i_ou'; %need to give it zero input.
NeuronParams(3).Input(1).meanInput = 0;
NeuronParams(3).Input(1).tau = 0.01;
NeuronParams(3).Input(1).stdInput = 0;


%% Connectivity parameters
% We set the connectivity parameters in the same way as in tutorial 1, but
% this time we need to specify the parameters for connections between the
% two groups. First we set the parameters for connections from group 1 (the
% pyramidal cells) to itself:

ConnectionParams(1).numConnectionsToAllFromOne{1} = 1700;
ConnectionParams(1).synapseType{1} = 'g_stdp';
ConnectionParams(1).targetCompartments{1} = {'basalID', ...
                                             'apicalID'};
ConnectionParams(1).weights{1} = 0.05;
ConnectionParams(1).tau{1} = 2;
ConnectionParams(1).rate{1} = stdprate;%0.01;
ConnectionParams(1).tPre{1} = 2;
ConnectionParams(1).tPost{1} = 2;
ConnectionParams(1).wmin{1} = 0.01;
ConnectionParams(1).wmax{1} = 100;
ConnectionParams(1).E_reversal{1} =0;


%%
% Then the parameters for connections from group 1 to group 2 (the basket
% interneurons):

ConnectionParams(1).numConnectionsToAllFromOne{2} = 600;
ConnectionParams(1).synapseType{2} = 'g_stdp';
ConnectionParams(1).targetCompartments{2} = {'dendritesID'};
ConnectionParams(1).weights{2} = 0.1;
ConnectionParams(1).tau{2} = 1;
ConnectionParams(1).rate{2} = stdprate;%0.01;
ConnectionParams(1).tPre{2} = 2;
ConnectionParams(1).tPost{2} = 2;
ConnectionParams(1).wmin{2} = 0.01;
ConnectionParams(1).wmax{2} = 100;
ConnectionParams(1).E_reversal{2} =0;

% and parameters for group 3, the external dummy nearons. No connections go
% to these, they only send signals they dont recieve any.

ConnectionParams(1).numConnectionsToAllFromOne{3} = 0;
ConnectionParams(1).synapseType{3} = 'g_stdp';
ConnectionParams(1).targetCompartments{3} = {};
ConnectionParams(1).weights{3} = 0;
ConnectionParams(1).tau{3} = 1;
ConnectionParams(1).rate{3} = stdprate;%0.01;
ConnectionParams(1).tPre{3} = 2;
ConnectionParams(1).tPost{3} = 2;
ConnectionParams(1).wmin{3} = 0.01;
ConnectionParams(1).wmax{3} = 100;
ConnectionParams(1).E_reversal{3} =0;

%%
% And then the generic parameters for connections from group 1:

ConnectionParams(1).axonArborSpatialModel = 'gaussian';
ConnectionParams(1).sliceSynapses = true;
ConnectionParams(1).axonArborRadius = 250;
ConnectionParams(1).axonArborLimit = 500;
ConnectionParams(1).axonConductionSpeed = 0.3;
ConnectionParams(1).synapseReleaseDelay = 0.5;

%%
% We repeat this process for connections from group 2:

ConnectionParams(2).numConnectionsToAllFromOne{1} = 1000;
ConnectionParams(2).synapseType{1} = 'g_stdp';
ConnectionParams(2).targetCompartments{1} = {'somaID'};
ConnectionParams(2).weights{1} = 0.2;
ConnectionParams(2).tau{1} = 6;
ConnectionParams(2).rate{1} = stdprate;%0.01;
ConnectionParams(2).tPre{1} = 2;
ConnectionParams(2).tPost{1} = 6;
ConnectionParams(2).wmin{1} = 0.01;
ConnectionParams(2).wmax{1} = 100;
ConnectionParams(2).E_reversal{1} =-70;

ConnectionParams(2).numConnectionsToAllFromOne{2} = 600;
ConnectionParams(2).synapseType{2} = 'g_stdp';
ConnectionParams(2).targetCompartments{2} = {'dendritesID'};
ConnectionParams(2).weights{2} = 0.2;
ConnectionParams(2).tau{2} = 3;
ConnectionParams(2).rate{2} = stdprate;%0.01;
ConnectionParams(2).tPre{2} = 2;
ConnectionParams(2).tPost{2} = 6;
ConnectionParams(2).wmin{2} = 0.01;
ConnectionParams(2).wmax{2} = 100;
ConnectionParams(2).E_reversal{2} =-70;

ConnectionParams(2).numConnectionsToAllFromOne{3} = 0;
ConnectionParams(2).synapseType{3} = 'g_stdp';
ConnectionParams(2).targetCompartments{3} = {};
ConnectionParams(2).weights{3} = 0;
ConnectionParams(2).tau{3} = 1;
ConnectionParams(2).rate{3} = stdprate;% 0.01;
ConnectionParams(2).tPre{3} = 2;
ConnectionParams(2).tPost{3} = 6;
ConnectionParams(2).wmin{3} = 0.01;
ConnectionParams(2).wmax{3} = 100;
ConnectionParams(2).E_reversal{3} =-70;

ConnectionParams(2).axonArborSpatialModel = 'gaussian';
ConnectionParams(2).sliceSynapses = true;
ConnectionParams(2).axonArborRadius = 200;
ConnectionParams(2).axonArborLimit = 500;
ConnectionParams(2).axonConductionSpeed = 0.3;
ConnectionParams(2).synapseReleaseDelay = 0.5;

%% 
% now for connections from the dummy population, representing the external
% connections. In this case they only connect to the excitatory group 1.

ConnectionParams(3).numConnectionsToAllFromOne{1} = 3000;
ConnectionParams(3).synapseType{1} = 'g_stdp'; %using plasticity on these synapses so the connection can change weight
ConnectionParams(3).targetCompartments{1} = {'basalID', ...
                                             'apicalID'};
ConnectionParams(3).weights{1} = 0.05;
ConnectionParams(3).tau{1} = 2;
% include a few additional parameters for the stdp to work:
ConnectionParams(3).rate{1} = 0.05;
ConnectionParams(3).tPre{1} = 2;
ConnectionParams(3).tPost{1} = 6;
ConnectionParams(3).wmin{1} = 0.01;
ConnectionParams(3).wmax{1} = 100;
ConnectionParams(3).E_reversal{1} =0;

% empty parameters for the non-existant connections from 3 to the
% interneurons and themselves.
ConnectionParams(3).numConnectionsToAllFromOne{2} = 0;
ConnectionParams(3).synapseType{2} = 'g_stdp';
ConnectionParams(3).targetCompartments{2} = {};
ConnectionParams(3).weights{2} = 0;
ConnectionParams(3).tau{2} = 1;
ConnectionParams(3).rate{2} = stdprate;%0.01;
ConnectionParams(3).tPre{2} = 2;
ConnectionParams(3).tPost{2} = 6;
ConnectionParams(3).wmin{2} = 0.01;
ConnectionParams(3).wmax{2} = 100;
ConnectionParams(3).E_reversal{2} =0;

ConnectionParams(3).numConnectionsToAllFromOne{3} = 0;
ConnectionParams(3).synapseType{3} = 'g_stdp';
ConnectionParams(3).targetCompartments{3} = {};
ConnectionParams(3).weights{3} = 0;
ConnectionParams(3).tau{3} = 1;
ConnectionParams(3).rate{3} = stdprate;%0.01;
ConnectionParams(3).tPre{3} = 2;
ConnectionParams(3).tPost{3} = 6;
ConnectionParams(3).wmin{3} = 0.01;
ConnectionParams(3).wmax{3} = 100;
ConnectionParams(3).E_reversal{3} =0;

% And then the generic parameters for connections from group 3:
ConnectionParams(3).axonArborSpatialModel = 'gaussian';
ConnectionParams(3).sliceSynapses = true;
ConnectionParams(3).axonArborRadius = 250;
ConnectionParams(3).axonArborLimit = 5000;
ConnectionParams(3).axonConductionSpeed = 0.3;
ConnectionParams(3).synapseReleaseDelay = 0.5;

