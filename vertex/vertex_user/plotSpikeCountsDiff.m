function [figurehandle,a,b] = plotSpikeCountsDiff(Results1,Results2,t)

% a function to plot the occurences of spikes over time.
% will try to add more options in the future so that like plotSpikeRaster
% you can plot for a subsection of the neurons.
%
% Results should be the Results structure producesd by VERTEX from a
% simulation run and reloaded with loadResults.
% 
% t should be a vector of [starttime, endtime]

if exist('t','var')
    start = t(1);
    finish = t(2);
else
    start = 1;
    finish = min([max(Results1.spikes(:,2)),max(Results2.spikes(:,2))]);
end


Spikes1=Results1.spikes(:,2);
Spikes2=Results2.spikes(:,2);

[spikelog,spikeloc]=ismember(Spikes1,Spikes2);

diffSpikes=~spikelog;
Spikes=Spikes1(diffSpikes);


Spikes=Spikes(Spikes>start);
Spikes=Spikes(Spikes<finish);

[a,b] = hist(Spikes,unique(Spikes));
figurehandle = plot(b,a,'Color','k');

end
