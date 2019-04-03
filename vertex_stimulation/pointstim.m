function [ Ve ] = pointstim( fiberposition)
%pointstim Describes a point stimulation analytically. 
%   Calculate the strength of a field at position(s) specified by
%   fiberposition.
load('electrodeposition.mat');
stim_I = (100 *10^-3);
fiberx = fiberposition(1);
fibery = fiberposition(2);
fiberz = fiberposition(3);
stimx = location.x;
stimy = location.y;
stimz = location.z;
r = sqrt((fiberx - stimx)^2 + (fibery - stimy)^2 + (fiberz - stimz)^2); %distance between electrode and fiber
p= 0.3; %conductivity
Ve = (p .* stim_I) ./ 4*pi*r  ;
end

