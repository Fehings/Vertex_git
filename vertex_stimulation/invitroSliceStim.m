function [ result, model ] = invitroSliceStim(geometryloc,stimstrength)
%invitroSliceStim Loads the geometry and calculates the electric field

if nargin < 2
    stimstrength = -1; %give a default if stimstrength isn't given as an argument
    error('stim strength not set')  
end

model = createpde;
importGeometry(model,geometryloc);


% Specify the boundary conditions
% We have specified conditions for many models here, if you add a new model
% then add a new condition to out wonderfully large if then elseif
% construct. (Should really have used a switch statement :P)

if isequal(geometryloc,'chrismodelmod9.stl') 
    applyBoundaryCondition(model,'face',[9,14:17],'h',1.0,'r',stimstrength); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[7,10:13],'h',1.0,'r',-stimstrength); % also vary it for this one!
elseif isequal(geometryloc, 'catvisblend1.stl') || isequal(geometryloc, 'bsf.stl') || isequal(geometryloc, 'tutorial2_3.stl')
    applyBoundaryCondition(model,'face',1:6,'g',0.0,'q',0.0); % the outer model boundarys have no change in electric current, so it is always zero here and beyond?
    applyBoundaryCondition(model,'face',2,'h',1.0,'r',stimstrength); %the 'r' 5.0 sets up a 5(mv?) voltage here
    applyBoundaryCondition(model,'face',1,'h',1.0,'r',-stimstrength);
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
  applyBoundaryCondition(model,'face',3:17,'g',0.0,'q',0.0);
    applyBoundaryCondition(model,'face',[3,4,16,17,18],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[1,2,14,15,19],'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc, '6layermodelstiml4placedin.stl')
  applyBoundaryCondition(model,'face',5:12,'g',0.0,'q',0.0);
    applyBoundaryCondition(model,'face',[3,4,15,16,17],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[1,13,18,14,2],'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc, '6layermodelstiml4placedin3000.stl')
    % dimensions of electrode in tissue: 14 * 14 * 200
    % Volume: 39200 microns^3
    % Position: x = 1160.25 - 1150 z = 1258.5 - 1269 y = 40.5 - 500
  applyBoundaryCondition(model,'face',5:12,'g',0.0,'q',0.0);
    applyBoundaryCondition(model,'face',[3,4,15,16,17],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[1,13,18,14,2],'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc, '6layermodelstiml4placedinsmall.stl')
    % dimensions of electrode in tissue: 14 * 14 * 200
    % Volume: 39200 microns^3
    % Position: x = 1160.25 - 1150 z = 1258.5 - 1269 y = 40.5 - 500
  applyBoundaryCondition(model,'face',5:12,'g',0.0,'q',0.0);
    applyBoundaryCondition(model,'face',[3,4,15,16,17],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[1,13,18,14,2],'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc, '6layermodelstiml4placedinwithbacktrueunits.stl')
    % dimensions of electrode in tissue: 14 * 14 * 200
    % Volume: 39200 microns^3
    % Position: x = 1160.25 - 1150 z = 1258.5 - 1269 y = 40.5 - 500
  applyBoundaryCondition(model,'face',[2 6:21],'g',0.0,'q',0.0);
    applyBoundaryCondition(model,'face',[23,27,22,1,3],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[24,25,26,4,5],'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc, '6layermodelstiml4placedinnobacktrueunits.stl')
    % dimensions of electrode in tissue: 14 * 14 * 200
    % Volume: 39200 microns^3
    % Position: x = 1160.25 - 1150 z = 1258.5 - 1269 y = 40.5 - 500
  applyBoundaryCondition(model,'face',[2 6:14],'g',0.0,'q',0.0);
    applyBoundaryCondition(model,'face',[16,20,15,1,3],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[18,17,19,4,5],'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc, '6layermodelstiml23in.stl')
    % dimensions of electrode in tissue: 14 * 14 * 200
    % Volume: 39200 microns^3
    % Position: x = 1160.25 - 1150 z = 1258.5 - 1269 y = 40.5 - 500
  applyBoundaryCondition(model,'face',5:11,'g',0.0,'q',0.0);
    applyBoundaryCondition(model,'face',[3,4,15,17,16],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[1,13,18,14,2],'h',1.0,'r',-stimstrength);
elseif isequal(geometryloc, '6layermodelstiml56in.stl')
    % dimensions of electrode in tissue: 14 * 14 * 200
    % Volume: 39200 microns^3
    % Position: x = 1160.25 - 1150 z = 1258.5 - 1269 y = 40.5 - 500
  applyBoundaryCondition(model,'face',5:11,'g',0.0,'q',0.0);
    applyBoundaryCondition(model,'face',[3,4,14,15,16],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[1,13,12,17,2],'h',1.0,'r',-stimstrength);
else % boundaries for the default point stimulation geometry
    applyBoundaryCondition(model,'face',[2,11,12,1,16],'h',1.0,'r',stimstrength);
    applyBoundaryCondition(model,'face',[4,14,3,13,15],'h',1.0,'r',-stimstrength);
end

disp(model.IsTimeDependent)

%conductivity of brain tissue is around 0.3 S m^-1 
specifyCoefficients(model,'m',0, 'd',0, 'c',0.3e-6, 'a',0, 'f',0);


%generate the model
generateMesh(model);

%solve the pde
result = solvepde(model);




%   figure(3)
%  [X,Y,Z] = meshgrid(0:100:2600,300,0:100:2000);
%  V = interpolateSolution(result,X,Y,Z);
%  V = reshape(V,size(X));
% figure
% colormap jet
% contourslice(X,Y,Z,V,1:100:1000,1:10:1800,1:100:700)


% contourslice(X,Y,Z,V,1:100:2600,1:100:00,1:100:700)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% colorbar
% view(-11,14)
% axis equal
% end
% 

%contourslice(X,Y,Z,V,1:10:1000,1,500:10:1500)



end
