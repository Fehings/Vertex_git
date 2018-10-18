%% Instructions for simulating the effect of a field on a single neuron
%Specify the neuron morphology
clear all;
close all;
%% Load Neuron Model from neuroml
% optional - if you wish to load in a detailed morphology uncomment this
% section but comment out the model morphology section
 %filename = '/home/campus.ncl.ac.uk/b3046588/Dropbox/RatNeuronMorphologies/cADpyr232_L5_TTPC1_0fb1ca4724_0_0.cell.nml';
% nmlmodel = readNeuronML_parentids( filename );
%  NeuronParams = Nml2Vertex(nmlmodel);
%nmlmodelred = reducesoma(nmlmodel);
 %%
% NeuronParams = Nml2Vertex(nmlmodelred);
 %% Specify passive dynamics
NeuronParams.neuronModel = 'passive';

%% Model morphology
NeuronParams.numCompartments = 14;
%Compartment connectivity represented as a tree structure
%each entry should specify the parent of the compartment (soma parent is 0)
NeuronParams.compartmentParentArr = [0 1 2 2 4 5 5 1 7 7 7 7 1 1]; 
NeuronParams.compartmentLengthArr = [35 65 152 298 502 293 293 52 186 186 186 186 90 90];
NeuronParams.compartmentDiameterArr = ...
  [15 8.36 2.65 4.10 2.25 2.4 2.4 5.94 3.45 3.45 3.45 3.45 3.45 3.45];
%Specify the coordinates of the start and end points of each compartment
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
% Specify minimum compartment size
% Will automatically adjust the neuron model so that no compartment is
% longer than specified value.
 NeuronParams.minCompartmentSize= 2;
% Specify compartment labels - used to identify the different sections of
% the cell
NeuronParams.dendritesID = [2 3 4 5 6 7 8 9 10];
NeuronParams.somaID = 1;
NeuronParams.basalID = [8 9 10];
NeuronParams.proximalID = [2 8];
NeuronParams.distalID = [9 10];
NeuronParams.obliqueID = 3;
NeuronParams.apicalID = [4 5];
NeuronParams.trunkID = 2;
% Must provide list of names used for the different sections
NeuronParams.labelNames = {'somaID', 'basalID', 'proximalID', 'distalID', 'obliqueID', 'apicalID',...
    'trunkID', 'tuftID'};
%% Specify the physiological properties of the neuron
NeuronParams.C = 1.0*2.95;
NeuronParams.R_M = 20000/2.95;
NeuronParams.R_A = 150;
NeuronParams.E_leak = -70;

%% Specify current injection parameters
% Currently amplitude is set to 0 so no current injection will be applied
NeuronParams.Input.inputType = 'i_step';
NeuronParams.Input.amplitude = 0;
NeuronParams.Input.timeOn = 2;
NeuronParams.Input.timeOff = 6;
NeuronParams.Input.compartmentsInput = 1;
%% Specify a dummy TissueParams
% We have only one neuron group and one neuron.
TissueParams.numGroups = 1;
TissueParams.N = 1;

%% Specify field to use for stimulation.
% We need to place the stimulation field into TissueParams.StimulationField
% if you wish to use your own model here then you can interface by
% specifying a function name for TissueParams.StimulationField as a string.
% For example TissueParams.StimulationField =
% 'pointstim';
% Here the function pointstim would take in as parameter the positions of
% the compartments and calculate the field strength at those positions. 
% See the function pointstim in the vertex_stimulation directory to give
% some hints as to how to do this. Your function may interface with your
% external software to calculate the field at the positions specified.
% It is not necessary to specify TissueParams.model 
 [TissueParams.StimulationField, TissueParams.model] = invitroSliceStim('catvisblend1.stl',100);
%TissueParams.StimulationField = 'pointstim';
 NeuronParams.TissueParams = TissueParams;
 %% Build the neuron model and ready it for stimulation
 [NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
 %% Save the model to file
 save('neuroandstimparams.mat','NP','TissueParams')
 %% View the field strength at each compartment of the model
 v_ext = get_V_ext(NP.midpoints, TissueParams.StimulationField,1);
viewMorphologyColour(NP,v_ext(1,:),0);
%% Running the model
% To run the model call the run_stimsim function
 %%
%   v_ext = SP.v_ext{1};
%  v_ext_nml(NeuronParams.nmlid) = v_ext;
%  save('v_ext.mat','v_ext_nml');