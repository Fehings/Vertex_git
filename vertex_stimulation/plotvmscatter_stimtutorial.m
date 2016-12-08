pyramidalgroups = [1 3 5];
interneuron = [2 4 ];
N = Results.params.TissueParams.N;
neuronInGroup = createGroupsFromBoundaries(Results.params.TissueParams.groupBoundaryIDArr);
pyramidalids = ismember(neuronInGroup,pyramidalgroups);
endv_m = Results.vm(:,end) % mean(Results.v_m,2);
pyramidalv_ms = endv_m(pyramidalids);
pars.toPlot = pyramidalids;
plotSomaPositionsMembranePotential(Results.params.TissueParams,pars,pyramidalv_ms);

%eletrode position x = 742, z = 650