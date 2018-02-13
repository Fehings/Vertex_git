function [layerLFP] = plotLFPbyLayer(Results,t)
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
    finish =length(Results.LFP);
end

elecLayers = findElectrodeLayers(Results);

numL = max(elecLayers); % number of layers

colours=['k','m','b','r','c','y','g'];

%figure('Color',[1 1 1]);

for i=1:numL
    layerLFP(:,i)=mean(Results.LFP(elecLayers==i,start:finish));
    subplot(numL,1,i)
    plot(layerLFP(:,i),'Color',colours(i))
    xlabel('time (ms)','FontSize',16)
    ylabel('mv','FontSize',16)
    title(['averaged LFP for layer ' num2str(i)],'FontSize',16) 
    
    
end

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

text(0.5, 1,'\bf LFP averaged by layer ','HorizontalAlignment','center','VerticalAlignment', 'top','FontSize',20)


end

    

