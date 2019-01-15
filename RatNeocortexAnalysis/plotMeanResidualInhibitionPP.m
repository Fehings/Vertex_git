intervals = 50:50:250;
inh = cell(length(intervals),5);
for iInterval = 1:length(intervals)
    for iRun = 1:5
        % Use loadResults for loading from Results folder generated
        % directly by VERTEX.
        %results = loadResults([path num2str(intervals(iInterval)) '100' num2str(iRun)]);
        results = load([path num2str(intervals(iInterval)) '100' num2str(iRun) 'R.mat']);
        results = results.Results;
        inh{iInterval,iRun} = getCurrents(results,[9:12 17:20],50:100);
    end
end
%%
inhmean = zeros(5,2);
inhstd = zeros(5,2);

for iInterval = 1:length(intervals)
    intervalvalue = zeros(5,2);
    for iRun = 1:5
        intervalvalue(iRun,:) = inh{iInterval,iRun}(:,1);
    end
    inhmean(iInterval) = mean(intervalvalue(:,2));
    inhstd(iInterval) = std(intervalvalue(:,2));
    inhstd(iInterval) = std(intervalvalue(:,2));
    inhmeanfirst(iInterval) = mean(intervalvalue(:,1));
    inhstdfirst(iInterval) = std(intervalvalue(:,1));
end

y = [inhmeanfirst(1) inhmean(:,1)'];
x = categorical({'1st Pulse' num2str(intervals(1)) num2str(intervals(2)) ...
    num2str(intervals(3)) num2str(intervals(4)) num2str(intervals(5))});
x = reordercats(x,{'1st Pulse' num2str(intervals(1)) num2str(intervals(2)) ...
    num2str(intervals(3)) num2str(intervals(4)) num2str(intervals(5))});
er = [inhstdfirst(1) inhstd(:,1)'];
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