%volumemultiplier = ((TissueParams.X/1000)*(TissueParams.Y/1000)*(TissueParams.Z/1000))/0.8;
volumemultiplier = 1;

%%
%Connectivity parameters loaded from connections.mat and assinged with the 
%connectivity parameters. Weights and number of connections loaded from
%file.
connections = load('connectionsSTP.mat');
ConnectivityNamesnounderscore = {'L23PC','L23NBC','L23LBC','L23SBC','L23MC','L4SS','L4SP','L4PC','L4NBC','L4SBC','L4LBC','L4MC','L5TTPC2','L5TTPC1','L5UTPC','L5STPC','L5LBC','L5SBC','L5NBC','L5MC'};

ConnectivityNames = {'L23_PC','L23_NBC','L23_LBC','L23_SBC','L23_MC','L4_SS','L4_SP','L4_PC','L4_NBC','L4_SBC','L4_LBC','L4_MC','L5_TTPC2','L5_TTPC1','L5_UTPC','L5_STPC','L5_LBC','L5_SBC','L5_NBC','L5_MC'};
connectivities = zeros(20);
for i = 1:length(ConnectivityNames)
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
            ConnectionParams(i).synapseType{j} = 'g_stdp';
            ConnectionParams(i).weights{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){3});
            ConnectionParams(i).tau{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){4})/10;
            ConnectionParams(i).rate{j} = 0.01;
            ConnectionParams(i).tPre{j} = 2;
            ConnectionParams(i).tPost{j} = 1+rand();
            ConnectionParams(i).wmin{j} = 0;
            ConnectionParams(i).wmax{j} = 100;
        catch %if there is no description in the file then set zero connections
            disp(['No connections between: ' ConnectivityNames{i} '_' ConnectivityNames{j}]); 
            ConnectionParams(i).numConnectionsToAllFromOne{j} = [0,0,0];
            ConnectionParams(i).synapseType{j} = 'g_exp';
            ConnectionParams(i).weights{j} = 0;
            ConnectionParams(i).tau{j} = 10 ;
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
