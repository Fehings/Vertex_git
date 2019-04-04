function plotLFPMeanContributions(LFP,contributions,t,contributionsstd,lfpstd)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
figure;
title(['Postsynaptic Neuron Group Contributions to LFP at Electrode 2']);
subplot(1,2,1);

total = zeros(1,length(LFP{1}));
for iGroup = 1:length(LFP)
    total = total + LFP{iGroup};
end
plot(t,total-median(total),'Color', 'k', 'LineStyle', '--','LineWidth',2);
hold on;
gnames = {'L23PC', 'L23NBC', 'L23LBC', 'L23SBC', 'L23MC', 'L4SS', 'L4SPC', 'L4PC', 'L4NBC', 'L4LBC', 'L4SBC', 'L4MC', 'L5TTPC2', 'L5TTPC1', 'L5UTPC', 'L5STPC', 'L5NBC', 'L5LBC', 'L5SBC', 'L5MC', 'L6TPCL1', 'L6TPCL4', 'L6UPTC', 'L6IPC', 'L6BPC', 'L6NBC', 'L6LBC', 'L6SBC', 'L6MC'};
[B, I] = sort(contributions,'descend');
B = B .*100;
parttotal = zeros(1,length(LFP));
groups = cell(5,1);
legend_groups = cell(6,1);
legend_groups{1} = 'Total signal';
lcount = 1;
for iGroup = I(1:5)
    plot(t,LFP{iGroup}-median(LFP{iGroup}),'LineWidth',2);
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
if nargin >= 4
    hold on;
    errorbar(c,B(1:5),contributionsstd(I(1:5)).*100, '.k')
    hold off;
end
ylabel('Contribution (%)')
end

