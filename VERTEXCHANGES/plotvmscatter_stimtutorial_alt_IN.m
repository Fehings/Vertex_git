pyramidalgroups = [1 3 5];
interneuron = [2 4 6];
N = Results.params.TissueParams.N;
neuronInGroup = createGroupsFromBoundaries(Results.params.TissueParams.groupBoundaryIDArr);
interneuronids = ismember(neuronInGroup,interneuron);

%need to find the first spike and take the voltage up to that point..
if isempty(Results.spikes) % if no spikes, count up to timestop (here giving this a value of 300, could make this size(Results.v_m,2) to be the full timespan
    timestop = 300;
else
    firstspike = Results.spikes(1,2);
    timesteps = 0:SimulationSettings.timeStep:SimulationSettings.simulationTime;
    timestop=find(timesteps==firstspike) % check the iteration number corresponding to the first spike time, as the spike time is likely a floating point number of ms, but we need an integer.
    if timestop>300 % if the found number is larger than the established stopping time (here 300) then just ignore it and make it equal 300..
        timestop = 300;
    end
end


endv_m = Results.v_m(:,timestop-1);
diffv_m = endv_m - Results.v_m(:,1);
pyramidalv_ms = diffv_m(interneuronids);
pars.toPlot = interneuronids;
pars.figureID = 3;
pars.title = 'Change in membrane potential for interneurons';
plotSomaPositionsMembranePotential(Results.params.TissueParams,pars,pyramidalv_ms);
colorbar
%eletrode position x = 742, z = 650