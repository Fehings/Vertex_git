function [RecVar] = ...
  updateSTPVarsRecording(SynapseModel,RecVar,iGroup,recTimeCounter,synMap,neuronInGroup, TP)

inGroup = neuronInGroup(RecVar.stp_synRecModelIDArr)==iGroup;
%RecVar.fac_synRecCellIDArr
inGroupCell = RecVar.stp_synRecCellIDArr(:, 2) == iGroup;

NeurontoRecord = RecVar.stp_synRecModelIDArr(inGroup) - TP.groupBoundaryIDArr(iGroup);

if sum(inGroup) ~= 0
    %Find a post synaptic group that this group connects to with stp synapses. 
    %This will contain the STP values for the current presynaptic group
    
    %For each post synaptic group
    for i = 1:length(SynapseModel(:,1))
        if isa(SynapseModel{i,synMap{i}(iGroup)},'STPModel')

          RecVar.stp_synRecording{i}(inGroupCell,:, recTimeCounter) = ...
            getSTPVars(SynapseModel{i,synMap{i}(iGroup)}, NeurontoRecord,iGroup);
        end
    end
end
