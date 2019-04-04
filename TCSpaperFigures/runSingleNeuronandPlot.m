% run single neuron and plot
%load('neuroandstimparams.mat')

 v_ext = get_V_ext(NP.midpoints, TissueParams.StimulationField,1);
% hold on
%  viewMorphologyColour(NP,v_ext(end,:),0);
  %
 % figure
   % viewMorphologyColour(NP,v_ext(end,:),0);

 %%
%   v_ext = SP.v_ext{1};
%  save('v_ext.mat','v_ext_nml');

% Need to run until the model stabilises.
SimulationParams.timeStep = 0.001;
SimulationParams.simulationTime = 40.5;
SimulationParams.TP = TissueParams;
[v_m, I_input,NM] = neuronDynamicsStimPost(NP, SimulationParams);
%%
v_m = squeeze(v_m);
I_input = squeeze(I_input);
for iComp = 1:length(v_m(:,1))
    [a,ind] = max(abs(v_m(iComp,:)-(-70)));
      vm_diff(iComp) = v_m(iComp,ind);
end
vdiff = max(abs(-70-(v_m')));

vmax = max(abs(-70-(v_m')));

figure
viewMorphologyColour(NP, v_m(:,end)+70,3.0421); % plot at a set time point

figure
plot(v_m(1,:)) % plot soma membrane potential over time


