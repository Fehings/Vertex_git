volumemultiplier = 1;
connections = load('connectionslayers23to6.mat');
ConnectivityNamesnounderscore = {'L23PC','L23NBC','L23LBC','L23SBC','L23MC',...
    'L4SS','L4SP','L4PC','L4NBC','L4LBC','L4SBC','L4MC',...
    'L5TTPC2','L5TTPC1','L5UTPC','L5STPC','L5NBC','L5LBC','L5SBC','L5MC'...
    'L6TPCL1', 'L6TPCL4', 'L6UTPC','L6IPC','L6BPC', 'L6NBC','L6LBC', 'L6SBC', 'L6MC'};

ConnectivityNames = {'L23_PC','L23_NBC','L23_LBC','L23_SBC','L23_MC',...
    'L4_SS','L4_SP','L4_PC','L4_NBC','L4_LBC','L4_SBC','L4_MC',...
    'L5_TTPC2','L5_TTPC1','L5_UTPC','L5_STPC','L5_NBC','L5_LBC','L5_SBC','L5_MC'...
    'L6_TPC_L1', 'L6_TPC_L4', 'L6_UTPC','L6_IPC','L6_BPC','L6_NBC', 'L6_LBC', 'L6_SBC', 'L6_MC'};
connectivities = zeros(29);
for i = 1:length(ConnectivityNames)
    ConnectionParams(i).axonArborSpatialModel = 'gaussian';
    ConnectionParams(i).sliceSynapses = true;
    ConnectionParams(i).axonConductionSpeed = 0.5;
    ConnectionParams(i).synapseReleaseDelay = 0.1;
    for j = 1:length(ConnectivityNames)
        try
            connectivities(i,j) = max(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){1});
            ConnectionParams(i).numConnectionsToAllFromOne{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){1});
            ConnectionParams(i).weights_mu{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){3});
            ConnectionParams(i).weights_sigma{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){4});
            ConnectionParams(i).weights_distribution{j} = 'Normal';
            ConnectionParams(i).tau{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){5});
            %ConnectionParams(i).tau_sigma{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){6});
            %ConnectionParams(i).tau_distribution{j} = 'Normal';
            ConnectionParams(i).synapseType{j} = 'g_exp';            
        catch %if there is no description in the file then set zero connections
            ConnectionParams(i).numConnectionsToAllFromOne{j} = [0,0,0,0,0];
            ConnectionParams(i).synapseType{j} = 'g_exp';
            ConnectionParams(i).weights{j} = 0;
            ConnectionParams(i).tau{j} = 10 ;
        end
        
    end
  
end