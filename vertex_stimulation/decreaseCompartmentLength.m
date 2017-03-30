function [NP] = decreaseCompartmentLength(NP)
%Find compartments greater than space constant/4, then split them in two
%until they are small enough.
bigcompartments = find(NP.compartmentLengthArr > NP.spaceconstant*2);
for i = bigcompartments
    %compartment i is too big, so we will split it in two
    NP.compartmentParentArr(end+1) = i;
    NP.compartmentDiameterArr(end+1) = NP.compartmentDiameterArr(i);
    %half the size of the original compartment
    %New compartment created that has end ppoint at the end point of the
    %original and start point at the midpoint.
    NP.compartmentXPositionMat(end+1,2) =  NP.compartmentXPositionMat(i,2);
    NP.compartmentYPositionMat(end+1,2) = NP.compartmentYPositionMat(i,2);
    NP.compartmentZPositionMat(end+1,2) =  NP.compartmentZPositionMat(i,2);

    NP.compartmentXPositionMat(end,1) = (NP.compartmentXPositionMat(i,1) +  NP.compartmentXPositionMat(i,2))/2;
    NP.compartmentYPositionMat(end,1) = (NP.compartmentYPositionMat(i,1) +  NP.compartmentYPositionMat(i,2))/2;
    NP.compartmentZPositionMat(end,1) = (NP.compartmentZPositionMat(i,1) +  NP.compartmentZPositionMat(i,2))/2;
    %The end point of the original compartment gets shifted to the
    %midppoint.
    NP.compartmentXPositionMat(i,2) = (NP.compartmentXPositionMat(i,1) +  NP.compartmentXPositionMat(i,2))/2;
    NP.compartmentYPositionMat(i,2) = (NP.compartmentYPositionMat(i,1) +  NP.compartmentYPositionMat(i,2))/2;
    NP.compartmentZPositionMat(i,2) = (NP.compartmentZPositionMat(i,1) +  NP.compartmentZPositionMat(i,2))/2;

    %Calculate new compartment lengths
    NP.compartmentLengthArr(end+1) = sqrt((NP.compartmentXPositionMat(end,1) - NP.compartmentXPositionMat(end,2))^2 + ...
        (NP.compartmentYPositionMat(end,1) - NP.compartmentYPositionMat(end,2))^2 + ...
        (NP.compartmentZPositionMat(end,1) - NP.compartmentZPositionMat(end,2))^2);
    NP.compartmentLengthArr(i) = sqrt((NP.compartmentXPositionMat(i,1) - NP.compartmentXPositionMat(i,2))^2 + ...
        (NP.compartmentYPositionMat(i,1) - NP.compartmentYPositionMat(i,2))^2 + ...
        (NP.compartmentZPositionMat(i,1) - NP.compartmentZPositionMat(i,2))^2);
    NP.numCompartments = NP.numCompartments+1;
    
end

end


