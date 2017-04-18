function [ result, model ] = invitroSliceStim(geometryloc,stimstrength)
%invitroSliceStim Loads the gemortry and calculates the 

if nargin < 2
    stimstrength = -1; %give a default if stimstrength isn't given as an argument
    error('stim strength not set')
    
end

model = createpde;
importGeometry(model,geometryloc);

% figure(1)
% pdegplot(model,'FaceLabels', 'on')

%figure(1)
pdegplot(model,'FaceLabels', 'on')

disp(model.IsTimeDependent)
%Outer, insulating boundaries
applyBoundaryCondition(model,'face',1:6,'g',0.0,'q',0.0); % for the
%initial point stimulation stl
%applyBoundaryCondition(model,'face',[2 5 3 6],'g',0.0,'q',0.0);

%Electrode-tissue boundary

if isequal(geometryloc,'chrismodelmod9.stl') 
    applyBoundaryCondition(model,'face',[9,14:17],'h',1.0,'r',stimstrength); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[7,10:13],'h',1.0,'r',-stimstrength); % also vary it for this one!
elseif isequal(geometryloc, 'catvisblend1.stl') || isequal(geometryloc, 'bsf.stl')
    applyBoundaryCondition(model,'face',1:6,'g',0.0,'q',0.0); % the outer model boundarys have no change in electric current, so it is always zero here and beyond?
    applyBoundaryCondition(model,'face',1,'h',1.0,'r',stimstrength); %the 'r' 5.0 sets up a 5(mv?) voltage here
    applyBoundaryCondition(model,'face',2,'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc,'largemod1.stl') || isequal(geometryloc,'largemod2.stl')
    applyBoundaryCondition(model,'face',[2],'h',1.0,'r',stimstrength); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[1],'h',1.0,'r',-stimstrength); % also vary it for this one!
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
elseif isequal(geometryloc, 'farapartlectrodesbig.stl')
    applyBoundaryCondition(model,'face',[2,11,12,1,16],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[4,14,3,13,15],'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc, 'layer4stim.stl')
elseif isequal(geometryloc, 'catvisblend1.stl')
    applyBoundaryCondition(model,'face',[2],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[1],'h',1.0,'r',-stimstrength);
    applyBoundaryCondition(model,'face',[3:6],'g',0.0,'q',0.0);
else % boundaries for the default point stimulation geometry
    applyBoundaryCondition(model,'face',[2,11,12,1,16],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[4,14,3,13,15],'h',1.0,'r',-stimstrength);
end

disp(model.IsTimeDependent)

%conductivity of brain tissue is around 0.3 S m^-1 
%As vertex is in units of micrometers c --> 0.3/1000000
specifyCoefficients(model,'m',0, 'd',0, 'c',0.3/1000000, 'a',0, 'f',0);



generateMesh(model);
disp(model.IsTimeDependent)
result = solvepde(model);

%  u = result.NodalSolution;
%  figure(2)
%  pdeplot3D(model,'ColorMapData', result.NodalSolution, 'FaceAlpha', 0.2);

 u = result.NodalSolution;

  pdeplot3D(model,'ColorMapData', result.NodalSolution, 'FaceAlpha', 0.2);

%  figure(3)
% [X,Y,Z] = meshgrid(0:100:2600,0:100:1800,0:100:700);
% V = interpolateSolution(result,X,Y,Z);
% V = reshape(V,size(X));
% figure
% colormap jet

% contourslice(X,Y,Z,V,1:100:2600,1:100:00,1:100:700)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% colorbar
% view(-11,14)
% axis equal
% end
% 

% contourslice(X,Y,Z,V,1:10:1000,1:10:1800,1:10:700)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% 
% colorbar
view(-11,14)
axis equal

end
