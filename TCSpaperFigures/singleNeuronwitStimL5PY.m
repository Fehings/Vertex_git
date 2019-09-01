%% Single neuron plot, no noise
% 
% This script loads and runs a simulation of a single neuron, in this case
% Layer 5 pyramidal neuron. To plot a different neuron change the
% neuron parameters.

set(0,'defaultfigurecolor',[1 1 1])
%% Add neuron parameters
NeuronParams.neuronModel = 'passive';
NeuronParams.C = 1.0*2.95;
NeuronParams.R_M = 20000/2.95;
NeuronParams.R_A = 1000; %150;
NeuronParams.E_leak = -70;
NeuronParams.V_t = -52;
NeuronParams.v_cutoff = -47;
NeuronParams.delta_t = 2;
NeuronParams.a = 10;
NeuronParams.tau_w = 75;
NeuronParams.b = 345;
NeuronParams.v_reset = -60;
NeuronParams.somaLayer = 4;
NeuronParams.numCompartments = 9;
NeuronParams.compartmentLengthArr = [35 65 152 398 402 252 52 186 186];
NeuronParams.compartmentDiameterArr = [25 4.36 2.65 4.10 2.25 2.4 5.94 3.45 3.45];
NeuronParams.compartmentParentArr = [0 1 2 2 4 5 1 7 7];
NeuronParams.compartmentXPositionMat = [0 0; 0 0; 0 152; 0 0; 0 0; ...
                                 0 0; 0 0; 0 -193; 0 193];
NeuronParams.compartmentYPositionMat = [0 0; 0 0; 0 0; 0 0; 0 0; ...
                                 0 0; 0 0; 0 0; 0 0];
NeuronParams.compartmentZPositionMat = [-35 0; 0 65; 65 65; ...
                                  65 463; 463 865; 865 1117; ...
                                 -35 -87; -87 -193; -87 -193];
NeuronParams.somaID = 1;
NeuronParams.basalID = [7 8 9];
NeuronParams.proximalID = [2 7];
NeuronParams.distalID = [8 9];
NeuronParams.obliqueID = 3;
NeuronParams.apicalID = [4 5];
NeuronParams.trunkID = 2;
NeuronParams.tuftID = 6;
NeuronParams.labelNames = {'somaID', 'basalID','proximalID','distalID','obliqueID','apicalID','trunkID','tuftID'};
%NP(9).minCompartmentSize = 4;
NeuronParams.axisAligned = 'z';
NeuronParams.Input(1).inputType = 'i_ou';
NeuronParams.Input(1).meanInput = 0; % original value at 860 for gamma oscillations
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
 save('neuroandstimparamsL23P.mat','NP','TissueParams')

