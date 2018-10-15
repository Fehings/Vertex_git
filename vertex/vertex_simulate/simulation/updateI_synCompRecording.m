function [RecVar] = ...
  updateI_synCompRecording(RS,SynapseModel,synMap,RecVar,iPostGroup,recTimeCounter)

 if ismember(iPostGroup,RS.I_synComp_groups)
     
     %RecVar.I_synComp_NeuronIDs{iPostGroup}
    RecVar.I_synCompRecording{iPostGroup}(:, :, recTimeCounter) = 0;
        for iSynType = 1:size(SynapseModel, 2)
            if ~isempty(SynapseModel{iPostGroup, synMap{iPostGroup}(iSynType)})
                RecVar.I_synCompRecording{iPostGroup}(:, :, recTimeCounter) = ...
                    RecVar.I_synCompRecording{iPostGroup}(:, :, recTimeCounter)...
                    -SynapseModel{iPostGroup, synMap{iPostGroup}(iSynType)}.I_syn(RecVar.I_synComp_NeuronIDs{iPostGroup}(:,1), :);
            end
        end


    
end
end