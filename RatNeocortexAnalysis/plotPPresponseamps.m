intervals = 50:50:250;
location = '/media/b3046588/Elements/pairedPulse/pairedpulse_';
LFPs = cell(length(intervals),5);
params = cell(length(intervals),5);
times =  cell(length(intervals),5);
peaks =  cell(length(intervals),5);
troughs = cell(length(intervals),5);
for iN = 1:length(intervals)
    for iRun = 1:5
         [lfp, times{iN,iRun},params{iN,iRun}] = getLFPOnly([location num2str(intervals(iN)) '100' num2str(iRun)]);
         LFPs{iN,iRun} = lfp(2,:);
         [peaks{iN,iRun}, troughs{iN,iRun}] = getpeaksofresponse(LFPs{iN,iRun}, params{iN,iRun});
    end
end
%%
for iN = 1:length(intervals)
    for iRun = 1:5
         [peaks{iN}(iRun,:), troughs{iN}(iRun,:)] = getpeaksofresponse(LFPs{iN,iRun}, params{iN,iRun});
    end
end
       
%%
meanpeaks = zeros(5,1);
stdpeaks = zeros(5,1);
meantroughs = zeros(5,1);
stdtroughs = zeros(5,1);

for iN = 1:length(intervals)
     meanpeaks(iN) = mean((peaks{iN}(:,2)-peaks{iN}(:,1))./peaks{iN}(:,2));
     stdpeaks(iN) = std((peaks{iN}(:,2)-peaks{iN}(:,1))./peaks{iN}(:,2));
     meantroughs(iN) = mean((troughs{iN}(:,2)-troughs{iN}(:,1))./troughs{iN}(:,2));
     stdtroughs(iN) = std((troughs{iN}(:,2)-troughs{iN}(:,1))./troughs{iN}(:,2));    
end
%%
errorbar(intervals,meanpeaks,stdpeaks);
hold on;
errorbar(intervals,meantroughs,stdtroughs);

