%Proporties of synapses from layer 23
%%Synapses Between Neuron groups
ConnectionParams(1).axonArborRadius = [200,300, 200, 200,200];
ConnectionParams(1).axonArborLimit = [400,600, 400, 300,300];

%for each post synaptic neuron group
for j = 1:29
    %ConnectionParams(1).tau{j} = 2;
    ConnectionParams(1).E_reversal{j} = 0;
end
ConnectionParams(1).targetCompartments{1} = {'obliqueID', 'basalID','apicalID'};
ConnectionParams(1).targetCompartments{2} = {'distalID'};
ConnectionParams(1).targetCompartments{3} = {'distalID'};
ConnectionParams(1).targetCompartments{4} = {'distalID'};
ConnectionParams(1).targetCompartments{5} = {'distalID'};
ConnectionParams(1).targetCompartments{6} = {'distalID'};
ConnectionParams(1).targetCompartments{7} = {'obliqueID', 'basalID','apicalID'};
ConnectionParams(1).targetCompartments{8} = {'obliqueID', 'basalID','apicalID'};
ConnectionParams(1).targetCompartments{9} = {'distalID'};
ConnectionParams(1).targetCompartments{10} = {'distalID'};
ConnectionParams(1).targetCompartments{11} = {'distalID'};
ConnectionParams(1).targetCompartments{12} = {'distalID'};
ConnectionParams(1).targetCompartments{13} = {'obliqueID','apicalID','trunkID'};
ConnectionParams(1).targetCompartments{14} = {'obliqueID','apicalID','trunkID'};
ConnectionParams(1).targetCompartments{15} = {'obliqueID','apicalID','tuftID'};
ConnectionParams(1).targetCompartments{16} = {'obliqueID','apicalID','tuftID'};
ConnectionParams(1).targetCompartments{17} = {'distalID'};
ConnectionParams(1).targetCompartments{18} = {'distalID'};
ConnectionParams(1).targetCompartments{19} = {'distalID'};
ConnectionParams(1).targetCompartments{20} = {'distalID'};
ConnectionParams(1).targetCompartments{21} = {'obliqueID','apicalID','tuftID'};
ConnectionParams(1).targetCompartments{22} = {'obliqueID','apicalID','tuftID'};
ConnectionParams(1).targetCompartments{23} = {'obliqueID','apicalID','tuftID'};
ConnectionParams(1).targetCompartments{24} = {'obliqueID','apicalID','basalID','proximalID'};
ConnectionParams(1).targetCompartments{25} = {'obliqueID','apicalID','trunkID','tuftID'};
ConnectionParams(1).targetCompartments{26} = {'distalID'};
ConnectionParams(1).targetCompartments{27} = {'distalID'};
ConnectionParams(1).targetCompartments{28} = {'distalID'};
ConnectionParams(1).targetCompartments{29} = {'distalID'};

%For each layer 23 interneuron group
for i = 2:5
    ConnectionParams(i).axonArborRadius = [50,150, 100, 100,100];
    ConnectionParams(i).axonArborLimit = [100,300, 200, 200,200];
end

%For each layer 23 basket cell
for i = 2:4
        ConnectionParams(i).targetCompartments{1} = {'somaID', 'proximalID'};
        ConnectionParams(i).targetCompartments{2} = {'distalID'};
        ConnectionParams(i).targetCompartments{3} = {'distalID'};
        ConnectionParams(i).targetCompartments{4} = {'distalID'};
        ConnectionParams(i).targetCompartments{5} = {'distalID'};
        ConnectionParams(i).targetCompartments{6} = {'distalID'};
        ConnectionParams(i).targetCompartments{7} = {'somaID', 'proximalID'};
        ConnectionParams(i).targetCompartments{8} = {'somaID', 'proximalID'};
        ConnectionParams(i).targetCompartments{9} = {'distalID'};
        ConnectionParams(i).targetCompartments{10} = {'distalID'};
        ConnectionParams(i).targetCompartments{11} = {'distalID'};
        ConnectionParams(i).targetCompartments{12} = {'distalID'};
        ConnectionParams(i).targetCompartments{13} = {'somaID', 'proximalID','obliqueID','apicalID','trunkID'};
        ConnectionParams(i).targetCompartments{14} = {'somaID', 'proximalID','obliqueID','apicalID','trunkID'};
        ConnectionParams(i).targetCompartments{15} = {'somaID', 'proximalID','obliqueID','apicalID','tuftID'};
        ConnectionParams(i).targetCompartments{16} = {'somaID', 'proximalID','obliqueID','apicalID','tuftID'};
        ConnectionParams(i).targetCompartments{17} = {'distalID'};
        ConnectionParams(i).targetCompartments{18} = {'distalID'};
        ConnectionParams(i).targetCompartments{19} = {'distalID'};
        ConnectionParams(i).targetCompartments{20} = {'distalID'};
        ConnectionParams(i).targetCompartments{21} = {'somaID', 'proximalID','obliqueID','apicalID','tuftID'};
        ConnectionParams(i).targetCompartments{22} = {'somaID', 'proximalID','obliqueID','apicalID','tuftID'};
        ConnectionParams(i).targetCompartments{23} = {'somaID', 'proximalID','obliqueID','apicalID','tuftID'};
        ConnectionParams(i).targetCompartments{24} = {'somaID','obliqueID','apicalID','basalID','proximalID'};
        ConnectionParams(i).targetCompartments{25} = {'somaID', 'proximalID','obliqueID','apicalID','trunkID','tuftID'};
        ConnectionParams(i).targetCompartments{26} = {'distalID'};
        ConnectionParams(i).targetCompartments{27} = {'distalID'};
        ConnectionParams(i).targetCompartments{28} = {'distalID'};
        ConnectionParams(i).targetCompartments{29} = {'distalID'};
    for j = 1:29
        %ConnectionParams(i).tau{j} = 6;
        ConnectionParams(i).E_reversal{j} = -70;
    end
end

%For the martinotti cells - dendrite targetting INs
for j = 1:29
    %ConnectionParams(5).tau{j} = 2;
    ConnectionParams(5).E_reversal{j} = -70;
end
ConnectionParams(5).targetCompartments{1} = {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{2} = {'distalID'};
ConnectionParams(5).targetCompartments{3} = {'distalID'};
ConnectionParams(5).targetCompartments{4} = {'distalID'};
ConnectionParams(5).targetCompartments{5} = {'distalID'};
ConnectionParams(5).targetCompartments{6} = {'distalID'};
ConnectionParams(5).targetCompartments{7} = {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{8} = {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{9} = {'distalID'};
ConnectionParams(5).targetCompartments{10} = {'distalID'};
ConnectionParams(5).targetCompartments{11} = {'distalID'};
ConnectionParams(5).targetCompartments{12} = {'distalID'};
ConnectionParams(5).targetCompartments{13} = {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{14} = {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{15} =  {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{16} =  {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{17} = {'distalID'};
ConnectionParams(5).targetCompartments{18} = {'distalID'};
ConnectionParams(5).targetCompartments{19} = {'distalID'};
ConnectionParams(5).targetCompartments{20} = {'distalID'};
ConnectionParams(5).targetCompartments{21} =  {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{22} =  {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{23} =  {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{24} =  {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{25} =  {'obliqueID', 'tuftID', 'apicalID', 'distalID'};
ConnectionParams(5).targetCompartments{26} = {'distalID'};
ConnectionParams(5).targetCompartments{27} = {'distalID'};
ConnectionParams(5).targetCompartments{28} = {'distalID'};
ConnectionParams(5).targetCompartments{29} = {'distalID'};

%Proporties for synapses from Layer 4

ConnectionParams(6).targetCompartments{1} = {'basalID'};
ConnectionParams(6).targetCompartments{2} = {'distalID'};
ConnectionParams(6).targetCompartments{3} = {'distalID'};
ConnectionParams(6).targetCompartments{4} = {'distalID'};
ConnectionParams(6).targetCompartments{5} = {'distalID'};
ConnectionParams(6).targetCompartments{6} = {'distalID'};
ConnectionParams(6).targetCompartments{7} =  {'basalID'};
ConnectionParams(6).targetCompartments{8} =  {'basalID'};
ConnectionParams(6).targetCompartments{9} = {'distalID'};
ConnectionParams(6).targetCompartments{10} = {'distalID'};
ConnectionParams(6).targetCompartments{11} = {'distalID'};
ConnectionParams(6).targetCompartments{12} = {'distalID'};
ConnectionParams(6).targetCompartments{13} = {'obliqueID', 'trunkID', 'apicalID'};
ConnectionParams(6).targetCompartments{14} = {'obliqueID', 'trunkID', 'apicalID'};
ConnectionParams(6).targetCompartments{15} =  {'obliqueID', 'trunkID', 'apicalID'};
ConnectionParams(6).targetCompartments{16} =  {'obliqueID', 'trunkID', 'apicalID'};
ConnectionParams(6).targetCompartments{17} = {'distalID'};
ConnectionParams(6).targetCompartments{18} = {'distalID'};
ConnectionParams(6).targetCompartments{19} = {'distalID'};
ConnectionParams(6).targetCompartments{20} = {'distalID'};
ConnectionParams(6).targetCompartments{21} =   { 'trunkID', 'apicalID'};
ConnectionParams(6).targetCompartments{22} =   {'trunkID', 'apicalID'};
ConnectionParams(6).targetCompartments{23} =   { 'trunkID', 'apicalID'};
ConnectionParams(6).targetCompartments{24} =   {'trunkID', 'apicalID'};
ConnectionParams(6).targetCompartments{25} =   {'trunkID', 'apicalID'};
ConnectionParams(6).targetCompartments{26} = {'distalID'};
ConnectionParams(6).targetCompartments{27} = {'distalID'};
ConnectionParams(6).targetCompartments{28} = {'distalID'};
ConnectionParams(6).targetCompartments{29} = {'distalID'};
ConnectionParams(6).axonArborRadius = [50,250, 450, 250, 250];
ConnectionParams(6).axonArborLimit = [100,400, 600, 400, 400];

for j = 1:29
    %ConnectionParams(6).tau{j} = 2;
    ConnectionParams(6).E_reversal{j} = 0;
end

%For excitatory neurons
for i = 7:8
    ConnectionParams(i).axonArborRadius = [50,250, 450, 250, 250];
    ConnectionParams(i).axonArborLimit = [100,400, 600, 400, 400];
    ConnectionParams(i).targetCompartments = ConnectionParams(1).targetCompartments;
    for j = 1:29
        
        %ConnectionParams(i).tau{j} = 2;
        ConnectionParams(i).E_reversal{j} = 0;
    end
end

for i = 9:12
    ConnectionParams(i).axonArborRadius = [50,100, 150, 100,100];
    ConnectionParams(i).axonArborLimit = [100,150, 300, 150,150];
end
%For basket cells
for i = 9:11
    ConnectionParams(i).targetCompartments = ConnectionParams(2).targetCompartments;
    for j = 1:29
        %ConnectionParams(i).tau{j} = 6;
        ConnectionParams(i).E_reversal{j} = -70;
    end
end
%for Martinotti cells
ConnectionParams(12).targetCompartments = ConnectionParams(5).targetCompartments;
for j = 1:29
    %ConnectionParams(12).tau{j} = 6;
    ConnectionParams(12).E_reversal{j} = -70;
end


%Properties of synapses from Layer 5 neurons

%For excitatory neurons
for i = 13:16
    ConnectionParams(i).axonArborRadius = [50,200, 300, 300,400];
    ConnectionParams(i).axonArborLimit = [100,300, 400, 600,500];
    
    ConnectionParams(i).targetCompartments{1} = {'basalID', 'proximalID', 'obliqueID'};
    ConnectionParams(i).targetCompartments{2} = {'distalID'};
    ConnectionParams(i).targetCompartments{3} = {'distalID'};
    ConnectionParams(i).targetCompartments{4} = {'distalID'};
    ConnectionParams(i).targetCompartments{5} = {'distalID'};
    ConnectionParams(i).targetCompartments{6} = {'distalID'};
    ConnectionParams(i).targetCompartments{7} = {'basalID', 'proximalID', 'obliqueID'};
    ConnectionParams(i).targetCompartments{8} = {'basalID', 'proximalID', 'obliqueID'};
    ConnectionParams(i).targetCompartments{9} = {'distalID'};
    ConnectionParams(i).targetCompartments{10} = {'distalID'};
    ConnectionParams(i).targetCompartments{11} = {'distalID'};
    ConnectionParams(i).targetCompartments{12} = {'distalID'};
    ConnectionParams(i).targetCompartments{13} = {'basalID','obliqueID','trunkID'};
    ConnectionParams(i).targetCompartments{14} = {'basalID','obliqueID','trunkID'};
    ConnectionParams(i).targetCompartments{15} = {'basalID','obliqueID','trunkID'};
    ConnectionParams(i).targetCompartments{16} = {'basalID','obliqueID','trunkID'};
    ConnectionParams(i).targetCompartments{17} = {'distalID'};
    ConnectionParams(i).targetCompartments{18} = {'distalID'};
    ConnectionParams(i).targetCompartments{19} = {'distalID'};
    ConnectionParams(i).targetCompartments{20} = {'distalID'};
    ConnectionParams(i).targetCompartments{21} = {'basalID','obliqueID','apicalID','trunkID'};
    ConnectionParams(i).targetCompartments{22} = {'basalID','obliqueID','apicalID','trunkID'};
    ConnectionParams(i).targetCompartments{23} = {'basalID','obliqueID','apicalID','trunkID'};
    ConnectionParams(i).targetCompartments{24} = {'basalID','obliqueID','apicalID','trunkID','proximalID'};
    ConnectionParams(i).targetCompartments{25} = {'basalID','obliqueID','apicalID','trunkID'};
    ConnectionParams(i).targetCompartments{26} = {'distalID'};
    ConnectionParams(i).targetCompartments{27} = {'distalID'};
    ConnectionParams(i).targetCompartments{28} = {'distalID'};
    ConnectionParams(i).targetCompartments{29} = {'distalID'};
    for j = 1:29
        %ConnectionParams(i).tau{j} = 2;
        ConnectionParams(i).E_reversal{j} = 0;
    end
end

%For inhibitory neurons
for i = 17:20
    ConnectionParams(i).axonArborRadius = [50,50,50, 150, 150];
    ConnectionParams(i).axonArborLimit = [100,100, 100, 300,300];
end

%For basket cells
for i = 17:19
    ConnectionParams(i).targetCompartments = ConnectionParams(2).targetCompartments;
    ConnectionParams(i).targetCompartments{13} = {'somaID', 'proximalID','trunkID'};
    ConnectionParams(i).targetCompartments{14} = {'somaID', 'proximalID','trunkID'};
    ConnectionParams(i).targetCompartments{15} = {'somaID', 'proximalID'};
    ConnectionParams(i).targetCompartments{16} = {'somaID', 'proximalID'};
    ConnectionParams(i).targetCompartments{21} = {'somaID', 'proximalID'};
    ConnectionParams(i).targetCompartments{22} = {'somaID', 'proximalID'};
    ConnectionParams(i).targetCompartments{23} = {'somaID', 'proximalID'};
    ConnectionParams(i).targetCompartments{24} = {'somaID','proximalID'};
    ConnectionParams(i).targetCompartments{25} = {'somaID', 'proximalID'};
    
    for j = 1:29
       
        %ConnectionParams(i).tau{j} = 6;
        ConnectionParams(i).E_reversal{j} = -70;
    end
end

%for martinotti cells
ConnectionParams(20).targetCompartments = ConnectionParams(5).targetCompartments;

    ConnectionParams(20).targetCompartments{13} = {'basalID','obliqueID','trunkID'};
    ConnectionParams(20).targetCompartments{14} = {'basalID','obliqueID','trunkID'};
    ConnectionParams(20).targetCompartments{15} = {'basalID','obliqueID','trunkID'};
    ConnectionParams(20).targetCompartments{16} = {'basalID','obliqueID','trunkID'};
    ConnectionParams(20).targetCompartments{21} =  {'obliqueID', 'apicalID', 'distalID'};
ConnectionParams(20).targetCompartments{22} =  {'obliqueID', 'apicalID', 'distalID'};
ConnectionParams(20).targetCompartments{23} =  {'obliqueID', 'apicalID', 'distalID'};
ConnectionParams(20).targetCompartments{24} =  {'obliqueID', 'apicalID', 'distalID'};
ConnectionParams(20).targetCompartments{25} =  {'obliqueID', 'apicalID', 'distalID'};
for j = 1:29
    %ConnectionParams(20).tau{j} = 6;
    ConnectionParams(20).E_reversal{j} = -70;
end

%For excitatory neurons

for i = 21:25
    ConnectionParams(i).targetCompartments{1} = {'apicalID'};
    ConnectionParams(i).targetCompartments{2} = {'distalID'};
    ConnectionParams(i).targetCompartments{3} = {'distalID'};
    ConnectionParams(i).targetCompartments{4} = {'distalID'};
    ConnectionParams(i).targetCompartments{5} = {'distalID'};
    ConnectionParams(i).targetCompartments{6} = {'distalID'};
    ConnectionParams(i).targetCompartments{7} = {'apicalID'};
    ConnectionParams(i).targetCompartments{8} = {'apicalID'};
    ConnectionParams(i).targetCompartments{9} = {'distalID'};
    ConnectionParams(i).targetCompartments{10} = {'distalID'};
    ConnectionParams(i).targetCompartments{11} = {'distalID'};
    ConnectionParams(i).targetCompartments{12} = {'distalID'};
    ConnectionParams(i).targetCompartments{13} = {'basalID','obliqueID','apicalID','trunkID'};
    ConnectionParams(i).targetCompartments{14} = {'basalID','obliqueID','apicalID','trunkID'};
    ConnectionParams(i).targetCompartments{15} = {'basalID','obliqueID','apicalID','trunkID'};
    ConnectionParams(i).targetCompartments{16} = {'basalID','obliqueID','apicalID','trunkID'};
    ConnectionParams(i).targetCompartments{17} = {'distalID'};
    ConnectionParams(i).targetCompartments{18} = {'distalID'};
    ConnectionParams(i).targetCompartments{19} = {'distalID'};
    ConnectionParams(i).targetCompartments{20} = {'distalID'};
    ConnectionParams(i).targetCompartments{21} = {'basalID','obliqueID','apicalID','trunkID','tuftID'};
    ConnectionParams(i).targetCompartments{22} = {'basalID','obliqueID','apicalID','trunkID','tuftID'};
    ConnectionParams(i).targetCompartments{23} = {'basalID','obliqueID','apicalID','trunkID','tuftID'};
    ConnectionParams(i).targetCompartments{24} = {'basalID','obliqueID','apicalID','trunkID','proximalID'};
    ConnectionParams(i).targetCompartments{25} = {'basalID','obliqueID','apicalID','trunkID','tuftID'};
    ConnectionParams(i).targetCompartments{26} = {'distalID'};
    ConnectionParams(i).targetCompartments{27} = {'distalID'};
    ConnectionParams(i).targetCompartments{28} = {'distalID'};
    ConnectionParams(i).targetCompartments{29} = {'distalID'};
    ConnectionParams(i).axonArborRadius = [50, 100, 200, 300, 400];
    ConnectionParams(i).axonArborLimit = [100,200, 300,300, 600];
    for j = 1:29
        %ConnectionParams(i).tau{j} = 2;
        ConnectionParams(i).E_reversal{j} = 0;
    end
end

for i = 26:29
    ConnectionParams(i).axonArborRadius = [50,100, 100, 100,150];
    ConnectionParams(i).axonArborLimit = [100,150, 150,200, 300];
end

for i = 26:28
    ConnectionParams(i).targetCompartments = ConnectionParams(19).targetCompartments;
    for j = 1:29
        %ConnectionParams(i).tau{j} = 6;
        ConnectionParams(i).E_reversal{j} = -70;
        
    end
end
ConnectionParams(29).targetCompartments = ConnectionParams(20).targetCompartments;
for j = 1:29
    %ConnectionParams(29).tau{j} = 6;
    ConnectionParams(29).E_reversal{j} = -70;
end