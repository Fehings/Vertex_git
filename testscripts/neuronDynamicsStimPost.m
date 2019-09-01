function [v_m,I,NeuronModel ] = neuronDynamicsStimPost( NParams,pars )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
model = lower(NParams.neuronModel);


inputModel = lower(NParams.Input.inputType);

if NParams.numCompartments == 1
  nFunString = ['PointNeuronModel_' model];
else
  nFunString = ['NeuronModel_' model];
end
iFunString = ['InputModel_' inputModel];

if isfield(NParams.Input, 'compartmentsInput')
  comparts = NParams.Input.compartmentsInput;
else
  comparts = 1:NParams.numCompartments;
end

if strcmp(nFunString(end), '_')
  nFunString = nFunString(1:end-1);
end
nConstructor = str2func(nFunString);
iConstructor = str2func(iFunString);


number = 1;
NeuronModel = {nConstructor(NParams, number)};
InputModel = {iConstructor(NParams, 1, number, pars.timeStep, comparts)};

setmidpoints(NeuronModel{1},NParams.midpoints);
v_ext = get_V_ext(NeuronModel{1}.midpoints, pars.TP.StimulationField,1);
setVext(NeuronModel{1}, v_ext(1,:));

stepsPerms = 1 / pars.timeStep;
if ~( stepsPerms == round(stepsPerms) )
  disp(['Incompatible timeStep supplied: ' num2str(pars.timeStep)]);
  pars.timeStep = 1 / (2^nextpow2(stepsPerms));
  disp(['Setting timeStep to ' num2str(pars.timeStep) ' ms']);
end
simulationSteps = round(pars.simulationTime / pars.timeStep);
v_m = zeros(number, NParams.numCompartments, round(simulationSteps));
I = zeros(number, NParams.numCompartments, round(simulationSteps));
index = 1;

stimOn = pars.TP.StimulationOn; %0.5
stimOff = pars.TP.StimulationOff;%130;

for simStep = 1:simulationSteps
    
  if NParams.numCompartments > 1
    updateI_ax(NeuronModel{1}, NParams);
  end
  
  updateInput(InputModel{1}, NeuronModel{1});
  if simStep*pars.timeStep > stimOn && simStep*pars.timeStep < stimOff  && ~NeuronModel{1}.incorporate_vext
       stimulationOn(NeuronModel{1});
  elseif simStep*pars.timeStep > stimOff  &&  NeuronModel{1}.incorporate_vext
     stimulationOff(NeuronModel{1});
  end
  updateNeurons(NeuronModel{1}, InputModel, NParams, [], pars.timeStep);
  
      v_m(:,:, simStep) = NeuronModel{1}.v;
      I(:,:, simStep) = InputModel{1}.I_input;
% spikes_rec(:,simStep) = NeuronModel{1}.spikes;
  if mod(simStep * pars.timeStep, 0.1) == 0
   disp(num2str(simStep * pars.timeStep));
  end
end
end

