function [recurrentInhibition] = getCurrents(Results,preGroups,postRelativeID)
%getStimulusRecruitment Returns the proportion or rate change of each neuron group
%recruited by the stimulus
%   If rate = false: For each stimulation block the proportion of each neuron group that
%   spikes is calculated. This is done by counting the number that has
%   spiked during the stimulation and dividing this by the total number of
%   neurons. This gives an approximation of which neurons are most
%   recruited by a given stimulus. 
%   If rate = true: The change in firing rate as a result of stimulation for each group 
%   is returned.

stimOn = round(Results.params.TissueParams.StimulationOn*Results.params.RecordingSettings.sampleRate./1000);
recurrentInhibition = zeros(length(stimOn));
for iStim = 1:length(stimOn)
    for iGroup = preGroups
        groupInhibition(iGroup) = mean(Results.I_syn{iGroup}(postRelativeID,stimOn(iStim)));
    end
    recurrentInhibition(iStim) = sum(groupInhibition);
end
end
