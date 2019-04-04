IDs = ResultsCSDsyn.params.RecordingSettings.CSD_NeuronIDs;
NP = ResultsCSDsyn.params.NeuronParams;
SS = ResultsCSDsyn.params.SimulationSettings;
TP = ResultsCSDsyn.params.TissueParams;

for i = 7950:9550
    disp(['Frame: ' num2str(i)]);
    [CSDarr, MidPoints] = getCSDLinearArr(NP,IDs,SS,TP,ResultsCSDsyn.csd,i,13:14);
    [CSDarr2, ~] = getCSDLinearArr(NP,IDs,SS,TP,ResultsCSDnosyn.csd,i,13:14);
    CSDarr = CSDarr - CSDarr2;
    CSDarr(abs(CSDarr)>200) = 200;
    scatter3(MidPoints(:,1), MidPoints(:,2), MidPoints(:,3),abs(CSDarr), CSDarr,'filled')
    daspect([1 1 1])
    h = colorbar;
    colormap('jet');
    caxis([-200 200])
    print(['~/CSDMov/' num2str(i-7950)],'-dpng');
end

    