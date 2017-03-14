function [l, d] = getDimensionsInCentimetres(NP)
l = NP.compartmentLengthArr .* 10^-4;
d = NP.compartmentDiameterArr .* 10^-4;
if min(l) <= 0 
    disp(sum(min(l)>0))
    error('cant have compartment of length less than or equaL to zero')
end
if min(d) <= 0 
    error('cant have compartment of diameter less than or equaL to zero')
end