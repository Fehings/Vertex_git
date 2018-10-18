%% Load the neuron params and stimulation params from file

load('neuroandstimparams.mat')

%% Set simulation settings
SimulationParams.timeStep = 0.001;
SimulationParams.simulationTime = 10.5;
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
%%
v_m_ab2= v_m;
NPab2 = NP;
%
%%
viewMorphologyColour(NP, v_m(:,end),0);
% offset = 700;
% NPsctemp = NP_sc25;
% NPsctemp.compartmentXPositionMat = NPsctemp.compartmentXPositionMat+offset;
% viewMorphologyColour(NPsctemp, v_m_sc25(:,end),offset);
% offset = 1400;
% NPsctemp = NP_sc1;
% NPsctemp.compartmentXPositionMat = NPsctemp.compartmentXPositionMat+offset;
% viewMorphologyColour(NPsctemp, v_m_sc1(:,end),offset);
% offset = 2100;
% NPsctemp = NP_sc4;
% NPsctemp.compartmentXPositionMat = NPsctemp.compartmentXPositionMat+offset;
% viewMorphologyColour(NPsctemp, v_m_sc4(:,end),offset);
%%
% cmap = colormap(jet(1000));
% maplength = length(cmap);
% minv = -140;
% maxv =-20;
% norm_vm = (v_mint -minv)./(maxv-minv);
% scaled_vm = round(norm_vm * (length(cmap)-1))+1;
% viewMorphologyColourMov(NPint,scaled_vm(:,end),cmap,maxv,minv);
% norm_vm = (v_m -minv)./(maxv-minv);
% scaled_vm = round(norm_vm * (length(cmap)-1))+1;
% viewMorphologyColourMov(NP,scaled_vm(:,end),cmap,maxv,minv);