function [ v_ext ] = get_V_ext(locations,field,t, scale)
%get_V_ext Returns the extracellular potential for the locations specified.
%   Detailed explanation goes here

% check whether the field is specified using matlab PDE toolbox - either
% stationary results or time varying - or whether it is specified 
% by a function (passed as a function handle string) or
% whether it is specified as a gridded interpolant.

if nargin == 4
    locations = locations.*scale;
end
if size(locations,3) == 1
    v_ext = zeros(size(squeeze(locations(1,:,:))));
else
    v_ext = zeros(size(squeeze(locations(1,:,:))))';
end
% locations=locations.*angle

for iComp = 1:length(locations(1,:,1))
    if isa(field, 'pde.TimeDependentResults')
        v_ext(:,iComp) = interpolateSolution(field,squeeze(locations(:,iComp,:)),t);
    elseif isa(field, 'pde.StationaryResults')
        a = interpolateSolution(field,squeeze(locations(:,iComp,:)));
        v_ext(:,iComp) = a;
    elseif ischar(field)
        funchand = str2func(field);
        v_ext(:,iComp) = feval(funchand,squeeze(locations(:,iComp,:)));
    elseif isa(field, 'griddedInterpolant')
        v_ext(:,iComp) = field(squeeze(locations(:,iComp,:)));
    else
        v_ext(:,iComp) = interp3(field.x, field.y, field.z, field.v, locations(1,:),locations(2,:),locations(3,:));
    end
v_ext(isnan(v_ext(:,iComp)),iComp) = 0;
end

if any(v_ext(:)>100) 
    disp('overly large values detected in the field, the values will be capped at 100 and this may produce negligable currents')
elseif any(v_ext(:)<-100)
    disp('overly negative values detected in the field, the values will be capped at -100 and this may produce negligable currents')
elseif nnz(v_ext(:))==0
    disp('The field is zero valued, just so you know. If this was unintended then you may need to troubleshoot.') 
end


end

