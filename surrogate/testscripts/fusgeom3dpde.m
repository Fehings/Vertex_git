model = createpde;
importGeometry(model,'demobox.stl');
h = pdegplot(model,'FaceLabels','on');
%%
%%
%disp(model.IsTimeDependent)
%Outer, insulating boundaries
applyBoundaryCondition(model,'face',1:10,'g',0.0,'q',0.0); % the outer model boundarys have no change in electric current, so it is always zero here and beyond? 
%applyBoundaryCondition(model,'face',[2 5 3 6],'g',0.0,'q',0.0);
%disp(model.IsTimeDependent)

%Electrode-tissue boundary
applyBoundaryCondition(model,'face',[11,12],'h',1.0,'r',1/57E6); %the 'r' 1.0 sets up a 1(mv?) voltage here
applyBoundaryCondition(model,'face',[13,14],'h',1.0,'r',-1.0); %the 'r' -1.0 sets up a -1 (mv?) voltage at this electrode. 
% the two opposing currents set up the electric field. If this can be time
% varying then this would be potentially how to make tACS and tRNS. Could
% also have the inputs multiplied by a parameter to control the voltage
% input from another script or location for ease of modification.
disp(model.IsTimeDependent)


mu=1.26*pi*1e-6; % magnetic permeability 1.26*pi*1e-6?

% the coefficients modify the equation being solved. m and d being
% zero makes this time independent. 
specifyCoefficients(model,'m',0, 'd',0, 'c',1/mu, 'a',@acoeffun, 'f',0);
%%2*pi*504*pi*1E-7

disp(model.IsTimeDependent)
generateMesh(model);
disp(model.IsTimeDependent)
result = solvepde(model);

 u = result.NodalSolution; % so u is the solution
 
 [X,Y,Z] = meshgrid(-8:10,-3:1,-2:10);
 V = interpolateSolution(result,X,Y,Z);
V = reshape(V,size(X));

pdeplot3D(model,'ColorMapData', u);

% figure
% colormap jet
% contourslice(X,Y,Z,V,[],-3:1)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% colorbar
% axis equal


function acoeff = acoeffun(~,state)

omega=2*pi*50; % angular frequency
sigma=57e6; % conductivity, 57e6 is copper conductivity, so this needs changing for the brain!
epsilon=8.8e-12; % coeff of dielectricity
j=state.u.*sigma; % current density... which can be found by u*sigma. Making this nonlinear, as u is the solution.
acoeff=j.*omega*sigma-(omega^2)*epsilon;
end


