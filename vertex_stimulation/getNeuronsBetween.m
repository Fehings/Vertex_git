function  [neuron_id,absNeuronID] = getNeuronsBetween(TP, group, X, Y, Z)
%getNeuronsBetween Returns the neuron ID of those within the bounds
%specified.
%   Detailed explanation goes here
group_ind = TP.somaPositionMat(:,4)>TP.groupBoundaryIDArr(group) & TP.somaPositionMat(:,4)<TP.groupBoundaryIDArr(group+1);
group_ind = TP.somaPositionMat(group_ind,1)>X(1) & TP.somaPositionMat(group_ind,1)<X(2) & ...
    TP.somaPositionMat(group_ind,2)>Y(1) & TP.somaPositionMat(group_ind,2)<Y(2) & ...
    TP.somaPositionMat(group_ind,3)>Z(1) & TP.somaPositionMat(group_ind,3)<Z(2);
neuron_id = TP.somaPositionMat(group_ind,4);
absNeuronID = neuron_id + TP.groupBoundaryIDArr(group);
end

