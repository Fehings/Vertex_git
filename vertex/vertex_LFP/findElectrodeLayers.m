function [electrodeInLayer] = findElectrodeLayers(Results)
% The output that is a vector showing the layer the electrodes are in, so
% electrode 1 is in layer 6 the first value (corresponding to the first
% electrode) will be 6.
% 0 indicates no layer.

%optional flag/ follow on script to plot the lfp averaged by layer

% find the layer boundary Z coords
bounds = fliplr(Results.params.TissueParams.layerBoundaryArr);

% find the electrode positions
ePosit=generateElectrodePositions(Results.params.RecordingSettings.meaXpositions,Results.params.RecordingSettings.meaYpositions,Results.params.RecordingSettings.meaZpositions);

% preassign output vector
electrodeInLayer = zeros(length(ePosit),1); 

for i = length(bounds):-1:1
    electrodeInLayer(ePosit(:,3)<bounds(i))=i;
    
    if any(ePosit(:,3)==bounds(i))
        disp('be aware: there are electrodes right on the boundary of layer: ')
        disp(i)
    end
end

if bounds(i)==0 % if the lower bound is zero (which it generally is) then shift the electrodeInLayer values down by 1, as they will be offset.
    electrodeInLayer = electrodeInLayer-1;
end
    


if any(electrodeInLayer==0)
   disp('Warning: You have electrodes outside of the tissue boundaries. The electrode layer number for these outliers has been set to zero.')
end

end





