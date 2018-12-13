function plotCellCurrents(Results,postSynInd,accumulate, times)
time = getTimeVector(Results);
time = time(times(1):times(2));
currents = zeros(length(sum(Results.I_syn{1}(postSynInd,times(1):times(2)))),length(Results.I_syn));
for iGroup = 1:length(Results.I_syn)
    currents(:,iGroup) =  sum(Results.I_syn{iGroup}(postSynInd,times(1):times(2)))...
        -median(sum(Results.I_syn{iGroup}(postSynInd,times(1):times(2)))) ;
end
hold on;
%plot(time,sum(currents'),'--k', 'DisplayName', 'Total current', 'LineWidth',2);
for iGroup = 1:length(Results.I_syn)
    currents(:,iGroup) =  abs(sum(Results.I_syn{iGroup}(postSynInd,times(1):times(2)))...
        -median(sum(Results.I_syn{iGroup}(postSynInd,times(1):times(2))))) ;
end
%calculate total current
current = sum(currents');
%calculate contributions of each presynaptic cell type
contribution = zeros(length(Results.I_syn),1);
for i = 1:length(Results.I_syn)
    contribution(i) = sum(currents(:,i))./sum(current);
end



[B, I] = sort(contribution,'descend');
contributesninetyfivepercent = 0;
for i = 1:length(B)
    if sum(B(1:i)) > 0.75
        contributesninetyfivepercent = i;
        break;
    end
end
bigcontributors = I(1:contributesninetyfivepercent);
cmap = lines(length(bigcontributors));
gcolour = zeros(length(bigcontributors),3);
if accumulate
    for i = 1:length(bigcontributors)
        plot(time,mean(Results.I_syn{bigcontributors(i)}(postSynInd,times(1):times(2))), '-', 'DisplayName', ['Group ' num2str(bigcontributors(i))],'LineWidth',2, 'Color',cmap(i,:));
        %p =plot(time,Results.I_syn{bigcontributors(i)}(postSynInd,times(1):times(2)), '-', 'DisplayName', ['Group ' num2str(bigcontributors(i))],'LineWidth',0.1, 'Color',cmap(i,:));
%         for ip = 1:length(p)
%             
%             p(ip).Annotation.LegendInformation.IconDisplayStyle = 'off';
%             p(ip).Color(4) = 0.1;
%         end
    end
    legend
    
else
    for i = 1:length(Results.I_syn)
        plot(time,Results.I_syn{i}(postSynInd,times(1):times(2))')
    end
end

hold off;
end
