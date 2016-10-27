function [ varArr ] = getSynVarArr(synapseArr)
varArr = cell(size(synapseArr, 1), 1);


for iN = 1:size(synapseArr, 1)
  if ~isempty(synapseArr{iN, 1})
    weights = ones(length(synapseArr{iN, 1}),1);
    varArr{iN, 1} = weights(:)';
  end
end
