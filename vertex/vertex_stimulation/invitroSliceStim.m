function [ result, model ] = invitroSliceStim(geometryloc)
%invitroSliceStim Loads the gemortry and calculates the 
model = createpde;
importGeometry(model,geometryloc);

disp(model.IsTimeDependent)
%Outer, insulating boundaries
applyBoundaryCondition(model,'face',1:8,'g',0.0,'q',0.0);
%applyBoundaryCondition(model,'face',[2 5 3 6],'g',0.0,'q',0.0);
disp(model.IsTimeDependent)

%Electrode-tissue boundary
applyBoundaryCondition(model,'face',[8,9],'h',1.0,'r',5000.0);
applyBoundaryCondition(model,'face',[10,11],'h',1.0,'r',-5000.0);

disp(model.IsTimeDependent)


specifyCoefficients(model,'m',0, 'd',0, 'c',1, 'a',0, 'f',0);


disp(model.IsTimeDependent)
generateMesh(model);
disp(model.IsTimeDependent)
result = solvepde(model);
 u = result.NodalSolution;
 pdeplot3D(model,'ColorMapData', u);

end

