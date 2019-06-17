function [figureHandle] = viewMorphology(NP, selection)
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
    for i_s = selection
        colours(:,i_s) = [0.7 0 0.7];
    end
elseif isfield(NP, 'grouping')
    uniqGroup = unique(NP.grouping);
    cmap = hsv(length(uniqGroup));
    for i_comp = 1:length(NP.grouping)
        colours(:,i_comp) = cmap(uniqGroup==NP.grouping(i_comp),:);
    end
end
if isfield(NP, 'axon_id')
    colours(:,NP.axon_id) = [0.1 0.9 0.5];
end

hold on;

for iComp = 1:NP.numCompartments
  l = plot3(NP.compartmentXPositionMat(iComp,:), ...
        NP.compartmentYPositionMat(iComp,:), ...
        NP.compartmentZPositionMat(iComp,:), ...
        'Color',colours(:,iComp), ...
        'LineWidth',NP.compartmentDiameterArr(iComp));
    l.Tag = ['comp' num2str(iComp)];
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

view([0, 0]);
daspect([1 1 1])