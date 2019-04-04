function [ NM ] = get_compartment_midpoints(TP, NM, SS, endpoints)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if SS.parallelSim
    subsetInLab = find(SS.neuronInLab == labindex);
else
    subsetInLab = 1:TP.N;
end
neuronInGroup = ...
    createGroupsFromBoundaries(TP.groupBoundaryIDArr);

% get compartments locations in suitable vectorised form
inlab = neuronInGroup(subsetInLab);
compartmentlocations = cell(TP.numGroups,2);
for iGroup = 1:TP.numGroups
    ingroupinlab = subsetInLab(neuronInGroup(subsetInLab)==iGroup);
    [compartmentlocations{iGroup,1}, compartmentlocations{iGroup,2}] = ...
        convertcompartmentlocations({endpoints{ingroupinlab,1}},...
        {endpoints{ingroupinlab,2}},{endpoints{ingroupinlab,3}});
    point1 = compartmentlocations{iGroup,1};
    point2 = compartmentlocations{iGroup,2};
    %get the mid points of the compartments
    midpoints = zeros(3,length(point1.x(:,1)),length(point1.x(1,:)));
    midpoints(1,:,:) = (point1.x + point2.x)./2;
    midpoints(2,:,:) = (point1.y + point2.y)./2;
    midpoints(3,:,:) = (point1.z + point2.z)./2;
    setmidpoints(NM{iGroup},midpoints);
end



end

