function [histo, bins] = peristimulustimehist(Results,groups,binsize,stimtime,range)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

groupIDs = createGroupsFromBoundaries(Results.params.TissueParams.groupBoundaryIDArr);

bins = binsize:binsize:Results.params.RecordingSettings.maxRecTime+mod(Results.params.RecordingSettings.maxRecTime,binsize);
histo = zeros(length(bins),1);
if nargin == 5
    groupIDs(1:range(1)) = 0;
    groupIDs(range(2):end) = 0;
end
inGroups = ismember(groupIDs(Results.spikes(:,1)),groups);

count = 1;
for ibin = bins
    histo(count) = sum((Results.spikes(inGroups,2)>(ibin-binsize)) & (Results.spikes(inGroups,2)<ibin)...
        & (Results.spikes(inGroups,2)<stimtime(1) | Results.spikes(inGroups,2)>stimtime(2)) );
    count = count+1;
end
    
end

