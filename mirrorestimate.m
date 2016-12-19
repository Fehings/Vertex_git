function [ mirror_estimate ] = mirrorestimate( compartmentstart, compartmentend, extVfield,t )
midpoint = (compartmentstart + compartmentend)/2;

if isa(extVfield,'pde.StationaryResults')
    V_ext = interpolateSolution(extVfield, midpoint);
end

mirror_estimate = - V_ext;
end