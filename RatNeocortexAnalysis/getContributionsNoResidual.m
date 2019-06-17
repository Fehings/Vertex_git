function [contributions] = getContributionsNoResidual(LFP,electrode,times,t)
%getContributions Summary of this function goes here
%   Detailed explanation goes here
figure;
title(['Postsynaptic Neuron Group Contributions to LFP at Electrode ' num2str(electrode)]);
subplot(1,2,1);
timevec=times(1):times(2);

total = zeros(1,length(LFP{1}(electrode,timevec)));
for iGroup = 1:length(LFP)
    LFP{iGroup} = LFP{iGroup};
    total = total + LFP{iGroup}(electrode,timevec);
end
plot(t(timevec),total-median(total),'Color', 'k', 'LineStyle', '--','LineWidth',2);
hold on;
total_sum = 0;
for iGroup = 1:length(LFP)
    total_sum = total_sum + sum(abs(LFP{iGroup}(electrode,timevec)-median(LFP{iGroup}(electrode,timevec))));
end
gnames = {'L23PC', 'L23NBC', 'L23LBC', 'L23SBC', 'L23MC', 'L4SS', 'L4SPC', 'L4PC', 'L4NBC', 'L4LBC', 'L4SBC', 'L4MC', 'L5TTPC2', 'L5TTPC1', 'L5UTPC', 'L5STPC', 'L5NBC', 'L5LBC', 'L5SBC', 'L5MC', 'L6TPC_L1', 'L6TPC_L4', 'L6UPTC', 'L6IPC', 'L6BPC', 'L6NBC', 'L6LBC', 'L6SBC', 'L6MC'};
contributions = zeros(1,length(LFP));
for iGroup = 1:length(LFP)
    contributions(iGroup) = sum(abs(LFP{iGroup}(electrode,timevec)-median(LFP{iGroup}(electrode,timevec))))/total_sum;
    disp([gnames{iGroup} ' contributes ' num2str(contributions(iGroup)*100) '%'])
end
[B, I] = sort(contributions,'descend');
B = B .*100;
parttotal = zeros(1,length(LFP{1}(electrode,timevec)));
groups = cell(5,1);
legend_groups = cell(6,1);
legend_groups{1} = 'Total signal';
lcount = 1;
for iGroup = I(1:5)
    plot(t(timevec),LFP{iGroup}(electrode,timevec)-median(LFP{iGroup}(electrode,timevec)),'LineWidth',2);
    groups{lcount} = gnames{iGroup};
    legend_groups{lcount+1} = gnames{iGroup};
    lcount = lcount+ 1;
end
legend(legend_groups)
hold off;
ylabel('LFP (mV)')
xlabel('Time (s)');
c = categorical(groups);
c = reordercats(c,groups);
subplot(1,2,2);
bar(c,B(1:5))
ylabel('Contribution (%)')
