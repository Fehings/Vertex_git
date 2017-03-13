function [RecVar] = ...
  updateApre_synRecording(SynapseModel,RecVar,iGroup,recTimeCounter)

inGroup = RecVar.apre_synRecCellIDArr(:, 2) == iGroup;

if sum(inGroup) ~= 0
    RecVar.apre_synRecording(inGroup, :, recTimeCounter) = 0;
    for iSynType = 1:size(SynapseModel, 2)
        RecVar.apre_synRecording(inGroup, iSynType, recTimeCounter,:) = ...
            SynapseModel{iGroup, iSynType}.Apre(RecVar.apre_synRecCellIDArr(inGroup, 1));
        if max(SynapseModel{iGroup, iSynType}.Apre(RecVar.apre_synRecCellIDArr(inGroup, 1)))>0
            disp(SynapseModel{iGroup, iSynType}.Apre(RecVar.apre_synRecCellIDArr(inGroup, 1)));
        end
    end
end


