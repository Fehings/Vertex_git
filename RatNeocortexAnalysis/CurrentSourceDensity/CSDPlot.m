IDs = Results.params.RecordingSettings.CSD_NeuronIDs;
NP = Results.params.NeuronParams;
SS = Results.params.SimulationSettings;
TP = Results.params.TissueParams;
timecourse = 2500:5000;
%%
[CSDarr, MidPoints] = getCSDLinearArr(NP,IDs,SS,TP,Results.csd,timecourse,13:14);
CSD = zeros(16,length(timecourse));
arraydim = 1:round(2082/16):2082;
for i = 1:length(arraydim)-1
    CSD(i,:) = mean(CSDarr(MidPoints(:,3)>arraydim(i) & MidPoints(:,3)<arraydim(i+1),:));
end
%%
layers = {[1 ] [6 7 8 ] [13 14 15 16 ] [21 22 23 24 25]};

for iL = 1:length(layers)
    subplot(1,4,iL)
    [CSDarr, MidPoints] = getCSDLinearArr(NP,IDs,SS,TP,Results.csd,timecourse,layers{iL});
    scatter3(MidPoints(:,1), MidPoints(:,2), MidPoints(:,3),abs(CSDarr(:,700)), CSDarr(:,700),'filled')
    daspect([1 1 1])
    zlim([0 2082]);
end

    