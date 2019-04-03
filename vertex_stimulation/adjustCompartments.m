function [ NeuronParams ] = adjustCompartments( NeuronParams, tp )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
tp.numGroups = 1;
NParams = calculatePassiveProperties(NeuronParams, tp);
[l,d] = getDimensionsInCentimetres(NParams);

NParams.spaceconstant = (sqrt(d./(4.*(NParams.R_A).*(NParams.g_l.*10^-9).^(1/2))))*1000;

% space constant determines how many we have and their size. 
% default is sqrt(d./4.*(NParams.R_A/1000).*(NParams.g_l))*100
% according to Rattay this would be better divided by 4!

NeuronParams.spaceconstant = NParams.spaceconstant;

while sum(NeuronParams.compartmentLengthArr > NeuronParams.spaceconstant*NParams.minCompartmentSize)>0
    NeuronParams = decreaseCompartmentLength(NeuronParams);
    NParams = calculatePassiveProperties(NeuronParams, tp);
    [l,d] = getDimensionsInCentimetres(NParams);
    NParams.spaceconstant = (sqrt(d./(4.*(NParams.R_A).*(NParams.g_l.*10^-9).^(1/2))))*1000;
    NeuronParams.spaceconstant = NParams.spaceconstant;
end

%disp(['Mean compartment length:' num2str(mean(NeuronParams.compartmentLengthArr))]);
%disp(['Number of compartments: ' num2str(length(NeuronParams.compartmentLengthArr))]);
end

