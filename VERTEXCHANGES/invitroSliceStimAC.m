function [ result, model ] = invitroSliceStimAC(geometryloc,dt,stimstrength,B)
%invitroSliceStimAC Loads the gemortry and calculates the electric field at
%points in the automated mesh of the given geometry. It is designed for
%alternating current and so is time dependent and calculates the solutions
%for one oscillation period, from 0:dt:2*pi/abs(B)
%This function requires a geometry and a timestep which should be the same
%as the one assigned to SimulationSettings.timeStep, so that the correct
%solution is given at each point in time the overall Vertex model is
%solving for. stimstrength and B are optional parameters for varying the AC
%field. 
%NB: for geometries not already given default locations in the boundaries
%section below, you will need to identify where the boundary conditions
%need to be applied first, and then add them to the section below. This can
%be done by decommenting and running the below section of code for a given geometry.

%% For testing geometries, run this with the 'run section' command, or by pasting to command line.

% model = createpde(); % initialise blank pde model
% importGeometry(model,'yourgeomhere.stl'); % importing stl geometry from within current path, or give .stl file a full path name. Pass this to 'model'
% h = pdegplot(model,'FaceLabels','on','FaceAlpha',0.5); % set up plotting parameters and plots geometry to check face labels


%%

if nargin < 3
      stimstrength = 1; %give a default if stimstrength isn't given as an argument
end

if nargin < 4
     B=1; % B controls the oscillation frequency. Set to 1 as default.
end

B=B/1000; % because vertex deals with miliseconds, so this needs to be converted to miliseconds to actually give the right value in Hz

model = createpde;
importGeometry(model,geometryloc);


%Outer, insulating boundaries
applyBoundaryCondition(model,'face',3:6,'g',0.0,'q',0.0); % for the
%initial point stimulation stl

%Electrode-tissue boundary
%%

if isequal(geometryloc,'chrismodelmod9.stl') 
    applyBoundaryCondition(model,'face',[9,14:17],'h',1.0,'r',@myrfun); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[7,10:13],'h',1.0,'r',@myrfun2); % also vary it for this one!
elseif isequal(geometryloc,'catvisblend1.stl') || isequal(geometryloc,'largemod2.stl')
    applyBoundaryCondition(model,'face',[2],'h',1.0,'r',@myrfun); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[1],'h',1.0,'r',@myrfun2); % also vary it for this one!
elseif isequal(geometryloc,'topbottomstim4.stl') 
    applyBoundaryCondition(model,'face',[1],'h',1.0,'r',@myrfun); % r value is the input in mv. This is what to vary to change field strenght
    applyBoundaryCondition(model,'face',[6],'h',1.0,'r',@myrfun2); % also vary it for this one!
elseif isequal(geometryloc,'topbottomstim2.stl')
    applyBoundaryCondition(model,'face',[3:6],'g',0.0,'q',0.0); % the outer model boundarys have no change in electric current, so it is always zero here and beyond?
    applyBoundaryCondition(model,'face',[7,8,15:19],'h',1.0,'r',@myrfun); %the 'r' 5.0 sets up a 5(mv?) voltage here
    applyBoundaryCondition(model,'face',[1,2,9:14],'h',1.0,'r',@myrfun2);
elseif isequal(geometryloc,'sidesidestim2.stl')
    applyBoundaryCondition(model,'face',[1:19],'g',0.0,'q',0.0); % the outer model boundarys have no change in electric current, so it is always zero here and beyond?
    applyBoundaryCondition(model,'face',5,'h',1.0,'r',@myrfun); %the 'r' 5.0 sets up a 5(mv?) voltage here
    applyBoundaryCondition(model,'face',3,'h',1.0,'r',@myrfun2);
else % boundaries for the default point stimulation geometry
    applyBoundaryCondition(model,'face',[8,9],'h',1.0,'r',@myrfun);
    applyBoundaryCondition(model,'face',[10,11],'h',1.0,'r',@myrfun2);
end


specifyCoefficients(model,'m',0, 'd',1, 'c',0.3, 'a',0, 'f',0); % the difference here from DC is that d=1, making this time dependent.

%% Set initial conditions
% % this is necessary for a time dependent model
generateMesh(model);
disp(model.IsTimeDependent)


tlist=0:dt:(2*pi)/abs(B);  % this is the list of times to solve for, which would need to be modified for different frequencies, I guess?
% NB: if changing tlist, need to also change 't' in the
% getExtracellularPotential call in simulate: t is equal to the length of
% tlist.

if model.IsTimeDependent
     setInitialConditions(model,0); 
    %first condition after model is u, the state att=0.
    result = solvepde(model,tlist);
 else
    result = solvepde(model);
 end


%% Changing input function

function bcMatrix = myrfun(~,state)

bcMatrix = stimstrength*sin((B*2*pi).*state.time);

end

function bcMatrix = myrfun2(~,state)

bcMatrix = -stimstrength*sin((B*2*pi).*state.time);

end

end

