pyramidalgroups = [1];
interneuron = [2 ];
N = Results.params.TissueParams.N;
neuronInGroup = createGroupsFromBoundaries(Results.params.TissueParams.groupBoundaryIDArr);
pyramidalids = ismember(neuronInGroup,pyramidalgroups);
endv_m = Results.v_m(:,end);
pyramidalv_ms = endv_m(pyramidalids);
pars.toPlot = pyramidalids;
plotSomaPositionsMembranePotential(Results.params.TissueParams,pars,pyramidalv_ms);

%eletrode position x = 742, z = 650