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
excitatory = [1 6 7 8 13 14 15 16 21 22 23 24 25];
inhibitory = setdiff(1:29, excitatory);
superficialPY = [1 7 8];
deepPY = [13 14 15 16 21 22 23 24 25];
excitatory = [1 7 8 13 14 15 16 21 22 23 24 25];

for i = 1:length(ConnectivityNames)
    ConnectionParams(i).axonArborSpatialModel = 'gaussian';
    ConnectionParams(i).sliceSynapses = true;
    ConnectionParams(i).axonConductionSpeed = 0.5;
    ConnectionParams(i).synapseReleaseDelay = 0.1;
    for j = 1:length(ConnectivityNames)
        try
            connectivities(i,j) = max(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){1});
            ConnectionParams(i).numConnectionsToAllFromOne{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){1});
            ConnectionParams(i).weights{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){3});
            ConnectionParams(i).weights_sigma{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){4});
            ConnectionParams(i).weights_distribution{j} = 'Normal';
            ConnectionParams(i).tau{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){5});
            ConnectionParams(i).tau_s{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){5});

            %ConnectionParams(i).tau_sigma{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){6});
            %ConnectionParams(i).tau_distribution{j} = 'Normal';
            if ismember(i, excitatory)
                ConnectionParams(i).synapseType{j} = 'g_exp_mt_stdp';
                ConnectionParams(i).preRate{j} = 0.05;
                ConnectionParams(i).postRate{j} = -0.05;
                ConnectionParams(i).wmin{j} = 0;
                ConnectionParams(i).wmax{j} = 100;
                if ismember(i, superficialPY)
                    ConnectionParams(i).tPre{j} = 25;
                    ConnectionParams(i).tPost{j} = 75;
                elseif ismember(i, deepPY)
                    ConnectionParams(i).tPre{j} = 25;
                    ConnectionParams(i).tPost{j} = 25;
                end
            else
                ConnectionParams(i).synapseType{j} = 'g_exp_mt';
            end
            ConnectionParams(i).fac_tau_mu{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){7});
            ConnectionParams(i).fac_tau_sigma{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){8});
            ConnectionParams(i).fac_tau_distribution{j} = 'Normal';
            
            ConnectionParams(i).rec_tau_mu{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){9});
            ConnectionParams(i).rec_tau_sigma{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){10});
            ConnectionParams(i).rec_tau_distribution{j} = 'Normal';
            
            ConnectionParams(i).U_mu{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){11});
            ConnectionParams(i).U_sigma{j} = double(connections.([ConnectivityNames{i} '_' ConnectivityNames{j}]){12});
            ConnectionParams(i).U_distribution{j} = 'Normal';
        catch %if there is no description in the file then set zero connections
            ConnectionParams(i).numConnectionsToAllFromOne{j} = [0,0,0,0,0];
            ConnectionParams(i).synapseType{j} = 'g_exp';
            ConnectionParams(i).weights{j} = 0;
            ConnectionParams(i).tau{j} = 10 ;
        end
        
    end
  
end