rasterParams.colors = {'k','m','b','g','r','y','c','k','m','b','g','r','k','k','k','c','m','b','g','r'};
pyramidalgroups = [1 7 8 13 14 15 16];
interneuron = [2 3 4 5 6 9 10 11 12 17 18 19 20];
pars.colors = rasterParams.colors;
pars.markers = {'^','o','x','+','s','d','p','^','o','x','+','s','v','^','p','*','o','x','+','s'};
N = Results.params.TissueParams.N;
neuronInGroup = createGroupsFromBoundaries(Results.params.TissueParams.groupBoundaryIDArr);
pyramidalids = ismember(neuronInGroup,pyramidalgroups);
endv_m = Results.v_m(:,160);
pyramidalv_ms = endv_m(pyramidalids);
pars.toPlot = pyramidalids;
plotSomaPositionsMembranePotential(Results.params.TissueParams,pars,pyramidalv_ms);

%eletrode position x = 742, z = 650