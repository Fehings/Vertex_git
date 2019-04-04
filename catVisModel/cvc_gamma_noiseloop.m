% Gamma oscillation run for the cvc slice




cvc_tissue;
cvc_neurons_gamma;
cvc_connectivity_gamma_update;
cvc_recording;

SS.timeStep =   0.03125;%
SS.simulationTime = 1000; 
SS.spikeLoad = false;
SS.parallelSim = true;


load('zerostimfield_cvc.mat');
%brainslice3Dorig;
TP.StimulationField = result;
TP.StimulationOn = 0;
TP.StimulationOff = SS.simulationTime;

RS.saveDir = '~/Documents/MATLAB/Vertex_Results/PaperResults_GammaChapter/cvc_gamma_zerofield';%AC30hz_long';


%% Initialise the network
[params, connections, electrodes] = initNetwork(TP, NP, CP, RS, SS);


%% simulation loop

formatspec = '/Users/a6028564/Documents/MATLAB/Vertex_Results/PaperResults_GammaChapter/cvc_gamma_1sec_nostim_serial_noiseseed%d';

noises = 11:15;

for rseed = 1:length(noises)

    SS.randomSeed = noises(rseed); % manually setting the noise seed, the default is 127.
    setRandomSeed(SS);
    
    params.RecordingSettings.saveDir = sprintf(formatspec,noises(rseed));
    
   % run the simulation and time:
    tic
    runSimulation(params, connections, electrodes);
    toc
end





% 
% %% Plotting
% % 
% rasterParams.colors =
% {'k','c','g','y','m','r','b','c','k','m','b','g','r','k','c'};
% pars.colors = rasterParams.colors;
% pars.opacity=0.6;
% pars.markers = {'^','p','h','*','x','^','p','h','d','v','p','h','d','v','p'};
% N = Results.params.TissueParams.N;
% pars.toPlot = 1:3:N;
% plotSomaPositions(Results.params.TissueParams,pars);


%%
% If you have experienced any problems when trying to run this code, please
% email Richard Tomsett: r _at_ autap _dot_ se

%% Reference
% Tomsett RJ, Ainsworth M, Thiele A, Sanayei M, Chen X et al. (2014)
% Virtual Electrode Recording Tool for EXtracellular potentials (VERTEX):
% comparing multi-electrode recordings from simulated and biological
% mammalian cortical tissue, Brain Structure and Function.
% doi:10.1007/s00429-014-0793-x