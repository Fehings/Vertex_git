function [result,model] = buildBipolarElectrodeModel(model,outerfaces,annode,cathode,strength)
%buildPDEModel Constructs a PDEmodel geometry from the 
%   Detailed explanation goes here


applyBoundaryCondition(model,'face',outerfaces,'g',0.0,'q',0.0);
applyBoundaryCondition(model,'face',annode,'h',1.0,'r',0);
applyBoundaryCondition(model,'face',cathode,'h',1.0,'r',-strength);
specifyCoefficients(model,'m',0, 'd',0, 'c',0.3e-6, 'a',0, 'f',0);
%generate the model
generateMesh(model);
%solve the pde
result = solvepde(model);
end

