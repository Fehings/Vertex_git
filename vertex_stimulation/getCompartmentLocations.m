function [ compartmentPositions ] = getCompartmentLocations(NeuronArr, SS, TP,NeuronIDs )
N = TP.N;
if nargin >= 4
    neuronInThisLab = NeuronIDs;
elseif SS.parallelSim
    neuronInThisLab = find(SS.neuronInLab == labindex);
else
    neuronInThisLab = 1:N;
end

somaPositionMat = TP.somaPositionMat(:, 1:3);

neuronInGroup = ...
    createGroupsFromBoundaries(TP.groupBoundaryIDArr);

for ii = 1:length(neuronInThisLab)
    iNeuron = neuronInThisLab(ii);
    iGroup = neuronInGroup(iNeuron);
    numCompartments = NeuronArr(iGroup).numCompartments;
    if numCompartments > 1
        somaPosition = somaPositionMat(iNeuron, :);
        if ~isfield(NeuronArr(iGroup), 'axisAligned')
            rot = TP.rotationAngleMat(iNeuron, :);
        elseif strcmpi(NeuronArr(iGroup).axisAligned, 'x')
            rot = [TP.rotationAngleMat(iNeuron, 1) 0 0];
        elseif strcmpi(NeuronArr(iGroup).axisAligned, 'y')
            rot = [0 TP.rotationAngleMat(iNeuron, 2) 0];
        elseif strcmpi(NeuronArr(iGroup).axisAligned, 'z')
            rot = [0 0 TP.rotationAngleMat(iNeuron, 3)];
        else
            rot = TP.rotationAngleMat(iNeuron, :);
        end
        xPos = NeuronArr(iGroup).compartmentXPositionMat(:, :);
        yPos = NeuronArr(iGroup).compartmentYPositionMat(:, :);
        zPos = NeuronArr(iGroup).compartmentZPositionMat(:, :);
        
        for iCompartment = 1:numCompartments
            xyzNewBottom = rotate3DCoordinates( [xPos(iCompartment, 1) ...
                yPos(iCompartment, 1) zPos(iCompartment, 1)], ...
                rot(1), rot(2), rot(3)) + somaPosition(:);
            xyzNewTop = rotate3DCoordinates( [xPos(iCompartment, 2) ...
                yPos(iCompartment, 2) zPos(iCompartment, 2)], ...
                rot(1), rot(2), rot(3)) + somaPosition(:);
            xPos(iCompartment, :) = [xyzNewBottom(1) xyzNewTop(1)];
            yPos(iCompartment, :) = [xyzNewBottom(2) xyzNewTop(2)];
            zPos(iCompartment, :) = [xyzNewBottom(3) xyzNewTop(3)];
        end
        
        compartmentPositions{iNeuron, 1} = xPos;
        compartmentPositions{iNeuron, 2} = yPos;
        compartmentPositions{iNeuron, 3} = zPos;
        
    end
    
    
    
end

