function [SS] = checkSimulationStruct(SS)

%% Check required fields in Simulation parameters
if ~isfield(SS, 'ef_stimulation')
    SS.ef_stimulation = false;
end
if ~isfield(SS, 'fu_stimulation')
    SS.fu_stimulation = false;
end
requiredFields = {'simulationTime','timeStep', 'parallelSim'};
requiredClasses = {'double', 'double', 'logical'};
requiredDimensions = {[1 1], [1 1], [1 1]};

checkStructFields(SS, requiredFields, requiredClasses, requiredDimensions);
