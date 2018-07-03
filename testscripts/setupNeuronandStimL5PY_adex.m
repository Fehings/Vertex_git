% clear all;
% close all;
%% Load Neuron Model from neuroml
 %filename = '/home/campus.ncl.ac.uk/b3046588/Dropbox/RatNeuronMorphologies/cADpyr232_L5_TTPC1_0fb1ca4724_0_0.cell.nml';
% nmlmodel = readNeuronML_parentids( filename );
%  NeuronParams = Nml2Vertex(nmlmodel);
%nmlmodelred = reducesoma(nmlmodel);
 %%
% NeuronParams = Nml2Vertex(nmlmodelred);
 %% Add other neuron parameters
NeuronParams.neuronModel = 'adex';

% adex params
NeuronParams.V_t = -52;
NeuronParams.v_cutoff = -47;
NeuronParams.delta_t = 2;
NeuronParams.a = 10;
NeuronParams.tau_w = 75;
NeuronParams.b = 345;
NeuronParams.v_reset = -60;

NeuronParams.numCompartments = 14;
NeuronParams.compartmentParentArr = [0 1 2 2 4 5 5 1 7 7 7 7 1 1];
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


%% 
NeuronParams.dendritesID = [2 3 4 5 6 7 8 9 10];
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

%%
% Set up stimulation field, load it from the 
% TissueParams.StimulationField = [200,1200,100]; % slicecutoutsmallnew

NeuronParams.Input.inputType = 'i_ou';
NeuronParams.Input.meanInput = 590; % original value at 860 for gamma oscillations
NeuronParams.Input.tau = 2;
NeuronParams.Input.stdInput = 260;

% NeuronParams.Input(2).inputType = 'i_step';
% NeuronParams.Input(2).amplitude = [10];
% NeuronParams.Input(2).timeOn = 60;
% NeuronParams.Input(2).timeOff = 70;
% NeuronParams.Input(2).compartmentsInput = 1;
TissueParams.numGroups = 1;
TissueParams.N = 1;

% [TissueParams.StimulationField, TissueParams.model] = invitroSliceStim('catvisblend1.stl',-4);
 brainslice3Dorig
TissueParams.StimulationField = result;
TissueParams.model = model;
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 600;
%TissueParams.StimulationField = 'pointstim';
 NeuronParams.TissueParams = TissueParams;
 %%
 [NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
  
 save('neuroandstimparams.mat','NP','TissueParams')
 %%

 v_ext = get_V_ext(NP.midpoints, TissueParams.StimulationField,1);
  viewMorphologyColour(NP,v_ext(1,:),0);
 %%
%   v_ext = SP.v_ext{1};
%  v_ext_nml(NeuronParams.nmlid) = v_ext;
%  save('v_ext.mat','v_ext_nml');