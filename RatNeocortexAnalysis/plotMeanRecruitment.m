for iRun = 1:5
    %results = loadResults([path num2str(iRun)]);
    results = load([path num2str(iRun) 'R.mat']);
    results = results.Results;
    recr(iRun,:) = getStimulusRecruitment(results,false);
end
%%
gnames = {'L23PC', 'L23NBC', 'L23LBC', 'L23SBC', 'L23MC', 'L4SS', 'L4SPC', 'L4PC', 'L4NBC', 'L4LBC', 'L4SBC', 'L4MC', 'L5TTPC2', 'L5TTPC1', 'L5UTPC', 'L5STPC', 'L5NBC', 'L5LBC', 'L5SBC', 'L5MC', 'L6TPCL1', 'L6TPCL4', 'L6UPTC', 'L6IPC', 'L6BPC', 'L6NBC', 'L6LBC', 'L6SBC', 'L6MC'};
c = categorical(gnames);
c = reordercats(c,gnames);

barh(c,mean(recr).*100)
hold on;
errorbar(mean(recr).*100,c,std(recr).*100,'.k', 'horizontal');
hold off
set(gca,'Ydir', 'reverse');