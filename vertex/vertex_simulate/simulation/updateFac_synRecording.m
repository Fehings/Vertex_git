function [RecVar] = ...
  updateSTPVarsRecording(SynapseModel,RecVar,iGroup,recTimeCounter,synMap,TP)

inGroup = RecVar.fac_synRecCellIDArr(2,:)==iGroup;
NeurontoRecord = RecVar.fac_synRecCellIDArr(1,RecVar.fac_synRecCellIDArr(2,:)==iGroup);
if sum(inGroup) ~= 0
    %Find a post synaptic group that this group connects to with stp synapses. 
    %This will contain the F and D values for the current presynaptic group
    %For each post synaptic group
    for i = 1:length(SynapseModel(:,1))
        if isa(SynapseModel{i,synMap{i}(iGroup)},'SynapseModel_g_stp')
          RecVar.fac_synRecording{1}(inGroup,i, recTimeCounter) = ...
            SynapseModel{i,synMap{i}(iGroup)}.F(NeurontoRecord, 1);
            RecVar.fac_synRecording{2}(inGroup,i, recTimeCounter) = ...
            SynapseModel{i,synMap{i}(iGroup)}.D(NeurontoRecord, 1);
        end

    end
end
