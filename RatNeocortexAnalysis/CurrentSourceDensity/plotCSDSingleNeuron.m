function plotCSDSingleNeuron(Results, CSD,times, NP, LSM)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
timevec = getTimeVector(Results,'ms');
timevec = timevec(times(1):times(2));
if nargin == 5
    for i = 1:size(CSD,3)
        CSD(:,:,i) = CSD(:,:,i).*LSM;
    end
end

plotAll = false;
if nargin >=4
    hold on;
    cmap = lines(length(NP.labelnames));
    gcolour = zeros(NP.numCompartments,3);
    for iGroup = 1:length(NP.labelnames)
        compartmentGroup = NP.labelnames{iGroup};
        
        iC = NP.(compartmentGroup);
        for iiC = iC
            gcolour(iiC,:) = cmap(iGroup,:);
        end
        if length(iC) > 1
            plot(timevec,squeeze(sum(mean(CSD(:,iC,times(1):times(2))))), 'LineWidth', 2,'DisplayName', compartmentGroup,'Color',cmap(iGroup,:),'LineStyle', '-');
        else
            plot(timevec,squeeze(mean(CSD(:,iC,times(1):times(2)))), 'LineWidth', 2, 'DisplayName', compartmentGroup,'Color',cmap(iGroup,:),'LineStyle', '-');
        end
        if length(iC) > 1
            if plotAll
                for iiC = iC
                    p = plot(timevec,-squeeze(CSD(:,iiC,times(1):times(2))), 'LineWidth', 0.1,'Color',cmap(iGroup,:),'LineStyle', '-');
                    for ip = 1:length(p)

                        p(ip).Annotation.LegendInformation.IconDisplayStyle = 'off';
                        p(ip).Color(4) = 0.1;
                    end
                end
            end
        else
            if plotAll
                p = plot(timevec,-squeeze(CSD(:,iC,times(1):times(2))), 'LineWidth', 0.1, 'Color',cmap(iGroup,:),'LineStyle', '-');
                for ip = 1:length(p)

                    p(ip).Annotation.LegendInformation.IconDisplayStyle = 'off';
                    p(ip).Color(4) = 0.1;
                end
            end
        end
    end
    if nargin ==5
        hold on;
        plot(timevec,squeeze(sum(mean(CSD(:,:,times(1):times(2))))),'k--');
        hold off;
    end
    hold off;
     legend();
    axes('Position',[ .85, .55, .2, .4]);
    box on;
    viewMorphologyXcolour(NP,gcolour);
    box off;
else
    if nargin ==5
        hold on;
        plot(timevec,squeeze(sum(mean(CSD(:,:,times(1):times(2))))),'k--');
        hold off;
    end
    hold on;
    for iC = 1:size(CSD,2)
        plot(timevec,squeeze(mean(CSD(:,iC,times(1):times(2)))));
    end
    hold off;
end


end

