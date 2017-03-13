function [ Ve ] = pointstim( fiberposition, stimposition,stim_I)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
fiberx = fiberposition(1);
fibery = fiberposition(2);
fiberz = fiberposition(3);
stimx = stimposition(1);
stimy = stimposition(2);
stimz = stimposition(3);
r = (fiberx - stimx)^2 + (fibery - stimy)^2 + (fiberz - stimz)^2; %distance between electrode and fiber
p= 0.3; %conductivity
Ve = p .* stim_I ./ 4*pi*r  ;
end

