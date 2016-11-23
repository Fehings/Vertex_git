function [ result, model ] = invitroSliceStim(geometryloc)
%invitroSliceStim Loads the gemortry and calculates the 
model = createpde;
importGeometry(model,geometryloc);
pdegplot(model,'FaceLabels', 'on')
disp(model.IsTimeDependent)
%Outer, insulating boundaries
applyBoundaryCondition(model,'face',1:8,'g',0.0,'q',0.0); % for the
%initial point stimulation stl
%applyBoundaryCondition(model,'face',[2 5 3 6],'g',0.0,'q',0.0);
disp(model.IsTimeDependent)

%Electrode-tissue boundary

if isequal(geometryloc,'chrismodelmod9.stl') 
    applyBoundaryCondition(model,'face',[9,14:17],'h',1.0,'r',0.6);
    applyBoundaryCondition(model,'face',[7,10:13],'h',1.0,'r',-0.6);
else % boundaries for the default point stimulation geometry
    applyBoundaryCondition(model,'face',[8,9],'h',1.0,'r',5000.0);
    applyBoundaryCondition(model,'face',[10,11],'h',1.0,'r',-5000.0);
end

disp(model.IsTimeDependent)


specifyCoefficients(model,'m',0, 'd',0, 'c',0.2, 'a',0, 'f',0);


disp(model.IsTimeDependent)
generateMesh(model);
disp(model.IsTimeDependent)
result = solvepde(model);
 u = result.NodalSolution;
 pdeplot3D(model,'ColorMapData', u);

end

