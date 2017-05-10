%The results of the simulation can be loaded from file.
RecordingSettings.saveDir = '~/VERTEX_rat_somatosensory_slice/';

Results = loadResults(RecordingSettings.saveDir);

%make sure no figures are open to keep things tidy
close all;
rasterParams.colors = {'k','m','b','g','r','y','c','k','m','b','g','r','k','k','k','c','m','b','g','r','k','k','k','k','c','m','b','g','r'};
%%
%plot the slice simulation spike raster, each dot represents the time(on the x axis) at
%which the neuron of a particular id (on the y axis) fired. 
rasterParams.groupBoundaryLines = 'c';
rasterParams.title = 'Spike Raster';
rasterParams.xlabel = 'Time (ms)';
rasterParams.ylabel = 'Neuron ID';
rasterFigureImproved = plotSpikeRaster(Results, rasterParams);

%%
ConnectivityNames = {'L23_PC','L23_NBC','L23_LBC','L23_SBC','L23_MC',...
    'L4_SS','L4_SP','L4_PC','L4_NBC','L4_SBC','L4_LBC','L4_MC',...
    'L5_TTPC2','L5_TTPC1','L5_UTPC','L5_STPC','L5_LBC','L5_SBC','L5_NBC','L5_MC'...
    'L6_TPC_L1', 'L6_TPC_L4', 'L6_UTPC','L6_IPC','L6_BPC', 'L6_LBC', 'L6_NBC', 'L6_SBC', 'L6_MC'};
pars.colors = rasterParams.colors;
pars.markers = {'^','x','x','x','s', ...
    'd','*','^','x','x','x','m',...
    '^','^','^','*','x','x','x','s'...
    '^','^','^','v','p','x','x','x','s'};
N = Results.params.TissueParams.N;
pars.toPlot = 1:5:N;
plotSomaPositions(Results.params.TissueParams,pars);
