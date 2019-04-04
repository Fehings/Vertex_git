
%%
%Connectivity parameters loaded from connections.mat and assinged with the 
%connectivity parameters. Weights and number of connections loaded from
%file.
loadConnectionsNoSynapse;%STP;

%%

%Setting remaining connectivity parameters


setSynapticPropertiesRat;

%%
% Make modifications
excitatory = [1 6 7 8 13 14 15 16 21 22 23 24 25];
inhibitory = [2 3 4 5 9 10 11 12 17 18 19 20 26 27 28 29];
