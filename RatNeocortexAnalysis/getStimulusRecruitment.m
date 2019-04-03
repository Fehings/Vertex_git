function [proportion_recruited,recruited_ids] = getStimulusRecruitment(Results,rate)
%getStimulusRecruitment Returns the proportion or rate change of each neuron group
%recruited by the stimulus
%   If rate = false: For each stimulation block the proportion of each neuron group that
%   spikes is calculated. This is done by counting the number that has
%   spiked during the stimulation and dividing this by the total number of
%   neurons. This gives an approximation of which neurons are most
%   recruited by a given stimulus. 
%   If rate = true: The change in firing rate as a result of stimulation for each group 
%   is returned.
if nargin < 2 
    rate = 0;
end
stimOn = Results.params.TissueParams.StimulationOn;
stimOff = Results.params.TissueParams.StimulationOff;
numGroups = Results.params.TissueParams.numGroups;
groupBoundaries = Results.params.TissueParams.groupBoundaryIDArr;
proportion_recruited = zeros(length(stimOn), numGroups);
for iStim = 1:length(stimOn)
    for iGroup = 1:numGroups
        if ~rate
            [proportion_recruited(iStim,iGroup),recruited_ids{iStim,iGroup}] = calculateProportion(Results.spikes,...
                [groupBoundaries(iGroup)+1,groupBoundaries(iGroup+1)], ...
                [stimOn(iStim), stimOff(iStim)]);
            
        else
            proportion_recruited(iStim,iGroup) = calculateRateChange(Results.spikes,...
                [groupBoundaries(iGroup)+1,groupBoundaries(iGroup+1)], ...
                [stimOn(iStim), stimOff(iStim)]);
        end
    end
    
end
end
function [proportion, spikeIDs] = calculateProportion(spikes, groupID, times)
    spikeIDs = spikes((spikes(:,1)>groupID(1) & spikes(:,1)<groupID(2)& ...
        (spikes(:,2)>=times(1) & spikes(:,2)<=times(2))),1);
    [spikeIDs, ind] = unique(spikeIDs);
    spikeIDsbase = spikes((spikes(:,1)>groupID(1) & spikes(:,1)<groupID(2)& ...
        (spikes(:,2)<=times(1) & spikes(:,2)>=(times(1)-diff([times(1) times(2)])))),1);
    [spikeIDsbase, indbase] = unique(spikeIDsbase);
    proportion = length(spikeIDs)./diff(groupID);
end
function [ratechange,spikeIDs]= calculateRateChange(spikes, groupID, times)

    ratechange = sum((spikes(:,1)>groupID(1) & spikes(:,1)<groupID(2)) ...
        & (spikes(:,2)>times(1) & spikes(:,2)<times(2)))./diff([times(1) times(2)]) - ...
        sum((spikes(:,1)>groupID(1) & spikes(:,1)<groupID(2)) ...
        & (spikes(:,2)<times(1)))./times(1);
end