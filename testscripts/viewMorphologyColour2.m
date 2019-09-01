function [figureHandle] = viewMorphologyColour(NP,v_m,offset)
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
hold on;
%cmap = colormap(jet(1000));
%maplength = length(cmap);

% stimloc(1) = 100+offset;
% stimloc(2) = 0;
% stimloc(3) = 500;

minv = min(min(v_m));
maxv = max(max(v_m));
norm_vm = (v_m -minv)./(maxv-minv);
%scaled_vm = round(norm_vm * (length(cmap)-1))+1;

for iComp = 1:NP.numCompartments
  plot3(NP.compartmentXPositionMat(iComp,:), ...
        NP.compartmentYPositionMat(iComp,:), ...
        NP.compartmentZPositionMat(iComp,:), ...
        'Color',[0, (v_m(iComp)+3)/10, 0,], ...
        'LineWidth',NP.compartmentDiameterArr(iComp)*3);
end
if isfield(NP,'TissueParams')
    if isfield(NP.TissueParams,'StimulationField')
        if isa(NP.TissueParams.StimulationField, 'pde.StationaryResults')
        else
            %disp('Showing stim location')
            %stimloc = NP.TissueParams.StimulationField;
            %scatter3(stimloc(1), stimloc(2), stimloc(3),70,'k','filled'); 
        end
        
    end
end
colorbar
%caxis([minv maxv])
%caxis([-min 30])
set(gcf,'color','w');
set(gca,'YDir','reverse');
set(gca,'TickDir','out');

fsize = 16;
title('Neuron Morphology', 'FontSize', fsize);
xlabel('x (micrometres)', 'FontSize', fsize);
ylabel('y (micrometres)', 'FontSize', fsize);
zlabel('z (micrometres)', 'FontSize', fsize);
set(gca, 'FontSize', fsize);
daspect([1 1 1])
view([0, 0]);
