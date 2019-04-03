function [ fig ] = plotsomapositions( Results,spikeids,scaler )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here#
pk = [255 150 242];
gry = [150 150 150];
bpk = [255 1 238];
dgry = [5 5 5];
rasterParams.colors = {gry,pk,pk,pk,pk,...
    gry,gry,gry,pk,pk,pk,pk,...
    gry,gry,gry,gry,pk,pk,pk,pk,...
    gry,gry,gry,gry,gry,pk,pk,pk,pk};

params = Results.params;
NeuronParams = params.NeuronParams;
%%
ConnectivityNames = {'L23_PC','L23_NBC','L23_LBC','L23_SBC','L23_MC',...
    'L4_SS','L4_SP','L4_PC','L4_NBC','L4_SBC','L4_LBC','L4_MC',...
    'L5_TTPC2','L5_TTPC1','L5_UTPC','L5_STPC','L5_LBC','L5_SBC','L5_NBC','L5_MC'...
    'L6_TPC_L1', 'L6_TPC_L4', 'L6_UTPC','L6_IPC','L6_BPC', 'L6_LBC', 'L6_NBC', 'L6_SBC', 'L6_MC'};

pars.colors = rasterParams.colors;
for i = 1:length(pars.colors)
    pars.colors{i} = pars.colors{i}/255;
end
pars.markers = {'^','o','o','o','s', ...
    'p','^','^','o','o','o','s',...
    '^','^','^','^','o','o','o','s'...
    '^','^','^','v','d','o','o','o','s'};
pars.figureID =1;
pars.toPlot = 1:10:params.TissueParams.N;
pars.opacity = 0;
pars.dimensionscaler = 1;
params.TissueParams.scale =1 ;
[fig] = plotSomaPositions(params.TissueParams,pars);

 pars.figureID = fig;
 pars.toPlot = intersect(spikeids,1:1:params.TissueParams.N);
 disp(['toplot: ' num2str(length(pars.toPlot))]);
 spikecolors = {dgry,bpk,bpk,bpk,bpk,...
     dgry,dgry,dgry,bpk,bpk,bpk,bpk,...
     dgry,dgry,dgry,dgry,bpk,bpk,bpk,bpk,...
     dgry,dgry,dgry,dgry,dgry,bpk,bpk,bpk,bpk};
 for i = 1:length(pars.colors)
     pars.colors{i} = spikecolors{i}/255;
 end
 pars.opacity = 1;
plotSomaPositions(params.TissueParams,pars);
NeuornPositions = zeros(18,3);
%L23
NeuronPositions(1,:) = [300, 300, 1650];
NeuronPositions(2,:) = [2300, 300, 1850];
NeuronPositions(3,:) = [1500, 300, 1550];
%L4
NeuronPositions(4,:) = [1700, 300, 1350];
NeuronPositions(5,:) = [1200, 300, 1350];
NeuronPositions(6,:) = [2700, 300, 1350];
NeuronPositions(7,:) = [200, 300, 1350];
%L5
NeuronPositions(8,:) = [800, 300, 900];
NeuronPositions(9,:) = [2500, 300, 900];
NeuronPositions(10,:) = [1600, 300, 900];
NeuronPositions(11,:) = [2300, 300, 900];
NeuronPositions(12,:) = [1200, 300, 1000];
%L6
NeuronPositions(13,:) = [2000, 300, 200];
NeuronPositions(14,:) = [400, 300, 400];
NeuronPositions(15,:) = [1200, 300, 600];
NeuronPositions(16,:) = [2900, 300, 500];

NeuronPositions(17,:) = [1500, 300, 200];
NeuronPositions(18,:) = [100, 300, 400];

NM(1) = 1;
NM(2) = 4;
NM(3) = 5;
NM(4) = 6;
NM(5) = 7;
NM(6) = 9;
NM(7) = 12;
NM(8) = 13;
NM(9) = 15;
NM(10) = 16;
NM(11) = 18;
NM(12) = 20;
NM(13) = 21;
NM(14) = 23;
NM(15) = 24;
NM(16) = 25;
NM(17) = 26;
NM(18) = 29;
hold on;
% for i = 1:length(NM)
%     if i == 2 || i ==  3 || i == 4 || i== 6|| i == 7 || i == 11 || i == 12 || i == 17 || i == 18
%         xPos = NeuronParams(NM(i)).compartmentXPositionMat(:, :);
%         yPos = NeuronParams(NM(i)).compartmentYPositionMat(:, :);
%         zPos = NeuronParams(NM(i)).compartmentZPositionMat(:, :);
%         rot = [0 0 0]
% 
%         for iCompartment = 1:length(NeuronParams(NM(i)).compartmentXPositionMat)
%             xyzNewBottom = rotate3DCoordinates( [xPos(iCompartment, 1) ...
%                 yPos(iCompartment, 1) zPos(iCompartment, 1)], ...
%                 rot(1),  rot(2), rot(3));
%             xyzNewTop = rotate3DCoordinates( [xPos(iCompartment, 2) ...
%                 yPos(iCompartment, 2) zPos(iCompartment, 2)], ...
%                 rot(1), rot(2), rot(3));
%             xPos(iCompartment, :) = [xyzNewBottom(1) xyzNewTop(1)];
%             zPos(iCompartment, :) = [xyzNewBottom(3) xyzNewTop(3)];
%         end
%         NeuronParams(NM(i)).compartmentXPositionMat = xPos;
%         NeuronParams(NM(i)).compartmentZPositionMat = zPos;
%         if i == 4
%             viewMorphologyInSlice(NeuronParams(NM(i)),NeuronPositions(i,:),[0 0 0]);
%         else
%             viewMorphologyInSlice(NeuronParams(NM(i)),NeuronPositions(i,:),[255 15 242]./255);
%         end
%     else
%     
%         viewMorphologyInSlice(NeuronParams(NM(i)),NeuronPositions(i,:),[0 0 0]);
%     end
% end
%%
pl(1) = line([0 2000].*pars.dimensionscaler,[400 400].*pars.dimensionscaler, [2082 2082].*pars.dimensionscaler);

pl(2) = line([0 2000].*pars.dimensionscaler,[400 400].*pars.dimensionscaler, [1917 1917].*pars.dimensionscaler);
pl(3) = line([0 2000].*pars.dimensionscaler,[400 400].*pars.dimensionscaler, [1415 1415].*pars.dimensionscaler);
pl(4) = line([0 2000].*pars.dimensionscaler,[400 400].*pars.dimensionscaler, [1225 1225].*pars.dimensionscaler);
pl(5) = line([0 2000].*pars.dimensionscaler,[400 400].*pars.dimensionscaler, [700 700].*pars.dimensionscaler);
pl(6) = line([0 2000].*pars.dimensionscaler,[400 400].*pars.dimensionscaler, [0 0].*pars.dimensionscaler);

for i = 1:length(pl)
    pl(i).Color = 'black';
    pl(i).LineStyle = '--';
    pl(i).LineWidth = 3;
end
%hold off;
daspect([1 1 1])


end

