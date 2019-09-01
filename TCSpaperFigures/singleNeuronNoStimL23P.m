%% Single neuron plot, no noise
% 
% This script loads and runs a simulation of a single neuron, in this case
% Layer 2/3 pyramidal neuron. To plot a different neuron change the
% neuron parameters.

set(0,'defaultfigurecolor',[1 1 1])
%% Add neuron parameters
NeuronParams.neuronModel = 'passive';
NeuronParams.C = 1.0*2.96;
NeuronParams.R_M = 20000/2.96;
NeuronParams.R_A = 1000;%150;
NeuronParams.E_leak = -70;
NeuronParams.V_t = -50;
NeuronParams.delta_t = 2;
NeuronParams.a = 2.6;
NeuronParams.tau_w = 65;
NeuronParams.b = 220;
NeuronParams.v_reset = -60;
NeuronParams.v_cutoff = -45;
NeuronParams.somaLayer = 2;
NeuronParams.numCompartments = 8;
NeuronParams.compartmentLengthArr = [13 48 124 145 137 40 143 143];
NeuronParams.compartmentDiameterArr = [29.8 3.75 1.91 2.81 2.69 2.62 1.69 1.69];
NeuronParams.compartmentParentArr = [0 1 2 2 4 1 6 6];
NeuronParams.compartmentXPositionMat = [0 0; 0 0; 0 124; 0 0; 0 0; ...
                                 0 0; 0 -139; 0 139];
NeuronParams.compartmentYPositionMat = [0 0; 0 0; 0 0; 0 0; 0 0; ...
                                 0 0; 0 0; 0 0];
NeuronParams.compartmentZPositionMat = [-13 0; 0 48; 48 48; 48 193; ...
                                 193 330; -13 -53; -53 -139; ...
                                 -53 -139];
NeuronParams.somaID = 1;
NeuronParams.basalID = [6 7 8];
NeuronParams.proximalID = [2 6];
NeuronParams.distalID = [7 8];
NeuronParams.obliqueID = 3;
NeuronParams.apicalID = 4;
NeuronParams.trunkID = 2;
NeuronParams.tuftID = 5;
NeuronParams.labelNames = {'somaID', 'basalID','proximalID','distalID','obliqueID','apicalID','trunkID','tuftID'};
NeuronParams.minCompartmentSize = 4;
NeuronParams.axisAligned = 'z';
NeuronParams.Input(1).inputType = 'i_ou';
NeuronParams.Input(1).meanInput = 0; % original value at 360 for gamma oscillations
NeuronParams.Input(1).tau = 2;
NeuronParams.stdInput = 0;




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
brainslice3Dzerostim%
TissueParams.StimulationField = result;
TissueParams.model = model;
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 600;
NeuronParams.TissueParams = TissueParams;
 
 %%
 [NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
 save('neuroandstimparams.mat','NP','TissueParams')
