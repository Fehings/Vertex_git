% cvc noise  loop.
% want to run all of the setup functions and then run the simulation for  a
% set of noise seeds, saving to a different file name each time.

%addpath(genpath('/home/a6028564/vertex/VERTEX_CoreFiles'));

cvc_tissue;
cvc_neurons;
cvc_connectivity;
cvc_recording;
cvc_simulation;
%cvc_field_stimulation;

SS.parallelSim = false; %true; 
SS.poolSize = 2; %was 12 in the original
SS.profileName = 'local';

RS.saveDir = '~/cvc_slow_20sec_test'
%% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);
% NB: this initialisation will use the default noise seed to establish the
% neuron positions and connectivity profile. This is dependent on 'rand',
% so this loop will only randomise the noise generated in the simulation,
% assuming I am not being daft and we actually predefine noise here for the
% simulation. Pretty sure we don't though >_>

%% simulation loop

formatspec = '/Users/a6028564/Documents/MATLAB/Vertex_git/testResults/cvc_slow_20sec_test_nostim_serial_noiseseed%d';

noises = 1:2;

for rseed = 1:length(noises)

    SS.randomSeed = noises(rseed); % manually setting the noise seed, the default is 127.
    setRandomSeed(SS);
    
    params.RecordingSettings.saveDir = sprintf(formatspec,noises(rseed));
    
    
   % run the simulation and time:
    tic
    runSimulation(params, connections, electrodes);
    toc
end
