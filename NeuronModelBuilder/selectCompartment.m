function [selection] = selectCompartment(xyz, NP)
%selectCompartment Selects the compartment whose centre is nearest to
%position xyz
%   Detailed explanation goes here
xdiff = xyz(1) - mean(NP.compartmentXPositionMat,2);
ydiff = xyz(2) - mean(NP.compartmentYPositionMat,2);
zdiff = xyz(3) - mean(NP.compartmentZPositionMat,2);

totaldiff = xdiff+ydiff+zdiff;
selection = min(totaldiff);
end

