
function [ sigma ] = activationfunction( point1,point2, stimfieldtri )

    delta = 0.00001;
    grad = point1 - point2;
    point1d = point1 + delta*grad;
    point2d = point2 - delta*grad;

    
    EPpoint1 = evaluate(stimfieldtri,point1);
    EPpoint2 = evaluate(stimfieldtri,point2);
    
    EPpoint1d = evaluate(stimfieldtri,point1d);
    EPpoint2d = evaluate(stimfieldtri,point2d);

    delta_u_point1 = (EPpoint1 - EPpoint1d)./delta;

    delta_u_point2 = (EPpoint2 - EPpoint2d)./delta;

    sigma = (delta_u_point1 - delta_u_point2);

    sigma(isnan(sigma)) = 0; 
    
    

end


