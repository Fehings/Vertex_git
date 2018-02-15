function [ha] = compareLFPbyLayer(ResultStacked,t)
%
%ResultStacked should be an array of results structures as produced by the
%loadResults command, in the form here of [Results1,Results2,...] which
%will become a larger struct array.
%t is an optional start and end time argument in the form t = [start end],
%recommended if the LFPs to be compared are of different time lengths!
%
% Function to plot the LFP average for each layer in a series of subplots.
%
% this function depends on the findElectrodeLayers function and in turn the
% generateElectrodePositions function, both found in the VERTEX toolbox.



if exist('t','var')
    start = t(1);
    finish = t(2);
else
    start = 1;
    finish =length(ResultStacked(1).LFP);
end

for r = 1:length(ResultStacked)
    
    elecLayers(:,r) = findElectrodeLayers(ResultStacked(r));

end
% add a warning for if the elecLayers don't match.


numL = max(max(elecLayers)); % number of layers

%colours=['k','m','b','r','c','y','g'];

figure('Color',[1 1 1]);


colours = abs(rand(length(ResultStacked),3));


for i=1:numL
    
    subplot(numL,1,i)
    for rr = 1:length(ResultStacked)
        plot(mean(ResultStacked(rr).LFP(elecLayers(:,rr)==i,start:finish)),'Color',colours(rr,:))
        hold on
    end
    %hold off
    legend('show')
    xlabel('time (ms)','FontSize',16)
    ylabel('mv','FontSize',16)
    title(['averaged LFP for layer ' num2str(i)],'FontSize',16) 
    

end

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

text(0.5, 1,'\bf Comparison of LFP averaged by layer ','HorizontalAlignment','center','VerticalAlignment', 'top','FontSize',20)




end