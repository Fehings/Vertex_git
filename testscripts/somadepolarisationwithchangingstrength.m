% Single neuron soma depolarisation in electric fields of changing strengths

% run the L5PY neuron setup script

setupNeuronandStimL23B
% this has a step current at 60 time steps, but we are only going to run it
% for 50 so it doesn't impact the simulation.

strengths = -30:30; % different efield strengths

% loop for different electric field strengths
for i = 1:60

    r = strengths(i);
    
    % update the pde model
    applyBoundaryCondition(model,'face',[2],'h',1.0,'r',r)%1); %the 'r' 5.0 sets up a voltage here%
    applyBoundaryCondition(model,'face',[1],'h',1.0,'r',0)%0.992);%0.9991); %the 'r' -5.0 sets up a -5V  voltage at this electrode. 
    generateMesh(model);
    result = solvepde(model);
    TissueParams.StimulationField = result;
    TissueParams.model = model;
     NeuronParams.TissueParams = TissueParams;

% run the single neuron simulation

 v_ext = get_V_ext(NP.midpoints, TissueParams.StimulationField,1);
% Need to run until the model stabilises.
SimulationParams.timeStep = 0.001;
SimulationParams.simulationTime = 40;
SimulationParams.TP = TissueParams;
[v_m, I_input,NM] = neuronDynamicsStimPost(NP, SimulationParams);
v_m = squeeze(v_m);

soma_vm(i) = v_m(1,end-1); % take the v_m at the end of the stimulation - after it has stabilised - for the soma.

end

%%

figure
%plot(strengths(1:end-1),soma_vm_PY)
%hold on
plot(strengths(1:end-1),soma_vm)
title('Soma membrane potential with changing field strength')
xlabel('Field strength mV')
ylabel('Soma membrane potential')
%legend('Layer 5 Pyramidal','Layer 2-3 Basket')


figure
%plot(strengths(1:end-1),soma_vm_PY+70)
%hold on
plot(strengths(1:end-1),soma_vm+70)
title('Soma membrane potential with changing field strength')
xlabel('Field strength mV')
ylabel('Soma membrane potential')
%legend('Layer 5 Pyramidal','Layer 2-3 Basket')





