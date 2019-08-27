function [v_m, I, spikes_rec,v_m2, I2, spikes_rec2,NeuronModel] = neuronDynamics(NeuronParams, pars)
%NEURONDYNAMICS runs a simulation of a single neuron group.
%   V_M = neuronDynamics(NEURONPARAMS, PARS) creates a neuron group
%   according to the parameters in the structure NEURONPARAMS.
%   It then runs a simulation for the amount of time specified in the PARS
%   structure. This is useful for testing the dynamics of neuron models in
%   response to arbitrary input currents.
%
%   NEURONPARAMS is a structure containing the parameters defining a neuron
%   group (for details, see the VERTEX tutorials at www.vertexsimulator.org).
%   You should define NEURONPARAMS.Input to create an input current to the
%   neurons. The number of neurons created depends on the number of values
%   set for the input current parameters (Input.meanInput or
%   Input.amplitude - see documentation for the relevant input model).
%
%   PARS is a structure with two fields. PARS.timeStep specifies the
%   simulation timestep in ms, and PARS.simulationTime specifies the total
%   simulation time in ms.
%
%   V_M contains the membrane potentials for the neurons in the group;
%   the first dimension represents the neurons, the second their compartments
%   and the third the time (sampled every PARS.timeStep milliseconds). To
%   get all soma membrane potentials for the whole simulation, for example,
%   you would run: somaPotentials = squeeze(V_M(:, 1, :));
%
%   [V_M, I] = neuronDynamics(NEURONPARAMS, PARS) additionally returns the
%   input currents applied to the neurons, in the same format as the
%   membrane potentials (units of picoAmps).
%
%   [V_M, I, NPARAMS] = neuronDynamics(NEURONPARAMS, PARS) also returns the
%   neuron group parameter structure in NPARAMS. This contains the same
%   values as NEURONPARAMS, in addition to the calculated passive
%   properties of the neurons (axial conductances between compartments,
%   membrane conductances for each compartment etc.).

[NeuronModel{1}, InputModel{1}] = constructNeuronAndInputModel(NeuronParams(1),pars);
[NeuronModel{2}, InputModel{2}] = constructNeuronAndInputModel(NeuronParams(2),pars);

stepsPerms = 1 / pars.timeStep;
if ~( stepsPerms == round(stepsPerms) )
  disp(['Incompatible timeStep supplied: ' num2str(pars.timeStep)]);
  pars.timeStep = 1 / (2^nextpow2(stepsPerms));
  disp(['Setting timeStep to ' num2str(pars.timeStep) ' ms']);
end
simulationSteps = round(pars.simulationTime / pars.timeStep);
v_m = zeros(number, NParams.numCompartments, simulationSteps);
I = zeros(number, NParams.numCompartments, simulationSteps);
spikes_rec = zeros(number, simulationSteps);


%% Simulation loop
for simStep = 1:simulationSteps
   
  % Update the first cell
  if NParams.numCompartments > 1
    updateI_ax(NeuronModel{1}, NParams);
  end
  updateInput(InputModel{1}, NeuronModel{1});
  updateNeurons(NeuronModel{1}, InputModel, NParams, [], pars.timeStep);
  
  %Recording from the first cell
  v_m(:, :, simStep) = NeuronModel{1}.v;
  I(:, :, simStep) = InputModel{1}.I_input;
  spikes_rec(:,simStep) = NeuronModel{1}.spikes;
  
    % Update the second cell
  if NParams.numCompartments > 1
    updateI_ax(NeuronModel{2}, NParams);
  end
  updateInput(InputModel{2}, NeuronModel{2});
  updateNeurons(NeuronModel{2}, InputModel, NParams, [], pars.timeStep);
  
  %Recording from the second cell
  v_m2(:, :, simStep) = NeuronModel{2}.v;
  I2(:, :, simStep) = InputModel{2}.I_input;
  spikes_rec2(:,simStep) = NeuronModel{2}.spikes;

end