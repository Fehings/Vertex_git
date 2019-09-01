function [figurehandle] = plotSpikeCounts(Results,t,ids,pars)


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
    finish = max(Results.spikes(:,2));
end

Spikes=Results.spikes(Results.spikes(:,1)>ids(1) & Results.spikes(:,1)<ids(2),2);

Spikes=Spikes(Spikes>start);
Spikes=Spikes(Spikes<finish);

[a,b] = hist(Spikes,unique(Spikes));
figurehandle = plot(b,a,'Color',pars.color);

end
