IDs = Results.params.RecordingSettings.CSD_NeuronIDs;
NP = Results.params.NeuronParams;
SS = Results.params.SimulationSettings;
TP = Results.params.TissueParams;

[CSDarr, MidPoints] = getCSDLinearArr(NP,IDs,SS,TP,Results.csd,7500:9500,1:29);
[CSDarr2, MidPoints] = getCSDLinearArr(NP,IDs,SS,TP,Results2.csd,7500:9500,1:29);
%scatter3(MidPoints(:,1), MidPoints(:,2), MidPoints(:,3),abs(CSDarr), CSDarr,'filled')
CSD = zeros(16,2001);
arraydim = 1:round(2082/16):2082;
for i = 1:length(arraydim)-1
    CSD(i,:) = mean((CSDarr(MidPoints(:,3)>arraydim(i) & MidPoints(:,3)<arraydim(i+1),:)-...
        CSDarr2(MidPoints(:,3)>arraydim(i) & MidPoints(:,3)<arraydim(i+1),:)));
end
subplot(1,2,1);
imagesc(CSD./1000)
set(gca, 'YDir', 'normal');
colorbar()
subplot(1,2,2);

imagesc(diff(diff(Results.LFP(1:16,7500:9500)-Results2.LFP(1:16,7500:9500))))
set(gca, 'YDir', 'normal');
colorbar()

