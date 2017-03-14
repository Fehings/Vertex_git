%pyramidalgroups = [1 3 5];
%interneuron = [2 4 6];
N = Results.params.TissueParams.N;
%neuronInGroup = createGroupsFromBoundaries(Results.params.TissueParams.groupBoundaryIDArr);
%pyramidalids = ismember(neuronInGroup,pyramidalgroups);

%need to find the first spike and take the voltage up to that point..
% if isempty(Results.spikes)
%     firstspike = 300;
% else
%     firstspike = Results.spikes(1,2);
%     if firstspike>300
%         firstspike = 300;
%     end
% end
%timesteps = 0:SimulationSettings.timeStep:SimulationSettings.simulationTime;
%timestop=find(timesteps==firstspike);

ntoplot = Results.params.RecordingSettings.v_m;

pars.toPlot = ntoplot;
pars.figureID = 1;
pars.title = 'Change in soma membrane potential';
mxvm=max(max(Results.v_m));
mnvm=min(min(Results.v_m));
hold off
close all

step = 1; %initialise step


for i=size(Results.v_m,2):-100:1 %size(Results.v_m,2)
    
    
currentv_m = Results.v_m(:,i); % i is a time point that we are capturing v_m at.
    
%endv_m = Results.v_m(:,timestop-1);
%diffv_m = endv_m - Results.v_m(:,1);
%pyramidalv_ms = endv_m(pyramidalids);

F(step) = plotSomaPositionsMembranePotential(Results.params.TissueParams,pars,currentv_m);
h = colorbar('south');
set(h, 'ylim', [mnvm mxvm])
caxis('manual')
%view([1+i,50]) % needs tweaking

 step=step+1;
end
%movie(frame)
%eletrode position x = 742, z = 650