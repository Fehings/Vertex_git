function [RecVar] = ...
  updateFac_synRecording(SynapseModel,RecVar,iGroup,recTimeCounter,synMap,TP)

neuronInGroup = createGroupsFromBoundaries(TP.groupBoundaryIDArr); 
inGroup = RecVar.fac_synRecCellIDArr(2,:)==iGroup;
NeurontoRecord = RecVar.fac_synRecCellIDArr(1,RecVar.fac_synRecCellIDArr(2,:)==iGroup);
if sum(inGroup) ~= 0
    %Find a post synaptic group that this group connects to with stp synapses. 
    %This will contain the F and D values for the current presynaptic group
    %For each post synaptic group
    for i = 1:length(SynapseModel(:,1))
        try
        if isa(SynapseModel{i,synMap{i}(iGroup)},'SynapseModel_g_stp')
          RecVar.fac_synRecording(inGroup,1, recTimeCounter) = ...
            SynapseModel{i,synMap{i}(iGroup)}.F(NeurontoRecord, 1);
            RecVar.fac_synRecording(inGroup,2, recTimeCounter) = ...
            SynapseModel{i,synMap{i}(iGroup)}.D(NeurontoRecord, 1);
        break
        end
        catch ME
            disp('err')
            rethrow(ME)
        end
    end
end
