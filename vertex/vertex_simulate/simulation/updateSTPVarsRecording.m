function [RecVar] = ...
  updateSTPVarsRecording(SynapseModel,RecVar,iGroup,recTimeCounter,synMap,neuronInGroup, TP)

inGroup = neuronInGroup(RecVar.fac_synRecModelIDArr)==iGroup;
%RecVar.fac_synRecCellIDArr

NeurontoRecord = RecVar.fac_synRecModelIDArr(inGroup) - TP.groupBoundaryIDArr(iGroup);

if sum(inGroup) ~= 0
    %Find a post synaptic group that this group connects to with stp synapses. 
    %This will contain the F and D values for the current presynaptic group
    
    %For each post synaptic group
    for i = 1:length(SynapseModel(:,1))
        if isa(SynapseModel{i,synMap{i}(iGroup)},'SynapseModel_g_stp')

          [RecVar.fac_synRecording{1}(inGroup,i, recTimeCounter), RecVar.fac_synRecording{2}(inGroup,i, recTimeCounter)] = ...
            getSTPVars(SynapseModel{i,synMap{i}(iGroup)}, NeurontoRecord,iGroup);

        end
    end
end
