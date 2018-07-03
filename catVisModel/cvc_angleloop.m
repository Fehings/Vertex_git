%loop script 
% need to have no noise, ferret network, run for a set of intensities and
% rotation angles.

%% set up the ferret model
cvc_tissue;
cvc_neurons_nonoise;
cvc_connectivity_none;
cvc_recording;
cvc_simulation; % only running for 1000ms as there is no noise
cvc_field_stimulation; % change for different intensities. turning stim on after 200ms

RS.saveDir = '~/Documents/MATLAB/Vertex_Results/Vertex_cvc_results/cvc_nonoise_nostim';%AC30hz_long';
SS.parallelSim = false; 
%SS.poolSize = 2; %was 12 in the original
SS.profileName = 'local';


[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);
%% loop specific bits

formatspec = '~/Documents/MATLAB/Vertex_Results/Vertex_cvc_results/cvc_nonoise_intensity4mvmmanodal_angle%d';
angles = 0:pi/4:pi; % assuming radians, 0 to 180 degrees
params.SimulationSettings.RotateField.axis = 'x';

%% run the loop

for a = 1:length(angles)
    
    params.RecordingSettings.saveDir = sprintf(formatspec,angles(a));
    
    params.SimulationSettings.RotateField.angle = angles(a);
    angles(a)
    tic
    runSimulation(params, connections, electrodes);
    toc
    
end