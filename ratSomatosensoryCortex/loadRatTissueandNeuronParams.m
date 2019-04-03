%%
%Runs a simulation of rat somatosensory cortex constructed using neuron density
% and connectivity data from the Neocortical collaborative portal
%(https://bbp.epfl.ch/nmc-portal/welcome), stored in the rat_no_neurons.mat, ratlayerthickness.mat, and connections23to6.mat
%file.
%With appropriate input parameters (random input current modelled by the
%Ornstein–Uhlenbeck process) the slice will produce oscillatory activity. 
%Neurons are modelled as apaptive exponential integrate and fire neurons,
%with a parameter set for regular spiking pyramidal cells and fast spiking
%interneurons.
%%
%Tissue parameters describe a slice 2000 x 400 x 2082 microns in size.
neuronnumbers = load('rat_no_neurons.mat');
lThick = load('ratlayerthickness.mat');

TissueParams.X = 2000;
TissueParams.Y = 400;
TissueParams.Z = 2082;
TissueParams.neuronDensity = 103730;
TissueParams.numStrips = 50;
TissueParams.tissueConductivity = 0.3;
TissueParams.maxZOverlap = [-1 , -1];
TissueParams.numLayers = 5;
TissueParams.layerBoundaryArr = double([lThick.L1 + lThick.L23 + lThick.L4 + lThick.L5 + lThick.L6...
    lThick.L23 + lThick.L4 + lThick.L5 + lThick.L6,...
    lThick.L4 + lThick.L5 + lThick.L6, lThick.L5 + lThick.L6,lThick.L6,0 ]);
TissueParams.neuron_names = {'L23_PC','L23_NBC','L23_LBC','L23_SBC','L23_MC',...
    'L4_SS','L4_SP','L4_PC','L4_NBC','L4_LBC','L4_SBC','L4_MC',...
    'L5_TTPC2','L5_TTPC1','L5_UTPC','L5_STPC','L5_NBC','L5_LBC','L5_SBC','L5_MC'...
    'L6_TPC_L1', 'L6_TPC_L4', 'L6_UTPC','L6_IPC','L6_BPC','L6_NBC', 'L6_LBC', 'L6_SBC', 'L6_MC'};


%%
%Calculating neuron proportions. 

buildNeuronProperties;

%Setting the random input currents (Ornstein–Uhlenbeck process)
%For each group of neurons. 

%For layer 2/3 Excitatory cells
NeuronParams(1).Input(1).inputType = 'i_ou';
NeuronParams(1).Input(1).meanInput =250;
NeuronParams(1).Input(1).stdInput = 60;
NeuronParams(1).Input(1).tau = 2;


%For layer 2/3 Inhibitory cells
for i = 2:3
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 200;
    NeuronParams(i).Input(1).stdInput = 60;
    NeuronParams(i).Input(1).tau = 0.8;
end
for i = 4:5
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 160;
    NeuronParams(i).Input(1).stdInput = 40;
    NeuronParams(i).Input(1).tau = 0.8;
end
%For layer 4 Excitatory cells

for i = 6
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput =180;
    NeuronParams(i).Input(1).stdInput = 60;
    NeuronParams(i).Input(1).tau = 2;
end

for i = 7
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput =250;
    NeuronParams(i).Input(1).stdInput = 60;
    NeuronParams(i).Input(1).tau = 2;
end

for i = 8
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput =320;
    NeuronParams(i).Input(1).stdInput = 90;
    NeuronParams(i).Input(1).tau = 2;
end

% %For layer 4 Inhibitory cells
for i = 9:10
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 210;
    NeuronParams(i).Input(1).stdInput = 60;
    NeuronParams(i).Input(1).tau = 1;
end
for i = 11
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 170;
    NeuronParams(i).Input(1).stdInput = 50;
    NeuronParams(i).Input(1).tau = 1;
end
for i = 12
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 160;
    NeuronParams(i).Input(1).stdInput = 50;
    NeuronParams(i).Input(1).tau = 1;
end
% %For layer 5 Excitatory cells
for i = 13:14
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 700;
    NeuronParams(i).Input(1).stdInput = 280;
    NeuronParams(i).Input(1).tau = 2;
end
for i = 15
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 520;
    NeuronParams(i).Input(1).stdInput =260;
    NeuronParams(i).Input(1).tau = 2;
end
for i = 16
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 620;
    NeuronParams(i).Input(1).stdInput =280;
    NeuronParams(i).Input(1).tau = 2;
end

% %For layer 5 Inhibitory cells
for i = 17:18
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 190;
    NeuronParams(i).Input(1).stdInput = 60;
    NeuronParams(i).Input(1).tau = 1;
end
for i = 19:20
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 160;
    NeuronParams(i).Input(1).stdInput = 40;
    NeuronParams(i).Input(1).tau = 0.8;
end
% %For layer 6 Excitatory cells
for i = 21:22
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 720;
    NeuronParams(i).Input(1).stdInput = 300;
    NeuronParams(i).Input(1).tau = 2;
end
for i = 23
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 530;
    NeuronParams(i).Input(1).stdInput = 250;
    NeuronParams(i).Input(1).tau = 2;
end
for i = 24
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 250;
    NeuronParams(i).Input(1).stdInput = 60;
    NeuronParams(i).Input(1).tau = 2;
end
for i = 25
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 530;
    NeuronParams(i).Input(1).stdInput = 250;
    NeuronParams(i).Input(1).tau = 2;
end

% %For layer 6 Inhibitory cells
for i = 26:27
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 200;
    NeuronParams(i).Input(1).stdInput = 60;
    NeuronParams(i).Input(1).tau = 1;
end
for i = 28:29
    NeuronParams(i).Input(1).inputType = 'i_ou';
    NeuronParams(i).Input(1).meanInput = 160;
    NeuronParams(i).Input(1).stdInput = 40;
    NeuronParams(i).Input(1).tau = 1;
end

% for i = 1:29
%     NeuronParams(i).Input(1).compartments = setdiff(1:NeuronParams(i).numCompartments, NeuronParams(i).axon_ID);
% end
% 
% for i = [6:8 13:16 25]
%     NeuronParams(i).Input(1).meanInput = NeuronParams(i).Input(1).meanInput+NeuronParams(i).Input(1).meanInput.*0.1;
%     NeuronParams(i).Input(1).stdInput = NeuronParams(i).Input(1).stdInput+NeuronParams(i).Input(1).stdInput.*0.1;
% end
%%


