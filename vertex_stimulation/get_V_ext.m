function [ v_ext ] = get_V_ext(locations,field,t)
%get_V_ext Returns the extracellular potential for the locations specified.
%   Detailed explanation goes here

% check whether the field is specified using matlab PDE toolbox - either
% stationary results or time varying - or whether it is specified 
% by a function (passed as a function handle string) or
% whether it is specified as a gridded interpolant.
v_ext = zeros(size(squeeze(locations(1,:,:))))';
for iComp = 1:length(locations(1,:,1))
    if isa(field, 'pde.TimeDependentResults')
        v_ext(:,iComp) = interpolateSolution(field,squeeze(locations(:,iComp,:)),t);
    elseif isa(field, 'pde.StationaryResults')
        a = interpolateSolution(field,squeeze(locations(:,iComp,:)));
        v_ext(:,iComp) = a;
    elseif isstring(field)
        funchand = str2func(field);
        v_ext(:,iComp) = feval(funchand,squeeze(locations(:,iComp,:)));
    elseif isa(field, 'griddedInterpolant')
        v_ext(:,iComp) = field(squeeze(locations(:,iComp,:)));
    else
        v_ext(:,iComp) = interp3(field.x, field.y, field.z, field.v, locations(1,:),locations(2,:),locations(3,:));
    end
v_ext(isnan(v_ext(:,iComp)),iComp) = 0;
end



end

