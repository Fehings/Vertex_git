function [ result, model ] = invitroSliceStim(geometryloc)
%invitroSliceStim Loads the gemortry and calculates the 
model = createpde;
importGeometry(model,geometryloc);

disp(model.IsTimeDependent)
%Outer, insulating boundaries
applyBoundaryCondition(model,'face',1:8,'g',0.0,'q',0.0); % for the
%initial point stimulation stl
%applyBoundaryCondition(model,'face',[2 5 3 6],'g',0.0,'q',0.0);

%Electrode-tissue boundary

if isequal(geometryloc,'chrismodelmod9.stl') 
    applyBoundaryCondition(model,'face',[9,14:17],'h',1.0,'r',50); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[7,10:13],'h',1.0,'r',-50); % also vary it for this one!
elseif isequal(geometryloc,'topbottomstim.stl') 
    applyBoundaryCondition(model,'face',[7,8,15:19],'h',1.0,'r',50); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[1,9:14],'h',1.0,'r',-50); % also vary it for this one!
else % boundaries for the default point stimulation geometry
    applyBoundaryCondition(model,'face',[8,9],'h',1.0,'r',5000.0);
    applyBoundaryCondition(model,'face',[10,11],'h',1.0,'r',-5000.0);
end


specifyCoefficients(model,'m',0, 'd',0, 'c',0.2, 'a',0, 'f',0);



generateMesh(model);
disp(model.IsTimeDependent)
result = solvepde(model);
 u = result.NodalSolution;
 pdeplot3D(model,'ColorMapData', u);

end

