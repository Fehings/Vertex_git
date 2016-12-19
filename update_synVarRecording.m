function [RecVar] = ...
  updateApre_synRecording(SynapseModel,RecVar,iGroup,recTimeCounter)

inGroup = RecVar.synVarRecCellIDArr(:, 2) == iGroup;

if sum(inGroup) ~= 0
    RecVar.ApostRecording(inGroup, :, recTimeCounter) = 0;
    for iSynType = 1:size(SynapseModel, 2)
        RecVar.ApostsynRecording{inGroup, iSynType, recTimeCounter} = ...
            SynapseModel{iGroup, iSynType}.Apost(RecVar.I_synRecCellIDArr(inGroup, 1));
        RecVar.ApresynRecording{inGroup, iSynType, recTimeCounter} = ...
            SynapseModel{iGroup, iSynType}.Apre(RecVar.I_synRecCellIDArr(inGroup, 1));
    end
end


