%%
%Runs a simulation of rat somatosensory cortex constructed using neuron density
% andconnectivity data from the Neocortical collaborative portal
%(https://bbp.epfl.ch/nmc-portal/welcome), stored in the connections.mat
%file.
%With appropriate input parameters (random input current modelled by the
%Ornstein–Uhlenbeck process) the slice will produce oscillatory activity. 
%Neurons are modelled as apaptive exponential integrate and fire neurons,
%with a parameter set for regular spiking pyramidal cells and fast spiking
%interneurons.
%%
%Tissue parameters describe a slice 2000 x 400 x 1217 microns in size.

TissueParams.X = 2000;
TissueParams.Y = 400;
TissueParams.Z = 1217;
TissueParams.neuronDensity = 20000;
TissueParams.numStrips = 50;
TissueParams.tissueConductivity = 0.3;
TissueParams.maxZOverlap = [-1 , -1];
TissueParams.numLayers = 3;
TissueParams.layerBoundaryArr = [1217, 715, 525, 0];
%%
%Calculating neuron proportions. 

totalneurons = 18294;
% 18294 neurons in 3 layers in volume of 0.29mm^2 

%Number of all neurons from datasheet
L23_num_neurons = 7524;
L23_neuron_proportion = L23_num_neurons/totalneurons;


L23_PC = 2421;
L23_NBC = 160;
L23_SBC = 99;
L23_MC = 202;
L23_LBC = 277;

%number of all neurons of neuron types being used in simulation
L23_num_neurons_measured = L23_PC + L23_NBC +L23_SBC + L23_MC + L23_LBC;

%proportion  of total neurons in whole model of neurons of different types in l23 being used in simulation
modpropL23PC = (L23_PC / L23_num_neurons_measured)*L23_neuron_proportion;
modpropL23NBC = ((L23_NBC) / L23_num_neurons_measured)*L23_neuron_proportion;
modpropL23SBC = ((L23_SBC) / L23_num_neurons_measured)*L23_neuron_proportion;
modpropL23MC = ((L23_NBC) / L23_num_neurons_measured)*L23_neuron_proportion;
modpropL23LBC = ((L23_LBC) / L23_num_neurons_measured)*L23_neuron_proportion;

% 7524 neurons in layer 23  : 7524/18294 = 0.4113 
% Out of 
% 2421 pyramidal cells 277 LBC, 160 NBC, 99 SBC, 202 MC
% total : 3265
% proportion of PyC : 0.74 of layer 23 : 0.304 of total
% proportion of BC : 0.2585 of layer 23 : 0.1063 of total
% 


%%
%Setting Neuron parameters and shapes.

disp(['modelpropL23PC: ' num2str(modpropL23PC)]);

% Pyramidal cells in layer 23
NeuronParams(1).somaLayer = 1; 
NeuronParams(1).modelProportion = modpropL23PC;
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
NeuronParams(1).R_A = 600;
NeuronParams(1).E_leak = -70;
NeuronParams(1).somaID = 1;
NeuronParams(1).basalID = [6, 7, 8];
NeuronParams(1).apicalID = [2 3 4 5];


disp(['modelpropL23NBC: ' num2str(modpropL23NBC)]);

%Layer 23
%Nest Basket Cell

NeuronParams(2).somaLayer = 1; 
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
NeuronParams(2).R_A = 1000;
NeuronParams(2).E_leak = -70;
NeuronParams(2).dendritesID = [2 3 4 5 6 7];

%Layer 23 
%Small Basket Cell
disp(['modelpropL23SBC: ' num2str(modpropL23SBC)]);
NeuronParams(3) = NeuronParams(2);
NeuronParams(3).modelProportion = modpropL23SBC;

%Layer 23 
%Large Basket Cell
disp(['modelpropL23LBC: ' num2str(modpropL23LBC)]);
NeuronParams(4) = NeuronParams(2);
NeuronParams(4).modelProportion = modpropL23LBC;

%Layer 23
%Martinotti Cell
disp(['modelpropL23MC: ' num2str(modpropL23MC)]);
NeuronParams(5) = NeuronParams(3);
NeuronParams(5).modelProportion = modpropL23MC;
% 4656 neurons in layer 4 out of 18294 : 0.2545
% L4_SP 1098, L4_SS 406, L4_PC 2674, L4_NBC 96, L4_LBC 122, L4_MC 118
L4_num_neurons = 4656;
L4_neuron_proportion = L4_num_neurons/totalneurons;
L4_SP = 1098;
L4_SS = 406;
L4_PC = 2674;
L4_NBC = 96;
L4_LBC = 122;
L4_MC = 118;
L4_SBC = 60;

L4_num_neurons_measured = L4_SP + L4_PC + L4_NBC + L4_LBC + L4_MC + L4_SBC;


modpropL4PC = ((L4_PC) / L4_num_neurons_measured)*L4_neuron_proportion;
modpropL4NBC = ((L4_NBC)/ L4_num_neurons_measured)*L4_neuron_proportion;
modpropL4SS = (L4_SS/ L4_num_neurons_measured)*L4_neuron_proportion;
modpropL4SP = (L4_SP/ L4_num_neurons_measured)*L4_neuron_proportion;
modpropL4LBC = (L4_LBC/ L4_num_neurons_measured)*L4_neuron_proportion;
modpropL4MC = (L4_MC/ L4_num_neurons_measured)*L4_neuron_proportion;
modpropL4SBC = (L4_SBC/ L4_num_neurons_measured)*L4_neuron_proportion;



%modpropL4SS = (L4_SS / L4_num_neurons_measured)*L4_neuron_proportion;
% total: 4514 
% proportion of PyC: (2674 + 1098) / 4514 : 0.8356 per layer :  0.2127 tot
% proportion of SS: 404 / 4514 : 0.0895 per layer :  
% proportion of BC: 96 + 122 / 4514 : 0.0483 per layer : 
% proportion of MC: 118 / 4514 : 0.0261 per layer : 


%Layer4
%Spiny Stellate

disp(['modelpropL4SS: ' num2str(modpropL4SS)]);

NeuronParams(6) = NeuronParams(1);% spiny stellates same morphology as basket

NeuronParams(6).somaLayer = 2;     % but in layer 4
NeuronParams(6).modelProportion = modpropL4SS;
NeuronParams(6).v_cutoff = -10;

%Layer 4
%Star Pyramidal

disp(['modelpropL4SP: ' num2str(modpropL4SP)]);

NeuronParams(7) = NeuronParams(1);%use same morph as pyramidal cells
NeuronParams(7).somaLayer = 2;     % but in layer 4
NeuronParams(7).modelProportion = modpropL4SP;


%Layer 4
%Pyramical Cell

disp(['modelpropL4PC: ' num2str(modpropL4PC)]);

NeuronParams(8) = NeuronParams(1);
NeuronParams(8).somaLayer = 2;     % but in layer 4
NeuronParams(8).modelProportion = modpropL4PC;

%Layer 4 
%Small Basket Cell

disp(['modelpropL4SBC: ' num2str(modpropL4SBC)]);

NeuronParams(9) = NeuronParams(2);
NeuronParams(9).somaLayer = 2;     % but in layer 4
NeuronParams(9).modelProportion = modpropL4SBC;

%Layer 4
%Large Basket Cell

disp(['modelpropL4LBC: ' num2str(modpropL4LBC)]);
NeuronParams(10) = NeuronParams(2);
NeuronParams(10).somaLayer = 2;     % but in layer 4
NeuronParams(10).modelProportion = modpropL4LBC;

%Layer 4 
%Nest Basket Cell
disp(['modelpropL4NBC: ' num2str(modpropL4NBC)]);
NeuronParams(11) = NeuronParams(2);
NeuronParams(11).somaLayer = 2;     % but in layer 4
NeuronParams(11).modelProportion = modpropL4NBC;

%Layer 4
%Martinotti Cell
disp(['modelpropL4MC: ' num2str(modpropL4MC)]);
NeuronParams(12) = NeuronParams(2);
NeuronParams(12).somaLayer = 2;     % but in layer 4
NeuronParams(12).modelProportion = modpropL4MC;

%Layer 5
%Layer 5 neuron proportion calculations. 
L5_num_neurons =  6114;
L5_neuron_proportion = L5_num_neurons/totalneurons;
L5_TTPC1 = 2403;
L5_MC = 395;
L5_UTPC = 342;
L5_TTPC2 = 2003;
L5_STPC = 302;
L5_PC = L5_TTPC1 + L5_UTPC + L5_TTPC2 + L5_STPC;
L5_NBC = 201;
L5_LBC = 210;
L5_SBC = 25;

L5_num_neurons_measured = L5_PC + L5_NBC +L5_LBC + L5_MC+ L5_SBC;
modpropL5TTPC2 = (L5_TTPC2 / L5_num_neurons_measured)*L5_neuron_proportion;
modpropL5TTPC1 = (L5_TTPC1 / L5_num_neurons_measured)*L5_neuron_proportion;
modpropL5UTPC = (L5_UTPC / L5_num_neurons_measured)*L5_neuron_proportion;
modpropL5STPC = (L5_STPC / L5_num_neurons_measured)*L5_neuron_proportion;

modpropL5SBC = ((L5_SBC) / L5_num_neurons_measured)*L5_neuron_proportion;
modpropL5LBC = ((L5_LBC) / L5_num_neurons_measured)*L5_neuron_proportion;
modpropL5NBC = ((L5_NBC) / L5_num_neurons_measured)*L5_neuron_proportion;
modpropL5MC = ((L5_MC) / L5_num_neurons_measured)*L5_neuron_proportion;


%Layer 5
%Thick tufted pyramidal cell 2
disp(['modelpropL5TTPC2: ' num2str(modpropL5TTPC2)]);
NeuronParams(13) = NeuronParams(1);
NeuronParams(13).somaLayer = 3; % Pyramidal cells in layer 5
NeuronParams(13).modelProportion = modpropL5TTPC2;
NeuronParams(13).modelProportion = 0.1;
NeuronParams(13).axisAligned = 'z';
NeuronParams(13).neuronModel = 'adex';
NeuronParams(13).V_t = -52;
NeuronParams(13).delta_t = 2;
NeuronParams(13).a = 10;
NeuronParams(13).tau_w = 75;
NeuronParams(13).b = 345;
NeuronParams(13).v_reset = -60;
NeuronParams(13).v_cutoff = -47;
NeuronParams(13).numCompartments = 9;
NeuronParams(13).compartmentParentArr = [0 1 2 2 4 5 1 7 7];
NeuronParams(13).compartmentLengthArr = [35 65 152 398 402 252 52 186 186];
NeuronParams(13).compartmentDiameterArr = ...
  [25 4.36 2.65 4.10 2.25 2.4 5.94 3.45 3.45];
NeuronParams(13).compartmentXPositionMat = ...
[   0,    0;
    0,    0;
    0,  152;
    0,    0; 
    0,    0;
    0,    0;
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
    0,    0];
NeuronParams(13).compartmentZPositionMat = ...
[ -35,    0;
    0,   65;
   65,   65;
   65,  463;
  463,  865;
  865, 1117;
  -35,  -87;
  -87, -193;
  -87, -193];
NeuronParams(13).C = 1.0*2.95;
NeuronParams(13).R_M = 20000/2.95;
NeuronParams(13).R_A = 150;
NeuronParams(13).E_leak = -70;
NeuronParams(13).dendritesID = [2 3 4 5 6 7 8 9];


%Layer 5 Thick tufted pyramidal 1
disp(['modelpropL5TTPC1: ' num2str(modpropL5TTPC1)]);
NeuronParams(14) = NeuronParams(13);
NeuronParams(14).modelProportion = modpropL5TTPC1;

%Layer 5 Untufted pyramidal cell
disp(['modelpropL5UTPC: ' num2str(modpropL5UTPC)]);
NeuronParams(15)=NeuronParams(1);
NeuronParams(15).modelProportion = modpropL5UTPC;

%Layer 5 Slender tufted pyramidal cell
disp(['modelpropL5STPC: ' num2str(modpropL5STPC)]);
NeuronParams(16)=NeuronParams(1);
NeuronParams(16).modelProportion = modpropL5STPC;

%Layer 5 Small Basket Cell
disp(['modelpropL5SBC: ' num2str(modpropL5SBC)]);
NeuronParams(17)=NeuronParams(2);
NeuronParams(17).somaLayer = 3;
NeuronParams(17).modelProportion = modpropL5SBC;

%Layer 5 Large Basket Cell
disp(['modelpropL5LBC: ' num2str(modpropL5LBC)]);
NeuronParams(18)=NeuronParams(2);
NeuronParams(18).somaLayer = 3;
NeuronParams(18).modelProportion = modpropL5LBC;

%Layer 5 Nest Basket Cell
disp(['modelpropL5NBC: ' num2str(modpropL5NBC)]);
NeuronParams(19)=NeuronParams(2);
NeuronParams(19).somaLayer = 3;
NeuronParams(19).modelProportion = modpropL5NBC;

%Layer 5 Martinotti Cell
disp(['modelpropL5MC: ' num2str(modpropL5MC)]);
NeuronParams(20)=NeuronParams(2);
NeuronParams(20).somaLayer = 3;
NeuronParams(20).modelProportion = modpropL5MC;


%Setting the random input currents (Ornstein–Uhlenbeck process)
%For each group of neurons. 

%For layer 2/3 Excitatory cells
NeuronParams(1).Input(1).inputType = 'i_ou';
NeuronParams(1).Input(1).meanInput = 330;
NeuronParams(1).Input(1).stdInput = 80;
NeuronParams(1).Input(1).tau = 2;

%For layer 2/3 Inhibitory cells
for i = 2:5
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 200;
    NeuronParams(i).Input(1).stdInput = 20;
    NeuronParams(i).Input(1).tau = 1;
end

%For layer 4 Excitatory cells
for i = 6:8
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 230;
    NeuronParams(i).Input(1).stdInput = 30;
    NeuronParams(i).Input(1).tau = 2;
end
% %For layer 4 Inhibitory cells
for i = 9:12
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 200;
    NeuronParams(i).Input(1).stdInput = 20;
    NeuronParams(i).Input(1).tau = 1;
end
% %For layer 5 Excitatory cells
for i = 13:16
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 830;
    NeuronParams(i).Input(1).stdInput = 160;
    NeuronParams(i).Input(1).tau = 2;
end

% %For layer 5 Inhibitory cells
for i = 17:20
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 200;
    NeuronParams(i).Input(1).stdInput = 20;
    NeuronParams(i).Input(1).tau = 1;
end



volumemultiplier = ((TissueParams.X/1000)*(TissueParams.Y/1000)*(TissueParams.Z/1000))/0.29;
volumemultiplier = 1;

%%
%Connectivity parameters loaded from connections.mat and assinged with the 
%connectivity parameters. Weights and number of connections loaded from
%file.
connections = load('connections.mat');
ConnectivityNamesnounderscore = {'L23PC','L23NBC','L23LBC','L23SBC','L23MC','L4SS','L4SP','L4PC','L4NBC','L4SBC','L4LBC','L4MC','L5TTPC2','L5TTPC1','L5UTPC','L5STPC','L5LBC','L5SBC','L5NBC','L5MC'};

ConnectivityNames = {'L23_PC','L23_NBC','L23_LBC','L23_SBC','L23_MC','L4_SS','L4_SP','L4_PC','L4_NBC','L4_SBC','L4_LBC','L4_MC','L5_TTPC2','L5_TTPC1','L5_UTPC','L5_STPC','L5_LBC','L5_SBC','L5_NBC','L5_MC'};
connectivities = zeros(20);
for i = 1:20
    ConnectionParams(i).axonArborSpatialModel = 'gaussian';
    ConnectionParams(i).sliceSynapses = true;
    ConnectionParams(i).axonConductionSpeed = 0.3;
    ConnectionParams(i).synapseReleaseDelay = 0.5;
    for j = 1:20
        try
            disp(['Connecting..' num2str(i) ' - ' num2str(j)]);
            connectivities(i,j) = max(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){1});
            disp([[ConnectivityNames{i} '_' ConnectivityNames{j}] ': ' num2str(double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){1}))])
            ConnectionParams(i).numConnectionsToAllFromOne{j} = round(double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){1}) * volumemultiplier);
            ConnectionParams(i).synapseType{j} = 'g_exp';
            ConnectionParams(i).weights{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){3});
        catch %if there is no description in the file then set zero connections
            disp(['No connections between: ' ConnectivityNames{i} '_' ConnectivityNames{j}]); 
            ConnectionParams(i).numConnectionsToAllFromOne{j} = [0,0,0];
            ConnectionParams(i).synapseType{j} = 'g_exp';
            ConnectionParams(i).weights{j} = 0;
        end
        
    end
  
end


%%

%Setting remaining connectivity parameters


%Proporties of synapses from layer 23
%%Synapses Between Neuron groups
ConnectionParams(1).axonArborRadius = [300, 200, 100];
ConnectionParams(1).axonArborLimit = [600, 400, 200];

%for each post synaptic neuron group
for j = 1:20
    ConnectionParams(1).targetCompartments{j} = NeuronParams(j).dendritesID;
    ConnectionParams(1).tau{j} = 2;
    ConnectionParams(1).E_reversal{j} = 0;
end

%For each layer 23 interneuron group
for i = 2:5
    ConnectionParams(i).axonArborRadius = [150, 100, 100];
    ConnectionParams(i).axonArborLimit = [300, 100, 100];
end

%For each layer 23 basket cell
for i = 2:4
    for j = 1:20
        ConnectionParams(i).targetCompartments{j} = NeuronParams(j).somaID;
        ConnectionParams(i).tau{j} = 6;
        ConnectionParams(i).E_reversal{j} = -70;
    end
end

%For the martinotti cells - dendrite targetting INs
for j = 1:20
    ConnectionParams(5).targetCompartments{j} = NeuronParams(j).dendritesID;
    ConnectionParams(5).tau{j} = 2;
    ConnectionParams(5).E_reversal{j} = -70;
end


%Proporties for synapses from Layer 4

%For excitatory neurons
for i = 6:8
    ConnectionParams(i).axonArborRadius = [200, 300, 200];
    ConnectionParams(i).axonArborLimit = [400, 600, 400];
    for j = 1:20
        ConnectionParams(i).targetCompartments{j} = NeuronParams(j).dendritesID;
        ConnectionParams(i).tau{j} = 2;
        ConnectionParams(i).E_reversal{j} = 0;
    end
end

for i = 9:12
    ConnectionParams(i).axonArborRadius = [100, 150, 100];
    ConnectionParams(i).axonArborLimit = [150, 300, 150];
end
%For basket cells
for i = 9:11
    for j = 1:20
        ConnectionParams(i).targetCompartments{j} = NeuronParams(j).somaID;
        ConnectionParams(i).tau{j} = 6;
        ConnectionParams(i).E_reversal{j} = -70;
    end
end
%for Martinotti cells 
for j = 1:20
    ConnectionParams(12).targetCompartments{j} = NeuronParams(j).dendritesID;
    ConnectionParams(12).tau{j} = 6;
    ConnectionParams(12).E_reversal{j} = -70;
end


%Properties of synapses from Layer 5 neurons

%For excitatory neurons
for i = 13:16
    ConnectionParams(i).axonArborRadius = [100, 200, 300];
    ConnectionParams(i).axonArborLimit = [200, 400, 600];
    for j = 1:20
        ConnectionParams(i).targetCompartments{j} = NeuronParams(j).dendritesID;
        ConnectionParams(i).tau{j} = 2;
        ConnectionParams(i).E_reversal{j} = 0;
    end
end

%For inhibitory neurons
for i = 17:20
    ConnectionParams(i).axonArborRadius = [50, 50, 150];
    ConnectionParams(i).axonArborLimit = [100, 100, 300];
end

%For basket cells
for i = 17:19
    for j = 1:20
        ConnectionParams(i).targetCompartments{j} = NeuronParams(j).somaID;
        ConnectionParams(i).tau{j} = 6;
        ConnectionParams(i).E_reversal{j} = -70;
    end
end

%for martinotti cells
for j = 1:20
    ConnectionParams(20).targetCompartments{j} = NeuronParams(j).dendritesID;
    ConnectionParams(20).tau{j} = 6;
    ConnectionParams(20).E_reversal{j} = -70;
end

%%
%Recording settings
%These describe which variables to record, we are interested in membrane
%potentials and local field potentials. 
%We save the results of the simulation in this folder, they can be loaded
%at any time after the simulation has finished by loading into memory the
%Results file. Use Results = loadResults(RecordingSettings.saveDir); to do
%this.
RecordingSettings.saveDir = '~/VERTEX_somatosensory_slice_Oscillations/';
RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(1000, 300, 0:100:1200);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;
RecordingSettings.v_m = 1:100:19472;
RecordingSettings.maxRecTime = 1500;
RecordingSettings.sampleRate = 2000;
%RecordingSettings.I_syn = 1:2:5000;

%%
%Simulation settings:
%Keep max delay steps at 80, 
%Simulation time can be varied, it is in milliseconds, currently running
%for 500 ms.
%We want to run this simulation in parallel, this means that all cpu cores
%will be utilised in the simulations, with the neurons being distributed
%across them, as this simulation is large this is necessary to minimize the
%run time of the simulation. 
SimulationSettings.maxDelaySteps = 80;
SimulationSettings.simulationTime = 2000;
SimulationSettings.timeStep = 0.025;
SimulationSettings.parallelSim = true;

%These are flags used for simulating electric field or focussed ultrasound
%stimulation of the slice, these are currently in development and not used
%for this project. 
SimulationSettings.ef_stimulation = false;
SimulationSettings.fu_stimulation = false;

%This initialises the network and sets up other variables. 
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);


%%
runSimulation(params, connections, electrodes);

%%
%The results of the simulation can be loaded from file.
RecordingSettings.saveDir = '~/VERTEX_somatosensory_slice_Oscillations/';

Results = loadResults(RecordingSettings.saveDir);

%make sure no figures are open to keep things tidy
close all;
%%
%plot the slice anatomy
figure
rasterParams.colors = {'k','m','b','g','r','y','c','k','m','b','g','r','k','k','k','c','m','b','g','r'};

pars.colors = rasterParams.colors;
pars.markers = {'^','o','x','+','s','d','p','^','o','x','+','s','v','^','p','*','o','x','+','s'};
N = Results.params.TissueParams.N;
pars.toPlot = 1:5:N;
plotSomaPositions(Results.params.TissueParams,pars);

%%
%plot the slice simulation spike raster, each dot represents the time(on the x axis) at
%which the neuron of a particular id (on the y axis) fired. 
figure
rasterParams.groupBoundaryLines = 'c';
rasterParams.title = 'Spike Raster';
rasterParams.xlabel = 'Time (ms)';
rasterParams.ylabel = 'Neuron ID';
rasterParams.figureID = 2;
figure(2)
rasterFigureImproved = plotSpikeRaster(Results, rasterParams);


