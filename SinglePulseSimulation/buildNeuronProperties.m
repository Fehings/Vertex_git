
totalneurons = 0;
for n = 1:length(TissueParams.neuron_names)
    totalneurons = totalneurons + neuronnumbers.(TissueParams.neuron_names{n});
end
% 18294 neurons in 3 layers in volume of 0.29mm^2 
totalneurons = double(totalneurons);
%Number of all neurons from datasheet

L23_PC = 2421;



% 7524 neurons in layer 23  : 7524/18294 = 0.4113 
% Out of 
% 2421 pyramidal cells 277 LBC, 160 NBC, 99 SBC, 202 MC
% total : 3265
% proportion of PyC : 0.74 of layer 23 : 0.304 of total
% proportion of BC : 0.2585 of layer 23 : 0.1063 of total
% 
modpropL23PC = double(neuronnumbers.L23_PC)/totalneurons;
modpropL23NBC = double(neuronnumbers.L23_NBC)/totalneurons;
modpropL23LBC = double(neuronnumbers.L23_LBC)/totalneurons;
modpropL23SBC = double(neuronnumbers.L23_SBC)/totalneurons;
modpropL23MC = double(neuronnumbers.L23_MC)/totalneurons;
%%
%Setting Neuron parameters and shapes.


% Pyramidal cells in layer 23
NeuronParams(1).somaLayer = 2; 
NeuronParams(1).modelProportion = modpropL23PC;
NeuronParams(1).neuronModel = 'adex';
NeuronParams(1).V_t = -50;
NeuronParams(1).delta_t = 2;
NeuronParams(1).a = 2.6;
NeuronParams(1).tau_w = 35;
NeuronParams(1).b = 220;
NeuronParams(1).v_reset = -60;
NeuronParams(1).v_cutoff = -45;
NeuronParams(1).numCompartments = 8;
NeuronParams(1).compartmentParentArr = [0, 1, 2, 2, 4, 1, 6, 6];
NeuronParams(1).compartmentLengthArr = [13 48 124 145 207 40 143 143];
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
  193,  400;
  -13,  -53;
  -53, -139;
  -53, -139];

NeuronParams(1).axisAligned = 'z';
NeuronParams(1).C = 1.0*2.96;
NeuronParams(1).R_M = 20000/2.96;
NeuronParams(1).R_A = 150;
NeuronParams(1).E_leak = -70;
NeuronParams(1).somaID = 1;
NeuronParams(1).basalID = [6 7 8];
NeuronParams(1).proximalID = [2 6];
NeuronParams(1).distalID = [7 8];
NeuronParams(1).obliqueID = 3;
NeuronParams(1).apicalID = 4;
NeuronParams(1).trunkID = 2;
NeuronParams(1).tuftID = 5;
NeuronParams(1).labelnames = {'somaID', 'basalID', 'proximalID', 'distalID', 'obliqueID', 'apicalID',...
    'trunkID', 'tuftID'};

%Layer 23
%Nest Basket Cell

NeuronParams(2).somaLayer = 2; 
NeuronParams(2).modelProportion = modpropL23NBC;
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
NeuronParams(2).somaID = 1;
NeuronParams(2).basalID = [3 4 5 6 7];
NeuronParams(2).proximalID = [2 5];
NeuronParams(2).distalID = [3 4 6 7];
NeuronParams(2).labelNames = {'somaID','basalID', 'proximalID', 'distalID'};


%Layer 23 
%Large Basket Cell
NeuronParams(3) = NeuronParams(2);
NeuronParams(3).modelProportion = modpropL23LBC;
%Layer 23 
%Small Basket Cell
NeuronParams(4) = NeuronParams(2);
NeuronParams(4).modelProportion = modpropL23SBC;
NeuronParams(4).numCompartments = 7;
NeuronParams(4).compartmentParentArr = [0 1 2 2 1 5 5];
NeuronParams(4).compartmentLengthArr = [10 56 121 121 56 121 121];
NeuronParams(4).compartmentDiameterArr = ...
  [18 1.93 1.95 1.95 1.93 1.95 1.95];
NeuronParams(4).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  87;
    0, -87;
    0,    0;
    0, -87;
    0,  87];
NeuronParams(4).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(4).compartmentZPositionMat = ...
[ -10,    0;
    0,   56;
   56,  143;
   56,  143;
  -10,  -66;
  -66, -143;
  -66, -143];
NeuronParams(4).C = 1.0*2.93;
NeuronParams(4).R_M = 15000/2.93;
NeuronParams(4).R_A = 150;
NeuronParams(4).E_leak = -70;
NeuronParams(4).dendritesID = [2 3 4 5 6 7];
NeuronParams(4).somaID = 1;
NeuronParams(4).basalID = [3 4 5 6 7];
NeuronParams(4).proximalID = [2 5];
NeuronParams(4).distalID = [3 4 6 7];

%Layer 23
%Martinotti Cell
NeuronParams(5) = NeuronParams(2);
NeuronParams(5).V_t = -55;
NeuronParams(5).v_cutoff = -50;
NeuronParams(5).delta_t = 2.2;
NeuronParams(5).a = .04;
NeuronParams(5).tau_w = 35;
NeuronParams(5).b = 75;
NeuronParams(5).v_reset = -62;
NeuronParams(5).modelProportion = modpropL23MC;


modpropL4PC = double(neuronnumbers.L4_PC)/totalneurons;
modpropL4NBC = double(neuronnumbers.L4_NBC)/totalneurons;
modpropL4LBC = double(neuronnumbers.L4_LBC)/totalneurons;
modpropL4SBC = double(neuronnumbers.L4_SBC)/totalneurons;
modpropL4MC = double(neuronnumbers.L4_MC)/totalneurons;
modpropL4SS = double(neuronnumbers.L4_SS)/totalneurons;
modpropL4SP = double(neuronnumbers.L4_SP)/totalneurons;





%Layer4
%Spiny Stellate


NeuronParams(6) = NeuronParams(2);% spiny stellates same morphology as basket

NeuronParams(6).somaLayer = 3;     % but in layer 4
NeuronParams(6).modelProportion = modpropL4SS;
NeuronParams(6).v_cutoff = -45;
NeuronParams(6).neuronModel = 'adex';
NeuronParams(6).V_t = -50;
NeuronParams(6).delta_t = 2.2;
NeuronParams(6).a = 0.35;
NeuronParams(6).tau_w = 150;
NeuronParams(6).b = 40;
NeuronParams(6).v_reset = -70;
%Layer 4
%Star Pyramidal


NeuronParams(7) = NeuronParams(1);%use same morph as pyramidal cells
NeuronParams(7).somaLayer = 3;     % but in layer 4
NeuronParams(7).modelProportion = modpropL4SP;


%Layer 4
%Pyramical Cell


NeuronParams(8) = NeuronParams(1);
NeuronParams(8).somaLayer = 3;     % but in layer 4
NeuronParams(8).modelProportion = modpropL4PC;
NeuronParams(8).neuronModel = 'adex';
NeuronParams(8).V_t = -50;
NeuronParams(8).delta_t = 2;
NeuronParams(8).a = 2.6;
NeuronParams(8).tau_w = 35;
NeuronParams(8).b = 220;
NeuronParams(8).v_reset = -60;
NeuronParams(8).v_cutoff = -45;
NeuronParams(8).numCompartments = 8;
NeuronParams(8).compartmentParentArr = [0, 1, 2, 2, 4, 1, 6, 6];
NeuronParams(8).compartmentLengthArr = [13 48 124 145 257 40 302 302];
NeuronParams(8).compartmentDiameterArr = ...
  [29.8, 3.75, 1.91, 2.81, 2.69, 2.62, 1.69, 1.69];
NeuronParams(8).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  124;
    0,    0;
    0,    0;
    0,    0;
    0, -239;
    0,  239];
NeuronParams(8).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(8).compartmentZPositionMat = ...
[ -13,    0;
    0,   48;
   48,   48;
   48,  193;
  193,  450;
  -13,  -53;
  -53, -239;
  -53, -239];

NeuronParams(8).axisAligned = 'z';
NeuronParams(8).C = 1.0*2.96;
NeuronParams(8).R_M = 20000/2.96;
NeuronParams(8).R_A = 600;
NeuronParams(8).E_leak = -70;

%Layer 4 
%Nest Basket Cell
NeuronParams(9) = NeuronParams(2);
NeuronParams(9).somaLayer = 3;     % but in layer 4
NeuronParams(9).modelProportion = modpropL4NBC;

%Layer 4
%Large Basket Cell

NeuronParams(10) = NeuronParams(2);
NeuronParams(10).somaLayer = 3;     % but in layer 4
NeuronParams(10).modelProportion = modpropL4LBC;

%Layer 4 
%Small Basket Cell


NeuronParams(11) = NeuronParams(4);
NeuronParams(11).somaLayer = 3;     % but in layer 4
NeuronParams(11).modelProportion = modpropL4SBC;


%Layer 4
%Martinotti Cell
NeuronParams(12) = NeuronParams(5);
NeuronParams(12).somaLayer = 3;     % but in layer 4
NeuronParams(12).modelProportion = modpropL4MC;

%Layer 5
%Layer 5 neuron proportion calculations. 



modpropL5TTPC1 = double(neuronnumbers.L5_TTPC1)/totalneurons;
modpropL5TTPC2 = double(neuronnumbers.L5_TTPC2)/totalneurons;
modpropL5UTPC = double(neuronnumbers.L5_UTPC)/totalneurons;
modpropL5STPC = double(neuronnumbers.L5_UTPC)/totalneurons;

modpropL5NBC = double(neuronnumbers.L5_NBC)/totalneurons;
modpropL5LBC = double(neuronnumbers.L5_LBC)/totalneurons;
modpropL5SBC = double(neuronnumbers.L5_SBC)/totalneurons;
modpropL5MC = double(neuronnumbers.L5_MC)/totalneurons;



%Layer 5
%Thick tufted pyramidal cell 2
NeuronParams(13) = NeuronParams(1);
NeuronParams(13).somaLayer = 4; % Pyramidal cells in layer 5
NeuronParams(13).modelProportion = modpropL5TTPC2;
NeuronParams(13).axisAligned = 'z';
NeuronParams(13).neuronModel = 'adex';
NeuronParams(13).V_t = -52;
NeuronParams(13).delta_t = 2;
NeuronParams(13).a = 10;
NeuronParams(13).tau_w = 45;
NeuronParams(13).b = 345;
NeuronParams(13).v_reset = -60;
NeuronParams(13).v_cutoff = -47;
NeuronParams(13).numCompartments = 10;
NeuronParams(13).compartmentParentArr = [0 1 2 2 4 5 5 1 7 7];
NeuronParams(13).compartmentLengthArr = [35 65 152 298 502 293 293 52 186 186];
NeuronParams(13).compartmentDiameterArr = ...
  [25 10.36 2.65 5.10 2.25 2.4 2.4 5.94 3.45 3.45];
NeuronParams(13).compartmentXPositionMat = ...
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
NeuronParams(13).compartmentYPositionMat = ...
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
NeuronParams(13).compartmentZPositionMat = ...
[ -35,    0;
    0,   65;
   65,   65;
   65,  363;
  363,  865;
  865, 1117;
  865, 1117;
  -35,  -87;
  -87, -193;
  -87, -193];
NeuronParams(13).C = 1.0*2.95;
NeuronParams(13).R_M = 20000/2.95;
NeuronParams(13).R_A = 150;
NeuronParams(13).E_leak = -70;
NeuronParams(13).dendritesID = [2 3 4 5 6 7 8 9 10];
NeuronParams(13).somaID = 1;
NeuronParams(13).basalID = [8 9 10];
NeuronParams(13).proximalID = [2 8];
NeuronParams(13).distalID = [9 10];
NeuronParams(13).obliqueID = 3;
NeuronParams(13).apicalID = [4 5];
NeuronParams(13).trunkID = 2;
NeuronParams(13).tuftID = [6 7];


%Layer 5 Thick tufted pyramidal 1
NeuronParams(14) = NeuronParams(13);
NeuronParams(14).modelProportion = modpropL5TTPC1;

%Layer 5 Untufted pyramidal cell
NeuronParams(15)=NeuronParams(13);
NeuronParams(15).modelProportion = modpropL5UTPC;

NeuronParams(15).axisAligned = 'z';
NeuronParams(15).neuronModel = 'adex';
NeuronParams(15).V_t = -52;
NeuronParams(15).delta_t = 2;
NeuronParams(15).a = 10;
NeuronParams(15).tau_w = 45;
NeuronParams(15).b = 345;
NeuronParams(15).v_reset = -60;
NeuronParams(15).v_cutoff = -47;
NeuronParams(15).numCompartments =9;
NeuronParams(15).compartmentParentArr = [0 1 2 2 4 5 1 7 7];
NeuronParams(15).compartmentLengthArr = [35 65 152 298 502 252 52 186 186];
NeuronParams(15).compartmentDiameterArr = ...
  [25 5.36 2.65 4.10 2.25 2.4 5.94 3.45 3.45];
NeuronParams(15).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  152;
    0,    0; 
    0,    0;
    0,    0;
    0,    0;
    0, -193;
    0,  193];
NeuronParams(15).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(15).compartmentZPositionMat = ...
[ -35,    0;
    0,   65;
   65,   65;
   65,  363;
  363,  865;
  865, 1117;
  -35,  -87;
  -87, -193;
  -87, -193];
NeuronParams(15).C = 1.0*2.95;
NeuronParams(15).R_M = 20000/2.95;
NeuronParams(15).R_A = 150;
NeuronParams(15).E_leak = -70;
NeuronParams(15).dendritesID = [2 3 4 5 6 7 8 9];
NeuronParams(15).somaID = 1;
NeuronParams(15).basalID = [7 8 9];
NeuronParams(15).proximalID = [2 7];
NeuronParams(15).distalID = [8 9];
NeuronParams(15).obliqueID = 3;
NeuronParams(15).apicalID = [4 5];
NeuronParams(15).trunkID = 2;
NeuronParams(15).tuftID = 6;

%Layer 5 Slender tufted pyramidal cell
NeuronParams(16)=NeuronParams(13);
NeuronParams(16).modelProportion = modpropL5STPC;
NeuronParams(16).modelProportion = modpropL5TTPC2;
NeuronParams(16).axisAligned = 'z';
NeuronParams(16).neuronModel = 'adex';
NeuronParams(16).V_t = -52;
NeuronParams(16).delta_t = 2;
NeuronParams(16).a = 10;
NeuronParams(16).tau_w = 45;
NeuronParams(16).b = 345;
NeuronParams(16).v_reset = -60;
NeuronParams(16).v_cutoff = -47;
NeuronParams(16).numCompartments = 10;
NeuronParams(16).compartmentParentArr = [0 1 2 2 4 5 5 1 7 7];
NeuronParams(16).compartmentLengthArr = [35 65 152 298 502 293 293 52 186 186];
NeuronParams(16).compartmentDiameterArr = ...
  [25 5.36 2.65 5.10 2.25 2.4 2.4 5.94 3.45 3.45];
NeuronParams(16).compartmentXPositionMat = ...
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
NeuronParams(16).compartmentYPositionMat = ...
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
NeuronParams(16).compartmentZPositionMat = ...
[ -35,    0;
    0,   65;
   65,   65;
   65,  363;
  363,  865;
  865, 1117;
  865, 1117;
  -35,  -87;
  -87, -193;
  -87, -193];
NeuronParams(16).C = 1.0*2.95;
NeuronParams(16).R_M = 20000/2.95;
NeuronParams(16).R_A = 150;
NeuronParams(16).E_leak = -70;
NeuronParams(16).dendritesID = [2 3 4 5 6 7 8 9 10];
NeuronParams(16).somaID = 1;
NeuronParams(16).basalID = [8 9 10];
NeuronParams(16).proximalID = [2 8];
NeuronParams(16).distalID = [9 10];
NeuronParams(16).obliqueID = 3;
NeuronParams(16).apicalID = [4 5];
NeuronParams(16).trunkID = 2;
NeuronParams(16).tuftID = [6 7];

%Layer 5 Nest Basket Cell
NeuronParams(17)=NeuronParams(2);
NeuronParams(17).somaLayer = 4;
NeuronParams(17).modelProportion = modpropL5NBC;


%Layer 5 Large Basket Cell
NeuronParams(18)=NeuronParams(2);
NeuronParams(18).somaLayer = 4;
NeuronParams(18).modelProportion = modpropL5LBC;

%Layer 5 Small Basket Cell
NeuronParams(19)=NeuronParams(4);
NeuronParams(19).somaLayer = 4;
NeuronParams(19).modelProportion = modpropL5SBC;


%Layer 5 Martinotti Cell
NeuronParams(20)=NeuronParams(5);
NeuronParams(20).somaLayer = 4;
NeuronParams(20).modelProportion = modpropL5MC;

modpropL6_TPC_L1 = double(neuronnumbers.L6_TPC_L1)/totalneurons;
modpropL6_TPC_L4 = double(neuronnumbers.L6_TPC_L4)/totalneurons;
modpropL6_UTPC = double(neuronnumbers.L6_UTPC)/totalneurons;
modpropL6_IPC = double(neuronnumbers.L6_IPC)/totalneurons;
modpropL6_BPC = double(neuronnumbers.L6_BPC)/totalneurons;

modpropL6NBC = double(neuronnumbers.L6_NBC)/totalneurons;
modpropL6LBC = double(neuronnumbers.L6_LBC)/totalneurons;
modpropL6SBC = double(neuronnumbers.L6_SBC)/totalneurons;
modpropL6MC = double(neuronnumbers.L6_MC)/totalneurons;
% 'L6_TPC_L1', 'L6_TPC_L4', 'L6_UTPC','L6_IPC','L6_BPC', 'L6_LBC', 'L6_NBC', 'L6_SBC', 'L6_MC'

%Layer 6 TPC_L1
NeuronParams(21) = NeuronParams(16);
NeuronParams(21).somaLayer = 5;
NeuronParams(21).modelProportion = modpropL6_TPC_L1;

%'L6_TPC_L4'
NeuronParams(22) = NeuronParams(16);
NeuronParams(22).somaLayer = 5;
NeuronParams(22).modelProportion = modpropL6_TPC_L4;

% L6_UTPC
NeuronParams(23) = NeuronParams(15);
NeuronParams(23).somaLayer = 5;
NeuronParams(23).modelProportion = modpropL6_UTPC;

%L6_IPC
NeuronParams(24) = NeuronParams(1);
NeuronParams(24).somaLayer = 5;
NeuronParams(24).modelProportion = modpropL6_IPC;
NeuronParams(24).neuronModel = 'adex';
NeuronParams(24).V_t = -50;
NeuronParams(24).delta_t = 2;
NeuronParams(24).a = 2.6;
NeuronParams(24).tau_w = 35;
NeuronParams(24).b = 220;
NeuronParams(24).v_reset = -60;
NeuronParams(24).v_cutoff = -45;
NeuronParams(24).numCompartments = 8;
NeuronParams(24).compartmentParentArr = [0, 1, 2, 2, 4, 1, 6, 6];
NeuronParams(24).compartmentLengthArr = [13 48 124 145 207 40 143 143];
NeuronParams(24).compartmentDiameterArr = ...
  [29.8, 3.75, 1.91, 2.81, 2.69, 2.62, 1.69, 1.69];
NeuronParams(24).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  124;
    0,    0;
    0,    0;
    0,    0;
    0, -139;
    0,  139];
NeuronParams(24).compartmentYPositionMat = ...
[   0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(24).compartmentZPositionMat = ...
[  13,    0;
    0,   -48;
   -48,   -48;
   -48,  -193;
  -193,  -330;
  13,  53;
  53, 139;
  53, 139];
NeuronParams(24).axisAligned = 'z';
NeuronParams(24).C = 1.0*2.96;
NeuronParams(24).R_M = 20000/2.96;
NeuronParams(24).R_A = 150;
NeuronParams(24).E_leak = -70;
NeuronParams(24).somaID = 1;
NeuronParams(24).basalID = [6 7 8];
NeuronParams(24).proximalID = [2 6];
NeuronParams(24).distalID = [7 8];
NeuronParams(24).obliqueID = 3;
NeuronParams(24).apicalID = 4;
NeuronParams(24).trunkID = 2;
NeuronParams(24).tuftID = 5;

%L6_BPC
NeuronParams(25) = NeuronParams(24);
NeuronParams(25).somaLayer = 5;
NeuronParams(25).modelProportion = modpropL6_BPC;
NeuronParams(25).neuronModel = 'adex';
NeuronParams(25).V_t = -50;
NeuronParams(25).delta_t = 2;
NeuronParams(25).a = 2.6;
NeuronParams(25).tau_w = 35;
NeuronParams(25).b = 220;
NeuronParams(25).v_reset = -60;
NeuronParams(25).v_cutoff = -45;
NeuronParams(25).numCompartments = 13;
NeuronParams(25).compartmentParentArr = [0, 1, 2, 2, 4, 1, 6, 6, 1, 9, 9, 11, 12];
NeuronParams(25).compartmentLengthArr = [13 48 124 145 207 40 143 143 65 152 298 502 252];
NeuronParams(25).compartmentDiameterArr = ...
  [29.8, 3.75, 1.91, 2.81, 2.69, 2.62, 1.69, 1.69,5.36, 2.65, 4.10, 2.25, 2.4];
NeuronParams(25).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  124;
    0,    0;
    0,    0;
    0,    0;
    0, -139;
    0,  139
    0,    0;
    0,    152;
    0,    0;
    0,    0;
    0,    0];
NeuronParams(25).compartmentYPositionMat = ...
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
    0,    0;
    0,    0;
    0,    0];
NeuronParams(25).compartmentZPositionMat = ...
[  13,    0;
    0,   -48;
   -48,   -48;
   -48,  -193;
  -193,  -330;
  13,  53;
  53, 139;
  53, 139
      0,   65;
   65,   65;
   65,  363;
  363,  865;
  865, 1117;];
NeuronParams(25).axisAligned = 'z';
NeuronParams(25).C = 1.0*2.96;
NeuronParams(25).R_M = 20000/2.96;
NeuronParams(25).R_A = 150;
NeuronParams(25).E_leak = -70;
NeuronParams(25).somaID = 1;
NeuronParams(25).basalID = [2 3 4 5];
NeuronParams(25).proximalID = [2 9];
NeuronParams(25).distalID = [7 8];
NeuronParams(25).obliqueID = [3 10];
NeuronParams(25).apicalID = [11 12];
NeuronParams(25).trunkID = 2;
NeuronParams(25).tuftID = 13;

%Layer 6 Nest Basket Cell
NeuronParams(26)=NeuronParams(2);
NeuronParams(26).somaLayer = 5;
NeuronParams(26).modelProportion = modpropL6NBC;


%Layer 6 Large Basket Cell
NeuronParams(27)=NeuronParams(2);
NeuronParams(27).somaLayer = 5;
NeuronParams(27).modelProportion = modpropL6LBC;

%Layer 6 Small Basket Cell
NeuronParams(28)=NeuronParams(4);
NeuronParams(28).somaLayer = 5;
NeuronParams(28).modelProportion = modpropL6SBC;

%Layer 6 Martinotti Cell
NeuronParams(29)=NeuronParams(5);
NeuronParams(29).somaLayer = 5;
NeuronParams(29).modelProportion = modpropL6MC;
