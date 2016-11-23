
function [ sigma ] = activationfunction( point1,point2, stimfieldtri,t )

    delta = 0.00001;
    grad = point1 - point2;
    point1d = point1 + delta*grad; % deviation, point 1 (start of compartment) shifted up the compartment towards the middle
    point2d = point2 - delta*grad; % deviation, point 2 (end of compartment) shifted down the compartment towards the middle
    point1
    if isa(stimfieldtri,'pde.StationaryResults')
        EPpoint1 = interpolateSolution(stimfieldtri, point1); % at start compartment location
        EPpoint2 = interpolateSolution(stimfieldtri, point2); % at end of compartment location
        EPpoint1d = interpolateSolution(stimfieldtri, point1d); 
        EPpoint2d = interpolateSolution(stimfieldtri, point2d);
    elseif isa(stimfieldtri,'pde.TimeDependentResults')
          EPpoint1 = interpolateSolution(stimfieldtri, point1,t);
        EPpoint2 = interpolateSolution(stimfieldtri, point2,t);
        EPpoint1d = interpolateSolution(stimfieldtri, point1d,t);
        EPpoint2d = interpolateSolution(stimfieldtri, point2d,t);
    else
        EPpoint1 = evaluate(stimfieldtri,point1);
        EPpoint2 = evaluate(stimfieldtri,point2);
        EPpoint1d = evaluate(stimfieldtri,point1d);
        EPpoint2d = evaluate(stimfieldtri,point2d);
    end
    
    % Multiplying the EPpoints by 1000 to convert the units from V to mV to
    % match the units Vertex uses, as the pde toolbox generated field should be in SI units:
    
    delta_u_point1 = (EPpoint1*1000 - EPpoint1d*1000)./delta;

    delta_u_point2 = (EPpoint2*1000 - EPpoint2d*1000)./delta;

    sigma = (delta_u_point1 - delta_u_point2);

    sigma(isnan(sigma)) = 0; 
    
    % convert the units from V to mV to match the units Vertex uses, as the
    % pde toolbox generated field should be in SI units:
    

    
    
    
    
    
    
end


