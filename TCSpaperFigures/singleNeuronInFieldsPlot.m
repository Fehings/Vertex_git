%% Generating the plots for figure 2, single neurons in fields

% Run single neurons with a zero stimulation field
singleNeuronNoStimL5P
runSingleNeuronandPlot
vm_nostimL5PY = v_m;

singleNeuronNoStimL23B
runSingleNeuronandPlot;
vm_nostimL23B = v_m;


%% Set simulation parameters for a Layer 5 Pyramidal neuron:
singleNeuronwitStimL5PY
% run simulation and plot results:
runSingleNeuronandPlot
gcf
hold on
plot(vm_nostimL5PY(1,:)) % plot soma membrane potential over time
figure
viewMorphologyColour(NP, abs(v_m(:,end))-abs(vm_nostimL5PY),0); % plot at a set time point

% repeat for the basket interneuron, Layer 2-3
singleNeuronwithStimL23B
runSingleNeuronandPlot
gcf
hold on
plot(vm_nostimL23B(1,:)) % plot soma membrane potential over time
figure
viewMorphologyColour(NP, abs(v_m(:,end))-abs(vm_nostimL23B),0); % plot at a set time point


%% Now rotate the neuron in the field to get a different orientation of stimulation:

singleNeuronwitStimL5PY
NP.RotateField.angle = 90;
NP.RotateField.axis = 'z';
runSingleNeuronandPlot
gcf
hold on
plot(vm_nostimL5PY(1,:)) % plot soma membrane potential over time
figure
viewMorphologyColour(NP, abs(v_m(:,end))-abs(vm_nostimL5PY),0); % plot at a set time point


singleNeuronwithStimL23B
NP.RotateField.angle = 90;
NP.RotateField.axis = 'z';
runSingleNeuronandPlot
gcf
hold on
plot(vm_nostimL23B(1,:)) % plot soma membrane potential over time
figure
viewMorphologyColour(NP, abs(v_m(:,end))-abs(vm_nostimL23B),0); % plot at a set time point


%% Rotate again by 180 to get cathodal stimulation.

singleNeuronwitStimL5PY
NP.RotateField.angle = 180;
NP.RotateField.axis = 'z';
runSingleNeuronandPlot
gcf
hold on
plot(vm_nostimL5PY(1,:)) % plot soma membrane potential over time
figure
viewMorphologyColour(NP, abs(v_m(:,end))-abs(vm_nostimL5PY),0); % plot at a set time point


singleNeuronwithStimL23B
NP.RotateField.angle = 180;
NP.RotateField.axis = 'z';
runSingleNeuronandPlot
gcf
hold on
plot(vm_nostimL23B(1,:)) % plot soma membrane potential over time
figure
viewMorphologyColour(NP, abs(v_m(:,end))-abs(vm_nostimL23B),0); % plot at a set time point


% for the change in soma membrane potential in the field please run
% StaticSomaStim

