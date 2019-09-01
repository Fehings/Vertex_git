%The results of the simulation can be loaded from file.
RecordingSettings.saveDir = '/home/campus.ncl.ac.uk/b3046588/VERTEX_rat_somatosensory_slice_0MG_PP300ms/';
RecordingSettings.saveDir = '~/VERTEX_TOPSY/VERTEX_rat_somatosensory_slice_50msPP/';
%RecordingSettings.saveDir = '~/VERTEXResults/27Jun/VERTEX_rat_somatosensory_slice_0MG_PPms/';
RecordingSettings.saveDir = '/data/Results/SinglePulseAugust/SinglePulseincreasedconnectivity/VERTEX_rat_somatosensory_sliceSinglePulse500mV';
%RecordingSettings.saveDir = '~/VERTEX_rat_somatosensory_sliceSTDPLTP/';
%RecordingSettings.saveDir = '/data/Results/STDP/HBPdataTBS/VERTEX_rat_somatosensory_sliceSTDPLTP';
%RecordingSettings.saveDir = '~/VERTEX_rat_somatosensory_sliceSinglePulse500mV';
%RecordingSettings.saveDir = '/data/Results/STDP/HBPdataTBS/VERTEX_rat_somatosensory_sliceSTDPLTP';
RecordingSettings.saveDir = '~/VERTEX_rat_somatosensory_sliceSTDPLTP/';
%RecordingSettings.saveDir = '~/VERTEXResults/August/VERTEX_rat_somatosensory_slice_100msPP';
%RecordingSettings.saveDir = '/home/chris/VERTEX_TOPSY/VERTEX_rat_somatosensory_slice_0MGLSPhigherconn';
%RecordingSettings.saveDir = '/data/HPC_Julia/finalresult/VERTEX_rat_somatosensory_slice12sfw';
RecordingSettings.saveDir = '/data/Spontaneous/VERTEX_rat_somatosensory_slice_0MGLSP';
%RecordingSettings.saveDir = '~/VERTEXResults/VERTEX_rat_somatosensory_slice12s';
%RecordingSettings.saveDir = '/data/Results/STDP/HBPdataTBS/VERTEX_rat_somatosensory_sliceSTDPLTP';
%RecordingSettings.saveDir = '//data/IEDsFullNetworkWithCurrentRec/VERTEX_rat_somatosensory_slice_0MGLSPhigherconn';
%RecordingSettings.saveDir = '/data/pps/VERTEX_rat_somatosensory_slice_100msPP';
RecordingSettings.saveDir = '/data/IEDswithsynapseVars/VERTEX_rat_somatosensory_slice_0MGLSPhigherconn';
RecordingSettings.saveDir = '/home/campus.ncl.ac.uk/b3046588/Rocket_Results/SinglePulse/CSD/singlepulse_1001_nosyn';
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/CSD/singlepulse_1001_wsyn';
%RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_STDPResults/tbs_weights1001';
%RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/no_synapses/singlepulsenosyn1003';
%RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/paired_pulse/recfromstimulated/withcsd/withweights/pairedpulse1001';
%RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/pairedpulse1001';
RecordingSettings.saveDir = '~/zero_magnesium//';
RecordingSettings.saveDir = '~/with_axons//';
RecordingSettings.saveDir = '/media/b3046588/Elements/ampRangeScaled/amprange/amp_6_1001';
Results = loadResults(RecordingSettings.saveDir,0);

%make sure no figures are open to keep things tidy
%close all;
rasterParams.colors = {'k','m','b','g','r','y','c','k','m','b','g','r','k','k','k','c','m','b','g','r','k','k','k','k','c','m','b','g','r'};
rasterParams.colors = {'k','m','m','m','m','k','k','k','m','m','m','m','k','k','k','k','m','m','m','m','k','k','k','k','k','m','m','m','m'};

%%
rasterParams.colors = {'k','m','m','m','m','k','k','k','m','m','m','m','k','k','k','k','m','m','m','m','k','k','k','k','k','m','m','m','m'};

%plot the slice simulation spike raster, each dot represents the time(on the x axis) at
%which the neuron of a particular id (on the y axis) fired. 
rasterParams.groupBoundaryLines = 'c';
rasterParams.title = 'Spike Raster';



rasterParams.xlabel = 'Time (ms)';
rasterParams.ylabel = 'Neuron ID';
N = Results.params.TissueParams.N; 

rasterParams.neuronsToPlot = 1:10:N;
rasterFigureImproved = plotSpikeRaster(Results, rasterParams);

%%
ConnectivityNames = {'L23_PC','L23_NBC','L23_LBC','L23_SBC','L23_MC',...
    'L4_SS','L4_SP','L4_PC','L4_NBC','L4_SBC','L4_LBC','L4_MC',...
    'L5_TTPC2','L5_TTPC1','L5_UTPC','L5_STPC','L5_LBC','L5_SBC','L5_NBC','L5_MC'...
    'L6_TPC_L1', 'L6_TPC_L4', 'L6_UTPC','L6_IPC','L6_BPC', 'L6_LBC', 'L6_NBC', 'L6_SBC', 'L6_MC'};


N = Results.params.TissueParams.N;

pars.markers = {'^','x','x','x','s', ...
    'd','*','^','x','x','x','m',...
    '^','^','^','*','x','x','x','s'...
    '^','^','^','v','p','x','x','x','s'};
pars.figureID =1;
pars.toPlot = 1:5:N;
%pars.dimensionscaler = 0.000001;
Results.params.TissueParams.scale = 1;
plotSomaPositions(Results.params.TissueParams,pars);
