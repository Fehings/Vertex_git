function [figureHandle] = viewMorphologyX(NP,cmap)
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

hold on;
for iComp = 1:NP.numCompartments
  plot(NP.compartmentXPositionMat(iComp,:), ...
        NP.compartmentZPositionMat(iComp,:), ...
        'Color',cmap(iComp,:), ...
        'LineWidth',NP.compartmentDiameterArr(iComp));
end


set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);

% title('Neuron Morphology', 'FontSize', fsize);
% xlabel('x (micrometres)', 'FontSize', fsize);
% ylabel('y (micrometres)', 'FontSize', fsize);
% zlabel('z (micrometres)', 'FontSize', fsize);
daspect([1 1 1])
hold off;
