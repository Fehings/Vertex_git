function [RecVar] = ...
  updateSTDPVarsRecording(SynapseModel,RecVar,iGroup,recTimeCounter,synMap,neuronInGroup, TP)

inGroup = neuronInGroup(RecVar.stdpvarsRecModelIDArr)==iGroup;
inGroupCell = RecVar.stdpvarsRecCellIDArr(:, 2) == iGroup;


NeurontoRecord = RecVar.stdpvarsRecModelIDArr(inGroup) - TP.groupBoundaryIDArr(iGroup);

if sum(inGroup) ~= 0
    %For each post synaptic group
    for i = 1:length(SynapseModel(:,1))
        if isa(SynapseModel{i,synMap{i}(iGroup)},'STDPModel')
        %Record the A pre variable of recording neurons on connections to
        %neurons in iGroup
          RecVar.stdpvarsRecording{1}(inGroupCell,i, recTimeCounter) = ...
            getApre(SynapseModel{i,synMap{i}(iGroup)},NeurontoRecord,iGroup);

        end
        if isa(SynapseModel{iGroup,synMap{iGroup}(i)},'STDPModel')
          RecVar.stdpvarsRecording{2}(inGroupCell,i, recTimeCounter) = ...
            getApost(SynapseModel{iGroup,synMap{iGroup}(i)}, RecVar.stdpvarsRecCellIDArr(inGroupCell,1));
        end
    end
end
