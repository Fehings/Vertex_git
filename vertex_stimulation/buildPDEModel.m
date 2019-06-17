function [outputArg1,outputArg2] = buildBipolarElectrodePDEModel(model,outerfaces, electrode1)
%buildPDEModel Constructs a PDEmodel geometry from the 
%   Detailed explanation goes here

model = createpde;
importGeometry(model,geometryloc);
applyBoundaryCondition(model,'face',5:11,'g',0.0,'q',0.0);
applyBoundaryCondition(model,'face',[3,4,14,15,16],'h',1.0,'r',stimstrength);
applyBoundaryCondition(model,'face',[1,13,12,17,2],'h',1.0,'r',-stimstrength);

end

