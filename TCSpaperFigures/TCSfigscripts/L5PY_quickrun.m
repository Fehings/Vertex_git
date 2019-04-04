%% Single neuron plot, no noise
% 
% This script loads and runs a simulation of a single neuron, in this case
% Layer 5 pyramidal neuron. To plot a different neuron change the
% neuron parameters.

set(0,'defaultfigurecolor',[1 1 1])
%% Add neuron parameters
NeuronParams.neuronModel = 'passive';
NeuronParams.numCompartments = 14;
NeuronParams.compartmentParentArr = [0 1 2 2 4 5 5 1 7 7 7 7 1 1]; % what compartments are connected to what others. 
%Soma is always compartment '1', with parent 0. So parent 1 means it's connected to the soma.
NeuronParams.compartmentLengthArr = [35 65 152 298 502 293 293 52 186 186 186 186 90 90];
NeuronParams.compartmentDiameterArr = ...
  [15 8.36 2.65 4.10 2.25 2.4 2.4 5.94 3.45 3.45 3.45 3.45 3.45 3.45];
NeuronParams.compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  152;
    0,    0; 
    0,    0;
    0, -150;
    0,  150;
    0,    0;
    0, -193;
    0,  193;
    0, -153;
    0,  153;
    0,  90;
    0,  -90];
NeuronParams.compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    -90;
    0,    90;
    0,    0;
    0,  0];
NeuronParams.compartmentZPositionMat = ...
[ -35,    0;
    0,   65;
   65,   65;
   65,  363;
  363,  700;
  700, 1017;
  700, 1017;
  -35,  -100;
  -100, -193;
  -100, -193;
  -100, -193;
  -100, -193
  -50,    -60;
  -50,    -60];

NeuronParams.C = 1.0*2.95;
NeuronParams.R_M = 20000/2.95;
NeuronParams.R_A = 150;
NeuronParams.E_leak = -70;
NeuronParams.dendritesID = [2 3 4 5 6 7 8 9 10];
NeuronParams.somaID = 1;
NeuronParams.basalID = [8 9 10];
NeuronParams.proximalID = [2 8];
NeuronParams.distalID = [9 10];
NeuronParams.obliqueID = 3;
NeuronParams.apicalID = [4 5];
NeuronParams.trunkID = 2;
% NeuronParams.tuftID = [6 7];
NeuronParams.numCompartments = 10;
NeuronParams.compartmentParentArr = [0 1 2 2 4 5 5 1 8 8 ];
NeuronParams.compartmentLengthArr = [35 30 152 298 502 293 293 82 186 186];
NeuronParams.compartmentDiameterArr = ...
  [12 6.36 2.65 5.10 2.25 2.4 2.4 5.94 3.45 3.45];
NeuronParams.compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  152;
    0,    0; 
    0,    0;
    0, -150;
    0,  150;
    0,    0;
    0, -193;
    0,  193];
NeuronParams.compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams.compartmentZPositionMat = ...
[ 0,    35;
    35,   65;
   65,   65;
   65,  363;
  363,  865;
  865, 1117;
  865, 1117;
  0,  -87;
  -87, -193;
  -87, -193];
NeuronParams.C = 1.0*2.95;
NeuronParams.R_M = 20000/2.95;
NeuronParams.R_A = 150;
NeuronParams.E_leak = -70;
% NeuronParams.dendritesID = [2 3 4 5 6 7 8 9 10];
%%
  NeuronParams.somaID = 1;
NeuronParams.basalID = [8 9 10];
NeuronParams.proximalID = [2 8];
NeuronParams.distalID = [9 10];
NeuronParams.obliqueID = 3;
NeuronParams.apicalID = [4 5];
NeuronParams.trunkID = 2;
NeuronParams.tuftID = [6 7];
 NeuronParams.minCompartmentSize= 0.25;
NeuronParams.labelNames = {'somaID', 'basalID', 'proximalID', 'distalID', 'obliqueID', 'apicalID',...
    'trunkID', 'tuftID'};



%% Stimulation

NeuronParams.Input.inputType = 'i_step';
NeuronParams.Input.amplitude = 0;
NeuronParams.Input.timeOn = 0;
NeuronParams.Input.timeOff = 1;
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

TissueParams.numGroups = 1;
TissueParams.N = 1;
 
 %%
 [NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
 save('neuroandstimparamsL23P.mat','NP','TissueParams')
 %%

 v_ext = get_V_ext(NP.midpoints, TissueParams.StimulationField,1);

 %%
%   v_ext = SP.v_ext{1};
%  save('v_ext.mat','v_ext_nml');

% Need to run until the model stabilises.
SimulationParams.timeStep = 0.001;
SimulationParams.simulationTime = 40;
SimulationParams.TP = TissueParams;
[v_m, I_input,NM] = neuronDynamicsStimPost(NP, SimulationParams);
%%
v_m = squeeze(v_m);
I_input = squeeze(I_input);
for iComp = 1:length(v_m(:,1))
    [a,ind] = max(abs(v_m(iComp,:)-(-70)));
      vm_diff(iComp) = v_m(iComp,ind);
end
vdiff = max(abs(-70-(v_m')));

vmax = max(abs(-70-(v_m')));

figure
viewMorphologyColour(NP, v_m(:,end)+70,0); %,3.0421

figure
plot(v_m(1,:)) % plot soma membrane potential over time


