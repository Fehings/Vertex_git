function [figureHandle] = viewMorphologyEditor(NP, selection)
%VIEWMORPHOLOGY Plots a neuron's morphology.
%   VIEWMORPHOLOGY(NP) creates a 3D plot of a neuron's compartmental
%   structure in a new figure window. NP is the structure containing that
%   neuron's group parameters.
%
%   FIGUREHANDLE = VIEWMORPHOLOGY(NP) also returns the handle ID of the
%   created figure.
%
%   % Example: we have 6 neuron groups, with parameters specified in the
%   % NeuronParams structure array. To plot the morphology of neurons in
%   % group 6, we do:
%   viewMorphology(NeuronParams(6));

%figureHandle = figure();
colours = zeros(3,NP.numCompartments);
if nargin == 2
    colours(:,selection) = [0.7 0 0.7];
end
if isfield(NP, 'axon_ID') && length(NP.axon_ID) > 0
    for i = NP.axon_ID'
        colours(:,i) = [0.1 0.9 0.5];
    end
end
hold on;

for iComp = 1:NP.numCompartments
  l = plot3(NP.compartmentXPositionMat(iComp,:), ...
        NP.compartmentYPositionMat(iComp,:), ...
        NP.compartmentZPositionMat(iComp,:), ...
        'Color',colours(:,iComp), ...
        'LineWidth',NP.compartmentDiameterArr(iComp));
    l.Tag = num2str(iComp);
end

set(gcf,'color','w');
set(gca,'YDir','reverse');
set(gca,'TickDir','out');

fsize = 16;
title('Neuron Morphology', 'FontSize', fsize);
xlabel('x (micrometres)', 'FontSize', fsize);
ylabel('y (micrometres)', 'FontSize', fsize);
zlabel('z (micrometres)', 'FontSize', fsize);
set(gca, 'FontSize', fsize);
xmax = (max(max(NP.compartmentXPositionMat))+max(max(NP.compartmentXPositionMat))/2)+10;
xmin =  (min(min(NP.compartmentXPositionMat))- abs(min(min(NP.compartmentXPositionMat))/2))-10;

disp([xmin xmax])
xlim([xmin xmax]);
zmax = (max(max(NP.compartmentZPositionMat))+max(max(NP.compartmentZPositionMat))/2)+10;
zmin = (min(min(NP.compartmentZPositionMat))- abs(min(min(NP.compartmentZPositionMat))/2))-10;
xlim([xmin xmax]);
zlim([zmin zmax]);

view([0, 0]);
daspect([1 1 1])