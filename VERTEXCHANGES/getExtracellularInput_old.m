function [ activation ] = getExtracellularInput(TP, StimParams)
%Returns a matrix representing the potential change at each compartment
%given the PDE solution and locations of the compartments. Uses the
%activation function.


F = pdeInterpolant(TP.StimulationField{1},TP.StimulationField{2},TP.StimulationField{3}); 
% evaluate the FEM solution, where StimulationField values are taken from
% an FEM output, p t and u and assigned when setting up the model.
activation = cell(TP.numGroups,1); % preassign blank cell?


for iGroup = 1:TP.numGroups % for each group
    point1 = StimParams.compartmentlocations{iGroup,1}; % The compartmentlocations  are assigned in stimulate using converteCompartmentLocations
    point2 = StimParams.compartmentlocations{iGroup,2};

    
    numcompartments = length(point1.x(:,1));

    for iComp = 1:numcompartments % for each compartment
        activation{iGroup}(iComp,:) = activationfunction([point1.x(iComp,:);point1.z(iComp,:)] ,...
            [point2.x(iComp,:); point2.z(iComp,:)],...
           F); % fill in the cells of activation with, presumably, the solutions from the FEM at each compartment, though I'm not sure how this does that.
    end
end

end

