function [ result, model ] = invitroSliceStim(geometryloc)
%invitroSliceStim Loads the gemortry and calculates the 
model = createpde;
importGeometry(model,geometryloc);
figure(1)
pdegplot(model,'FaceLabels', 'on')
disp(model.IsTimeDependent)
%Outer, insulating boundaries
applyBoundaryCondition(model,'face',5:11,'g',0.0,'q',0.0); % for the
%initial point stimulation stl
%applyBoundaryCondition(model,'face',[2 5 3 6],'g',0.0,'q',0.0);
disp(model.IsTimeDependent)

%Electrode-tissue boundary

if isequal(geometryloc,'chrismodelmod9.stl') 
    applyBoundaryCondition(model,'face',[9,14:17],'h',1.0,'r',0.6);
    applyBoundaryCondition(model,'face',[7,10:13],'h',1.0,'r',-0.6);
else % boundaries for the default point stimulation geometry
     applyBoundaryCondition(model,'face',[1,2],'h',1.0,'r',100000.0);
     applyBoundaryCondition(model,'face',[3,4],'h',1.0,'r',-100000.0);
end

disp(model.IsTimeDependent)

%conductivity of brain tissue is around 0.3 S m^-1 
%As vertex is in units of micrometers c --> 0.3/1000000
specifyCoefficients(model,'m',0, 'd',0, 'c',0.3/1000000, 'a',0, 'f',0);

% 
figure(2)
disp(model.IsTimeDependent)
generateMesh(model);
disp(model.IsTimeDependent)
result = solvepde(model);
 u = result.NodalSolution;
 pdeplot3D(model,'ColorMapData', u);

end

