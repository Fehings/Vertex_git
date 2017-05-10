%The results of the simulation can be loaded from file.
RecordingSettings.saveDir = '~/VERTEX_rat_somatosensory_slice/';

Results = loadResults(RecordingSettings.saveDir);

%make sure no figures are open to keep things tidy
close all;


%plot the slice anatomy
rasterParams.colors = {'k','m','b','g','r','y','c','k','m','b','g','r','k','k','k','c','m','b','g','r'};

pars.colors = rasterParams.colors;
pars.markers = {'^','o','x','+','s','d','p','^','o','x','+','s','v','^','p','*','o','x','+','s'};
N = Results.params.TissueParams.N;
pars.toPlot = 1:5:N;
plotSomaPositions(Results.params.TissueParams,pars);