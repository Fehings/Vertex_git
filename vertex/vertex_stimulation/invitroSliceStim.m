function [ result, model ] = invitroSliceStim(geometryloc,stimstrength)
%invitroSliceStim Loads the gemortry and calculates the 

if nargin < 2
    stimstrength = -1; %give a default if stimstrength isn't given as an argument
end

model = createpde;
importGeometry(model,geometryloc);

disp(model.IsTimeDependent)
%Outer, insulating boundaries
applyBoundaryCondition(model,'face',2:5,'g',0.0,'q',0.0); % for the
%initial point stimulation stl
%applyBoundaryCondition(model,'face',[2 5 3 6],'g',0.0,'q',0.0);

%Electrode-tissue boundary

if isequal(geometryloc,'chrismodelmod9.stl') 
    applyBoundaryCondition(model,'face',[9,14:17],'h',1.0,'r',stimstrength); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[7,10:13],'h',1.0,'r',-stimstrength); % also vary it for this one!
elseif isequal(geometryloc,'topbottomstim4.stl') 
    applyBoundaryCondition(model,'face',[1],'h',1.0,'r',stimstrength); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[6],'h',1.0,'r',-stimstrength); % also vary it for this one!
elseif isequal(geometryloc,'topbottomstim2.stl')
    applyBoundaryCondition(model,'face',[3:6],'g',0.0,'q',0.0); % the outer model boundarys have no change in electric current, so it is always zero here and beyond?
    applyBoundaryCondition(model,'face',[7,8,15:19],'h',1.0,'r',stimstrength); %the 'r' 5.0 sets up a 5(mv?) voltage here
    applyBoundaryCondition(model,'face',[1,2,9:14],'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc,'sidesidestim2.stl')
    applyBoundaryCondition(model,'face',[1:19],'g',0.0,'q',0.0); % the outer model boundarys have no change in electric current, so it is always zero here and beyond?
    applyBoundaryCondition(model,'face',5,'h',1.0,'r',stimstrength); %the 'r' 5.0 sets up a 5(mv?) voltage here
    applyBoundaryCondition(model,'face',3,'h',1.0,'r',-stimstrength);
else % boundaries for the default point stimulation geometry
    applyBoundaryCondition(model,'face',[8,9],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[10,11],'h',1.0,'r',-stimstrength);
end


specifyCoefficients(model,'m',0, 'd',0, 'c',0.2, 'a',0, 'f',0);



generateMesh(model);
disp(model.IsTimeDependent)
result = solvepde(model);
%  u = result.NodalSolution;
%  figure(1)
%  pdeplot3D(model,'ColorMapData', u);

end

