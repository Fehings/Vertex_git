%% Single neuron plot, no noise
% 
% This script loads and runs a simulation of a single neuron, in this case
% Layer 2/3 basket interneuron. To plot a different neuron change the
% neuron parameters.

set(0,'defaultfigurecolor',[1 1 1])
%% Add neuron parameters
NeuronParams.neuronModel = 'passive';
NeuronParams.C = 1*2.93;
NeuronParams.R_M = 15000/2.93;
NeuronParams.R_A = 1000; %150;
NeuronParams.E_leak = -70;
NeuronParams.V_t = -50;
NeuronParams.v_cutoff = -45;
NeuronParams.delta_t = 2;
NeuronParams.a = 0.04;
NeuronParams.tau_w = 10;
NeuronParams.b = 40;
NeuronParams.v_reset = -65;
NeuronParams.somaLayer = 2;
NeuronParams.numCompartments = 7;
NeuronParams.compartmentLengthArr = [10 56 151 151 56 151 151];
NeuronParams.compartmentDiameterArr = [24 1.93 1.95 1.95 1.93 1.95 1.95];
NeuronParams.compartmentParentArr = [0 1 2 2 1 5 5];
NeuronParams.compartmentXPositionMat = [0 0; 0 0; 0 107; 0 -107; ...
                                 0 0; 0 -107; 0 107];
NeuronParams.compartmentYPositionMat = [0 0; 0 0; 0 0; 0 0; 0 0; ...
                                 0 0; 0 0];
NeuronParams.compartmentZPositionMat = [-10 0; 0 56; 56 163; ...
                                  56 163; -10 -66; -66 -173; ...
                                 -66 -173];
NeuronParams.somaID = 1;
NeuronParams.basalID = [3 4 5 6 7];
NeuronParams.proximalID = [2 5];
NeuronParams.distalID = [3 4 6 7];
NeuronParams.labelNames = {'somaID', 'basalID','proximalID','distalID'};
%NeuronParams.minCompartmentSize = 4;
NeuronParams.axisAligned = '';
NeuronParams.Input(1).inputType = 'i_ou';
NeuronParams.Input(1).meanInput = 0; %200
NeuronParams.Input(1).tau = 2;
NeuronParams.Input(1).stdInput = 0;


%% Stimulation
% Set up stimulation field, load it from the 
% TissueParams.StimulationField = [200,1200,100]; % slicecutoutsmallnew
NeuronParams.Input.inputType = 'i_step';
NeuronParams.Input.amplitude = [10];
NeuronParams.Input.timeOn = 60;
NeuronParams.Input.timeOff = 70;
NeuronParams.Input.compartmentsInput = 1;
TissueParams.numGroups = 1;
TissueParams.N = 1;

%[TissueParams.StimulationField, TissueParams.model] = invitroSliceStim('catvisblend1.stl',4);
brainslice3Dorig%
TissueParams.StimulationField = result;
TissueParams.model = model;
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 600;
NeuronParams.TissueParams = TissueParams;
 
 %%
 [NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
 save('neuroandstimparams.mat','NP','TissueParams')
 