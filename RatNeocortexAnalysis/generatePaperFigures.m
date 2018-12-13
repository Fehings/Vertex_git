singlePulseDir = '/media/b3046588/Elements/F1000_Data/singlepulse';
pairedPulseDir = '/media/b3046588/Elements/F1000_Data/pairedpulse';
tbsDir = '/media/b3046588/Elements/F1000_Data/tbs';

%% Figure 10 A and C
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/singlepulse/singlepulse_1001';
Results = loadResults(RecordingSettings.saveDir,1);
spikeIDs =  Results.spikes(Results.spikes(:,2)>Results.params.TissueParams.StimulationOn & ...
    Results.spikes(:,2)<Results.params.TissueParams.StimulationOff,1);
%Figure 10(A)
plotsomapositions(Results, spikeIDs);

%Figure 10(C)
rasterParams.colors = {'k','m','m','m','m','k','k','k','m','m','m','m','k','k','k','k','m','m','m','m','k','k','k','k','k','m','m','m','m'};
%plot the slice simulation spike raster, each dot represents the time(on the x axis) at
%which the neuron of a particular id (on the y axis) fired. 
rasterParams.groupBoundaryLines = 'c';
rasterParams.title = 'Spike Raster';
rasterParams.xlabel = 'Time (ms)';
rasterParams.ylabel = 'Neuron ID';
rasterParams.figureID = 2;
N = Results.params.TissueParams.N;
rasterParams.neuronsToPlot = 1:N;
rasterFigureImproved = plotSpikeRaster(Results, rasterParams);

%% Figure 10 B and D
% Figure 10(B)
path = '/media/b3046588/Elements/VERTEX_RESULTS//singlepulse/singlepulse_100';
plotMeanRecruitment; 
%%
%Figure 10(D)
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/singlepulse/singlepulse_1001';
Results = loadResults(RecordingSettings.saveDir,0);
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/no_synapses/singlepulsenosyn1001';
ResultsNoSyn = loadResults(RecordingSettings.saveDir,0);
getContributions(Results.LFP, 2, [7500 9800], ResultsNoSyn.LFP, getTimeVector(Results,'ms'));

%% Figure 11
figure;
t = getTimeVector(Results,'ms');
plot(t(7500:9800), Results.LFP{13}(2,7500:9800)-ResultsNoSyn.LFP{13}(2,7500:9800));
%%
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/CSD/singlepulse_1001_wsyn';
Results = loadResults(RecordingSettings.saveDir,0);
%plotCellCurrents(Results,1:50,1,[7500 9800]);
plotLFPbycompartment;

%% Figure 12
plotMeanRecruitmentPP;
plotMeanResidualInhibitionPP;
plotPPresponseamps;
%% Figure 13 
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/paired_pulse/recfromstimulated/pairedpulse1001';
Results = loadResults(RecordingSettings.saveDir,1);
plotPPsynapticresources;
%%
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/pairedpulsesynI1001';
Results = loadResults(RecordingSettings.saveDir,1);
NP = Results.params.NeuronParams(14);
NP.labelnames = {'somaID','basalID','obliqueID','apicalID','trunkID','tuftID'};
times = [1500 6000];
plotCSDSingleNeuron(Results, Results.I_synComp{1},times);

%%
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/pairedpulse1001';
Results = loadResults(RecordingSettings.saveDir,1);
plotLFPbycompartment;

%% Figure 14
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_RESULTS/STDPJuly2018/pulse_stdp';
Results = loadResults(RecordingSettings.saveDir,1);

figure;
t = getTimeVector(Results, 's');
plot(t(2000:18000),Results.LFP(2,2000:18000));
%%
rasterParams.colors = {'k','m','m','m','m','k','k','k','m','m','m','m','k','k','k','k','m','m','m','m','k','k','k','k','k','m','m','m','m'};

%plot the slice simulation spike raster, each dot represents the time(on the x axis) at
%which the neuron of a particular id (on the y axis) fired. 
rasterParams.groupBoundaryLines = 'c';
rasterParams.title = 'Spike Raster';


rasterParams.xlabel = 'Time (ms)';
rasterParams.ylabel = 'Neuron ID';
N = Results.params.TissueParams.N;

rasterParams.neuronsToPlot = 1:N;
rasterFigureImproved = plotSpikeRaster(Results, rasterParams);
%% Figure 15 B, C, D
RecordingSettings.saveDir = '/media/b3046588/Elements/VERTEX_STDPResults/tbs_weights1001';
Results = loadResults(RecordingSettings.saveDir,1);

% (B) 
plotstdpchangesandspikes(50000,100000, Results);
% (C) 
plotweightchangespatial;
plotweightchangesbygroup;

%% Figure 15 A
plotLTPLFP;
