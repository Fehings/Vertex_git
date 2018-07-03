function [numSynapses] = ...
  calculateNumSynapsesRemaining(CP, TP, somaPositionMat, number, neuronInGroup)

ratioRemaining = ones(number, TP.numLayers);
numSynapses = zeros(number, TP.numLayers, TP.numGroups, 'uint16');
for iPreGroup = 1:TP.numGroups
  inGroup = neuronInGroup == iPreGroup;
  if isfield(TP,'R')
      if CP(iPreGroup).sliceSynapses
          ratioRemaining(inGroup, :) = ...
      calculateArbourProportionRemainingR( ...
          somaPositionMat(inGroup, :), TP.R, ...
          CP(iPreGroup).axonArborRadius, CP(iPreGroup).axonArborSpatialModel);
      else

      end
  else
        if CP(iPreGroup).sliceSynapses
            ratioRemaining(inGroup, :) = ...
      calculateArbourProportionRemaining( ...
          somaPositionMat(inGroup, :), TP.X, TP.Y, ...
          CP(iPreGroup).axonArborRadius, CP(iPreGroup).axonArborSpatialModel);
        else
    %ratioRemaining(inGroup, :) = ...
    %  ones(size(TP.somaPositionMat(inGroup, 1), 1), TP.numLayers);
        end
  end
  
  preC = cell2mat(CP(iPreGroup).numConnectionsToAllFromOne')';
  
  for iLayer = 1:TP.numLayers
    numSynapses(inGroup, iLayer, :) = ...
      round(bsxfun(@times, ratioRemaining(inGroup, iLayer), preC(iLayer, :)));
  end
  
end
end