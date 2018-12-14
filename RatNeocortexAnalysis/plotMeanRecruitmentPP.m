intervals = 50:50:250;
recr = cell(length(intervals),5);
for iInterval = 1:length(intervals)
    for iRun = 1:5
        results = loadResults([path num2str(intervals(iInterval)) '100' num2str(iRun)]);
        recr{iInterval,iRun} = getStimulusRecruitment(results,false);
    end
end
%%
recrmean = zeros(5,2,29);
recrstd = zeros(5,2,29);

for iInterval = 1:length(intervals)
    intervalvalue = zeros(5,2,29);
    for iRun = 1:5
        intervalvalue(iRun,:,:) = recr{iInterval,iRun};
    end
    recrmean(iInterval,1,:) = mean(intervalvalue(:,1,:));
    recrmean(iInterval,2,:) = mean(intervalvalue(:,2,:));
    recrstd(iInterval,1,:) = std(intervalvalue(:,1,:));
    recrstd(iInterval,2,:) = std(intervalvalue(:,2,:));
end

y = [recrmean(1,1,14) recrmean(:,2,14)'];
x = categorical({'1st Pulse' num2str(intervals(1)) num2str(intervals(2)) ...
    num2str(intervals(3)) num2str(intervals(4)) num2str(intervals(5))});
x = reordercats(x,{'1st Pulse' num2str(intervals(1)) num2str(intervals(2)) ...
    num2str(intervals(3)) num2str(intervals(4)) num2str(intervals(5))});
er = [recrstd(1,1,14) recrstd(:,2,14)'];
bar(x,y);
hold on;
errorbar(x,y,er,'.k');
% gnames = {'L23PC', 'L23NBC', 'L23LBC', 'L23SBC', 'L23MC', 'L4SS', 'L4SPC', 'L4PC', 'L4NBC', 'L4LBC', 'L4SBC', 'L4MC', 'L5TTPC2', 'L5TTPC1', 'L5UTPC', 'L5STPC', 'L5NBC', 'L5LBC', 'L5SBC', 'L5MC', 'L6TPCL1', 'L6TPCL4', 'L6UPTC', 'L6IPC', 'L6BPC', 'L6NBC', 'L6LBC', 'L6SBC', 'L6MC'};
% 
% c = categorical(gnames);
% c = reordercats(c,gnames);
% 
% barh(c,mean(recr).*100)
% hold on;
% errorbar(mean(recr).*100,c,std(recr).*100,'.k', 'horizontal');
% hold off
% set(gca,'Ydir', 'reverse');