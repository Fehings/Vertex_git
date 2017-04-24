function [RecVar] = ...
  updateWeightsRecording(RecVar,Rectimecounter,wArr,SS)

presyn = RecVar.preweightsRecCellIDArr;

if SS.parallelSim
        for i = 1:length(presyn)
            RecVar.weightsRecording{i}(Rectimecounter,:) = wArr{presyn(i),1};
        end
else
    for i = 1:length(presyn)
        RecVar.weightsRecording{i}(Rectimecounter,:) = wArr{presyn(i),1};
    end
end
end
