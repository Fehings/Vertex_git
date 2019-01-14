LFP = cell(5,1);
    for iRun = 1:5
        results = load([path '100' num2str(iRun) 'R']);
        LFP{iRun} = results.LFP;
    end
%%
firstlfp = zeros(5,3501);
secondlfp = zeros(5,3501);
firstlocation = 7000:10500;
secondlocation = 26346-1000:26346+2500;
time1 = ((1:length(firstlocation))./results.params.RecordingSettings.sampleRate).*1000;
for iRun = 1:5
    firstlfp(iRun,:) = LFP{iRun}(2,firstlocation)-median(LFP{iRun}(2,:));
    secondlfp(iRun,:) = LFP{iRun}(2,secondlocation)-median(LFP{iRun}(2,:));
end
[hl, pl] = boundedline(time1,mean(firstlfp),std(firstlfp),time1,mean(secondlfp),std(secondlfp),'cmap',lines(2));
legend(hl,{'Before TBS','After TBS'});