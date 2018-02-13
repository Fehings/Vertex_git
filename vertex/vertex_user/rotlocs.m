function [rotated_locs]=rotlocs(locs,theta,axis)

% function to rotate the neurons for field interpolation. Can be used more
% generically so long as the locs matrix has the right format.

if axis == 'x'
    rotated_locs(1,:,:) = locs(1,:,:);
    rotated_locs(2,:,:) = locs(2,:,:).*cos(theta) - locs(3,:,:).*sin(theta);
    rotated_locs(3,:,:) = locs(2,:,:).*sin(theta) + locs(3,:,:).*cos(theta);
    
elseif axis == 'y'
    
    rotated_locs(1,:,:) = locs(1,:,:).*cos(theta) + locs(3,:,:).*sin(theta);
    rotated_locs(2,:,:) = locs(2,:,:);
    rotated_locs(3,:,:) = locs(3,:,:).*cos(theta) - locs(1,:,:).*sin(theta);
    
else % default is rotate at the z axis
    rotated_locs(1,:,:) = locs(1,:,:).*cos(theta) - locs(2,:,:).*sin(theta);
    rotated_locs(2,:,:) = locs(1,:,:).*sin(theta) + locs(2,:,:).*cos(theta);
    rotated_locs(3,:,:) = locs(3,:,:);

end

end