function [CSDarr, MidPoints] = getCSDLinearArr(NP,IDs,somaPositions,rotMat,I_ax,timepoint)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

cC = 1;
CSDArr = [];
MidPoints = [];
for iGroup = 1:length(NP)
    NID = IDs{iGroup};
    compartmentlocations = getCompartmentLocations(NP,SS,TP,IDs);
    compartmentMidPoints = getMidPoints(compartmentlocations);
    for iN = 1:size(I_ax{iGroup},1)
        CSDArr(cC:cC+NP(iGroup).numCompartments) = I_ax{iGroup}(iN,:,timepoint);
        MidPoints(cC:cC+NP(iGroup).numCompartments) = compartmentMidPoints
        cC = cC + NP(iGroup).numCompartments;
    end
end
end

