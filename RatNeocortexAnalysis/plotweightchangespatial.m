load MayColourMap.mat
w2 = getSparseConnectivityWeights(Results.weights_arr{1}, Results.syn_arr, Results.params.TissueParams.N);
w3 = getSparseConnectivityWeights(Results.weights_arr{4}, Results.syn_arr, Results.params.TissueParams.N);

wd = w3-w2;
wchange = sum(wd);
%wchange = sum(wd(1:31948,:));
%%
% model = createpde;
% importGeometry(model,'6layermodelstiml4placedinsmalljustelectrode.stl');
% pdegplot(model)
%%
N = Results.params.TissueParams.N;
pars.figureID = 1;
pars.markers = {'^','x','x','x','s', ...
    'd','*','^','x','x','x','m',...
    '^','^','^','*','x','x','x','s'...
    '^','^','^','v','p','x','x','x','s'};
pars.toPlot = 1:1:N;

plotSomaPositionsMembranePotential(Results.params.TissueParams,pars, wchange);
c=colorbar();
colormap(mycmap);
ylabel(c,'Total Synapse Weight Change (nS)')
set(gca,'visible','off');
%%
pl(1) = line([0 2000],[400 400], [2082 2082]);

pl(2) = line([0 2000],[400 400], [1917 1917]);
pl(3) = line([0 2000],[400 400], [1415 1415]);
pl(4) = line([0 2000],[400 400], [1225 1225]);
pl(5) = line([0 2000],[400 400], [700 700]);
pl(6) = line([0 2000],[400 400], [0 0]);

for i = 1:length(pl)
    pl(i).Color = 'black';
    pl(i).LineStyle = '--';
    pl(i).LineWidth = 2;
end
hold on;
scatter3(775,400,1225,100, 'filled', 'r');
hold off;
view(180,0)
