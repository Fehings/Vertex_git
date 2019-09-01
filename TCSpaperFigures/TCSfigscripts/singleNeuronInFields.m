%% Generating the plots for figure 2, single neurons in fields

% Run single neurons with a zero stimulation field
setupNeuronandStimL5PY
runSingleNeuronandPlot
vm_stimL5PY = v_m;

%% now change the stimulation and rerun:
 brainslice3Dzerostim%
 TissueParams.StimulationField = result;
 TissueParams.model = model;
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 600;
%TissueParams.StimulationField = 'pointstim';
 NeuronParams.TissueParams = TissueParams;
 %refind NP
 [NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
%run with no stim:
runSingleNeuronandPlot
vm_nostimL5PY = v_m;

figure
plot(vm_stimL5PY(1,:)-vm_nostimL5PY(1,:)) % plot soma membrane potential over time
figure
viewMorphologyColour(NP, abs(vm_stimL5PY(:,end-1))-abs(vm_nostimL5PY(:,end-1)),0); % plot at a set time point


%% Now repeat with rotated neurons
brainslice3Dorig%
 TissueParams.StimulationField = result;
 TissueParams.model = model;
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 600;
%TissueParams.StimulationField = 'pointstim';
 NeuronParams.TissueParams = TissueParams;
[NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
 %rotate the neurons
NP.RotateField.angle = 90;
NP.RotateField.axis = 'x';

%run with no stim:
runSingleNeuronandPlot
vm_90rotate_stimL5PY = v_m;


figure
plot(vm_90rotate_stimL5PY(1,:)-vm_nostimL5PY(1,:)) % plot soma membrane potential over time
figure
viewMorphologyColour(NP, abs(vm_stimL5PY(:,end))-abs(vm_nostimL5PY),0); % plot at a set time point


%% Now repeat with rotated neurons
brainslice3Dorig%
 TissueParams.StimulationField = result;
 TissueParams.model = model;
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 600;
%TissueParams.StimulationField = 'pointstim';
 NeuronParams.TissueParams = TissueParams;

 %rotate the neurons
[NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
NP.RotateField.angle = 180;
NP.RotateField.axis = 'z';
%run with no stim:
runSingleNeuronandPlot
vm_180rotate_stimL5PY = v_m;



figure
plot(vm_180rotate_stimL5PY(1,:)-vm_nostimL5PY(1,:)) % plot soma membrane potential over time
figure
viewMorphologyColour(NP, abs(vm_stimL5PY(:,end))-abs(vm_nostimL5PY),0); % plot at a set time point




%% repeat for L23 Basket interneuron:

clear NP TissueParams NeuronParams

setupNeuronandStimL23B
runSingleNeuronandPlot;
vm_stimL23B = v_m;

%now change the stimulation and rerun:
 brainslice3Dzerostim%
 TissueParams.StimulationField = result;
 TissueParams.model = model;
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 600;
%TissueParams.StimulationField = 'pointstim';
 NeuronParams.TissueParams = TissueParams;
 %refind NP
 [NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
%run with no stim:
runSingleNeuronandPlot
vm_nostimL23B = v_m;


plot(vm_stimL23B(1,:)-vm_nostimL23B(1,:)) % plot soma membrane potential over time
title('Anodalfield')
figure
viewMorphologyColour(NP, abs(vm_stimL23B(:,end))-abs(vm_nostimL23B),0); % plot at a set time point
title('Anodal field')

% Now repeat with rotated neurons

NP.RotateField.angle = 90;
NP.RotateField.axis = 'z';

%% Now repeat with rotated neurons
brainslice3Dorig%
 TissueParams.StimulationField = result;
 TissueParams.model = model;
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 600;
%TissueParams.StimulationField = 'pointstim';
 NeuronParams.TissueParams = TissueParams;

 %rotate the neurons
NP.RotateField.angle = 90;
NP.RotateField.axis = 'z';

[NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
%run with no stim:
runSingleNeuronandPlot
vm_90rotate_stimL5PY = v_m;


figure
plot(vm_90rotate_stimL23B(1,:)-vm_nostimL23B(1,:)) % plot soma membrane potential over time
title('90 rotated field')
figure
viewMorphologyColour(NP, abs(vm_90rotate_stimL23B(:,end))-abs(vm_nostimL23B),0); % plot at a set time point
title('90 rotated field')

%% Now repeat with rotated neurons
brainslice3Dorig%
 TissueParams.StimulationField = result;
 TissueParams.model = model;
TissueParams.StimulationOn = 0;
TissueParams.StimulationOff = 600;
%TissueParams.StimulationField = 'pointstim';
 NeuronParams.TissueParams = TissueParams;

 %rotate the neurons
NP.RotateField.angle = 180;
NP.RotateField.axis = 'z';

[NP] = neuronDynamicsStimPre(NeuronParams,TissueParams);
%run with no stim:
runSingleNeuronandPlot
vm_180rotate_stimL23B = v_m;



figure
plot(vm_180rotate_stimL23B(1,:)-vm_nostimL23B(1,:)) % plot soma membrane potential over time
title('180 rotated field')

figure
viewMorphologyColour(NP, abs(vm_180rotate_stimL23B(:,end))-abs(vm_nostimL23B),0); % plot at a set time point
title('180 rotated field')


