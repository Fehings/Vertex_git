function [ Ve ] = pointstim( fiberposition)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
stim_I = (-500 *10^-6);
fiberx = fiberposition(1);
fibery = fiberposition(2);
fiberz = fiberposition(3);
stimx = 100;
stimy = 0;
stimz = 500;
r = (fiberx - stimx)^2 + (fibery - stimy)^2 + (fiberz - stimz)^2; %distance between electrode and fiber
p= 0.3; %conductivity
Ve = p .* stim_I ./ 4*pi*r  ;
end

