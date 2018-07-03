function [RecVar] = ...
  updateWeightsRecording(RecVar,Rectimecounter,wArr,~)

        for i = 1:length(RecVar.preweightsRecCellIDArr)
            RecVar.weightsRecording{i}(Rectimecounter,:) = wArr{RecVar.preweightsRecCellIDArr(i),1};
        end
end
