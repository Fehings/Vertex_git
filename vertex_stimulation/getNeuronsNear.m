function [neuronID] = getNeuronsNear(TP,coordinates, number, group)
%getNeuronsNear Returns the neuron ids of those nearest the coordinates
%given
%   Returns the IDs of the closest number of neurons in group.
%   e.g. if we wish to get the IDs of neurons in group 13 near an electrode at position
%   (1150, 1250) then we specify getNeuronsNear(Results,[1150, 1250], 50,
%   200). We can specify 2 or 3 dimensional coordinates, if 2 are provided
%   we ignore the z coordinate.

group_ind = TP.somaPositionMat(:,4)>TP.groupBoundaryIDArr(group) & TP.somaPositionMat(:,4)<TP.groupBoundaryIDArr(group+1);
distance = abs(TP.somaPositionMat(group_ind,1) - coordinates(1)) + abs(TP.somaPositionMat(group_ind,2) - coordinates(2));
[~, sorted_indices] = sort(distance);
group_ids = TP.somaPositionMat(group_ind,4);
neuronID = group_ids(sorted_indices(1:number));
end

