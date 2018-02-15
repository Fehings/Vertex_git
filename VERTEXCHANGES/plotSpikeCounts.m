function [p] = plotSpikeCounts(Results,t,NeuronInd, pars)

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

    

Spikes=Results.spikes(Results.spikes(:,1)>NeuronInd(1) & Results.spikes(:,1)<NeuronInd(2),2);

Spikes=Spikes(Spikes>start);
Spikes=Spikes(Spikes<finish);
nbins = diff([start finish]);
N = diff(NeuronInd);

[a,b] = hist(Spikes,nbins);
p = plot(b,(a*1000)./N,'Color','k');
sum(a)
if isfield(pars, 'color')
    set(p,'Color',pars.color)
end

end
