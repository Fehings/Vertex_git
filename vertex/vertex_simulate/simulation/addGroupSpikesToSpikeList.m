function [S] = addGroupSpikesToSpikeList(NeuronModel,IDMap,S,iGroup,comCount)

groupSpikes = NeuronModel{iGroup}.spikes();
numSpikes = sum(groupSpikes);
if numSpikes ~= 0
    if length(IDMap.cellIDToModelIDMap{iGroup}) ~= length(groupSpikes)
        length(IDMap.cellIDToModelIDMap{iGroup})
        length(groupSpikes)
        iGroup;
        IDMap.cellIDToModelIDMap{iGroup}(logical(groupSpikes))
    end
  S.spikes(S.spikeCount+1:S.spikeCount+numSpikes) = ...
    IDMap.cellIDToModelIDMap{iGroup}(logical(groupSpikes));
  S.spikeStep(S.spikeCount+1:S.spikeCount+numSpikes) = comCount;
  S.spikeCount = S.spikeCount + numSpikes;
end
  S.currentgroupspikes{iGroup}=numSpikes; % adding this in for the JanRit implementation,
  % to be used as an output. This value will be overwritten each step.
end
