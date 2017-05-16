function [NP] = decreaseCompartmentLength(NP)
%Find compartments greater than space constant/4, then split them in two
%until they are small enough.
bigcompartments = find(NP.compartmentLengthArr > NP.spaceconstant*NP.minCompartmentSize);
bigcompartments = bigcompartments(bigcompartments>1);
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
    
    if ~isfield(NP, 'labelNames')
        disp('Please provide a labelNames field in neuron parameters, giving the name of the field itentifying compartment labels.')
        error('WARNING! no compartment label names provided. Cannot adjust compartment sizes without label names.')
    end
    for label = NP.labelNames
         %if parent is member, so is child
        if iscell(label)
            if max(ismember(NP.(label{1}), i))
                NP.(label{1}) = [NP.(label{1}) length(NP.compartmentParentArr)];
            end
        else
            NP.(NP.labelNames) = [NP.(NP.labelNames) length(NP.compartmentParentArr)]; %catch the instance when 
        end
    end
end

end


