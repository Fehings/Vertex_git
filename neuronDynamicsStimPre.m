function [NParams] = neuronDynamicsStimPre(NeuronParams,TP,rotate)
NParams = NeuronParams;
if nargin == 2
    rotate = 0;
end
if isfield(NParams, 'minCompartmentSize')
    adjustedcompartments = true;
    % Adjusts the number and size of compartments to ensure that the
    % electric field calculations remain valid. Caution should be advised
    % that this can drastically increase the size of the simulation.
    Nparams = adjustCompartments(NParams, TP);
    NParams = Nparams;

end

NParams = calculatePassiveProperties(NParams, TP);

SS.parallelSim = false;
if rotate
    TP.somaPositionMat = [0 0 0];
    TP.rotationAngleMat = [0 rotate 0 ];
    TP.groupBoundaryIDArr = [0 1];
    compartments = getCompartmentLocations(NParams, SS, TP, 1);
    NParams.compartmentXPositionMat = compartments{1,1};
    NParams.compartmentYPositionMat= compartments{1,2};
    NParams.compartmentZPositionMat = compartments{1,3};
else
    compartments{1,1} = NParams.compartmentXPositionMat;
    compartments{1,2} = NParams.compartmentYPositionMat;
    compartments{1,3} = NParams.compartmentZPositionMat;
end
iGroup = 1;
[compartmentlocations{iGroup,1}, compartmentlocations{iGroup,2}] = ...
    convertcompartmentlocations({compartments{1,1}},...
    {compartments{1,2}},{compartments{1,3}});
point1 = compartmentlocations{iGroup,1};
point2 = compartmentlocations{iGroup,2};
%get the mid points of the compartments
midpoints = zeros(3,length(point1.x(:,1)),length(point1.x(1,:)));
midpoints(1,:,:) = (point1.x + point2.x)./2;
midpoints(2,:,:) = (point1.y + point2.y)./2;
midpoints(3,:,:) = (point1.z + point2.z)./2;

NParams.midpoints = midpoints;



end

