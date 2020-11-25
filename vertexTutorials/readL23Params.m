
function [TissueParams,NeuronParams,ConnectionParams] = readL23Params(isSTDP,noiseScaler,synapticScaler)
% readTutorial2Params sets up parameters for a VERTEX model with a single
% layer and two neuron populations, inhibitory basket interneurons and
% excitatory pyramidal cells. These parameters are based on the VERTEX
% website tutorial 2 (http://vertexsimulator.org/tutorial-2/)
%
% This function takes three optional input parameters, isSTDP is a boolean 
% flag which should be either 1 if you want STDP dynamics, or 0 if you want
% to run the model without STDP. By default the model runs without STDP.
%
% The second parameter is a noiseScaler, which is set to 1 by default and
% will have no effect on the model. This is a multiplier of the mean noise
% inputs to the different neuron populations. NB: as this just scales the
% mean of the noise, a value of zero will not make this system
% deterministic as there is a standard deviation applied too, which would
% need to be set to zero as well manually in the input parameters.
%
% The third parameter is the synapticScaler, which will act as a scaling
% factor for the initial synaptic weights. By default this is set to 1, so
% there will be no influence on the model defaults.
%
% This function can be run as:
% [TissueParams,NeuronParams,ConnectionParams] = readL23Params(isSTDP,noiseScaler)
% Alternatively the arguments can be left blank if you are happy with the
% defaults:
% [TissueParams,NeuronParams,ConnectionParams] = readL23Params()
%
% NB the main difference between this and readTutorial2Params is that this
% version will cause ALL synapses to be STDP enabled with the STDP flag on.
% The tutorial2 version will only turn on STDP for PY-PY connections.
%
% Nov 2020, FT.

if nargin<1
    isSTDP = 0;
    noiseScaler = 1;
    synapticScaler = 1;
end

%% Tissue parameters
% First we specify the same tissue parameters as in tutorial 2:

TissueParams.X = 2500;                      % Width (micrometres)
TissueParams.Y = 400;                       % Height (micrometres)
TissueParams.Z = 200;                       % Depth (micrometres)
TissueParams.neuronDensity = 2500;          % Neurons per cubic mm
TissueParams.numLayers = 1;                 % Number of tissue layers
TissueParams.layerBoundaryArr = [200, 0];   % Boundaries of the layers (depth)
TissueParams.numStrips = 10;                % Neuron placement blocks
TissueParams.tissueConductivity = 0.3;      % Extracellular conductivity
TissueParams.maxZOverlap = [-1 , -1];       % Max distance outside the boundries that dendrites can extend (-1 means no maximum)

%% Neuron parameters
% Next we will specify the parameters for our two neuron groups. We will
% use the neuron models described in (Tomsett et al. 2014) for layer 2/3
% pyramidal neurons and basket interneurons. We are going to set 85% of the
% neurons to be pyramidal cells, in neuron group 1.

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
NeuronParams(1).tau_w = 25;
NeuronParams(1).b = 220;
NeuronParams(1).v_reset = -60;
NeuronParams(1).v_cutoff = -45;

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
% things.%

%%
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
NeuronParams(1).R_A = 350;
NeuronParams(1).E_leak = -70;
NeuronParams(1).somaID = 1;
NeuronParams(1).basalID = [6, 7, 8];
NeuronParams(1).apicalID = [2 3 4 5];
NeuronParams(1).labelNames = {'somaID', 'basalID','apicalID'};
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
NeuronParams(1).Input(1).meanInput =330*noiseScaler;
NeuronParams(1).Input(1).stdInput = 60;
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
NeuronParams(2).R_A = 350;
NeuronParams(2).E_leak = -70;
NeuronParams(2).dendritesID = [2 3 4 5 6 7];
NeuronParams(2).labelNames = {'dendritesID'};
NeuronParams(2).Input(1).inputType = 'i_ou';
NeuronParams(2).Input(1).meanInput = 160*noiseScaler;
NeuronParams(2).Input(1).tau = 0.8;
NeuronParams(2).Input(1).stdInput = 40;


%% Connectivity parameters
% We set the connectivity parameters in the same way as in tutorial 2, but
% this time we include the option to specify the parameters for plasticity on the
% connection between group 1 and group 1. We will also use conductance
% based synapses, so the weights will be in nS and we will also need to
% specify a reversal potential.
 
% We use the g_exp_stdp class for the synapse type. This will
% give us conductance based synapses with spike timing dependent plasticity.
% We need to specify a preRate and postRate and also
% specify two time constants (tPre and tPost) that determine the rate at which the Apre and
% Apost variables decay.
% Apre is increased by preRate when a presynaptic spike occurs, and is added to the weight when a post synaptic spike occurs.
% Apost is increased by postRate (usually negative) and added (usually a subtraction) to the weight when a pre synaptic spike occurs. 

ConnectionParams(1).numConnectionsToAllFromOne{1} = 1700;
ConnectionParams(1).targetCompartments{1} = {'basalID', ...
                                             'apicalID'};
ConnectionParams(1).weights{1} = 0.05*synapticScaler;
ConnectionParams(1).tau{1} = 1;

ConnectionParams(1).numConnectionsToAllFromOne{2} = 600;
ConnectionParams(1).targetCompartments{2} = {'dendritesID'};
ConnectionParams(1).weights{2} = 0.1*synapticScaler;
ConnectionParams(1).tau{2} = 1;

if isSTDP
    ConnectionParams(1).synapseType{1} = 'g_exp_stdp';
    ConnectionParams(1).preRate{1} = 0.004;
    ConnectionParams(1).postRate{1} = -0.004;
    ConnectionParams(1).tPre{1} = 15;
    ConnectionParams(1).tPost{1} = 20;
    ConnectionParams(1).wmin{1} = 0;
    ConnectionParams(1).wmax{1} = 100;
    
    ConnectionParams(1).synapseType{2} = 'g_exp_stdp';
    ConnectionParams(1).preRate{2} = 0.004;
    ConnectionParams(1).postRate{2} = -0.004;
    ConnectionParams(1).tPre{2} = 15;
    ConnectionParams(1).tPost{2} = 20;
    ConnectionParams(1).wmin{2} = 0;
    ConnectionParams(1).wmax{2} = 100;
else
    ConnectionParams(1).synapseType{1} = 'g_exp';
    ConnectionParams(1).synapseType{2} = 'g_exp';
end

ConnectionParams(1).axonArborSpatialModel = 'gaussian';
ConnectionParams(1).sliceSynapses = true;
ConnectionParams(1).axonArborRadius = 25;
ConnectionParams(1).axonArborLimit = 50; 
ConnectionParams(1).axonConductionSpeed = 0.3;
ConnectionParams(1).synapseReleaseDelay = 0.5;
ConnectionParams(1).E_reversal{1} = -0;
ConnectionParams(1).E_reversal{2} = -0;

% %GABA_B synapses
ConnectionParams(2).numConnectionsToAllFromOne{1} = 1000;
ConnectionParams(2).targetCompartments{1} = {'somaID'};
ConnectionParams(2).weights{1} = 0.2*synapticScaler;
ConnectionParams(2).tau{1} = 3;

ConnectionParams(2).numConnectionsToAllFromOne{2} = 600;
ConnectionParams(2).targetCompartments{2} = {'dendritesID'};
ConnectionParams(2).weights{2} = 0.2*synapticScaler;
ConnectionParams(2).tau{2} = 6;

if isSTDP
    ConnectionParams(2).synapseType{1} = 'g_exp_stdp';
    ConnectionParams(2).preRate{1} = 0.004;
    ConnectionParams(2).postRate{1} = -0.004;
    ConnectionParams(2).tPre{1} = 15;
    ConnectionParams(2).tPost{1} = 20;
    ConnectionParams(2).wmin{1} = 0;
    ConnectionParams(2).wmax{1} = 100;
    ConnectionParams(2).synapseType{2} = 'g_exp_stdp';
    ConnectionParams(2).preRate{2} = 0.004;
    ConnectionParams(2).postRate{2} = -0.004;
    ConnectionParams(2).tPre{2} = 15;
    ConnectionParams(2).tPost{2} = 20;
    ConnectionParams(2).wmin{2} = 0;
    ConnectionParams(2).wmax{2} = 100;
else
    ConnectionParams(2).synapseType{1} = 'g_exp';
    ConnectionParams(2).synapseType{2} = 'g_exp';
end

ConnectionParams(2).axonArborSpatialModel = 'gaussian';
ConnectionParams(2).sliceSynapses = true;
ConnectionParams(2).axonArborRadius = 20;
ConnectionParams(2).axonArborLimit = 50;
ConnectionParams(2).axonConductionSpeed = 0.3;
ConnectionParams(2).synapseReleaseDelay = 0.5;
ConnectionParams(2).E_reversal{1} = -70;
ConnectionParams(2).E_reversal{2} = -70;

% Note that for the weights in |ConnectionParams(2)| we use positive
% values, even though basket interneurons are inhibitory.
% This is because the inhibitory nature of the synapses would be controlled by the
% synapses' reversal potential.
