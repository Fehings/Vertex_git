function [CSDArr, MidPoints] = getCSDLinearArr(NP,IDs,SS,TP,I_ax,timepoint,groups)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

cC = 0;
totalC = 0;
for iGroup = groups
    totalC = totalC+NP(iGroup).numCompartments*size(I_ax{iGroup},1);
end

CSDArr = zeros(totalC,length(timepoint));
MidPoints = zeros(totalC,3);
for iGroup = groups
    NID = IDs{iGroup};
    if ~isempty(NID)
        compartmentlocations = getCompartmentLocationsCSD(NP,SS,TP,NID,iGroup);
        compartmentMidPoints = getMidPoints(compartmentlocations);
        for iN = 1:size(I_ax{iGroup},1)
            CSDArr(cC+1:cC+NP(iGroup).numCompartments,:) = I_ax{iGroup}(iN,:,timepoint);
            MidPoints(cC+1:cC+NP(iGroup).numCompartments,:) = compartmentMidPoints(:,:,iN)';
            cC = cC + NP(iGroup).numCompartments;
        end
    end
end
end

