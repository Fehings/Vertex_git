function RecVar = updateCSDRecording(RS,NeuronModel,RecVar,iGroup,recTimeCounter)
  if ismember(iGroup,RS.CSD_groups)
    RecVar.CSDRecording{iGroup}(:,:,recTimeCounter) = -NeuronModel{iGroup}.I_ax(RecVar.CSD_NeuronIDs{iGroup}(:,1),:);
  end
end
