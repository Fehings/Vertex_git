function [ point1, point2 ] = convertcompartmentlocations( compartmentx,compartmenty, compartmentz )
    %Convert the compartmentlocations cell array into two objects for the start and
    % end of the compartment. Each containing matrices for the x, y, and z 
    %for each compartment. Called by group
    %because number of compartments must be the same.
    
    
    %pre allocation for speed
    
    compartmentxp1 = zeros(length(compartmentx{1}),length(compartmentx(:,1)));
    compartmentxp2 = zeros(length(compartmentx{1}),length(compartmentx(:,1)));
    compartmentyp1 = zeros(length(compartmenty{1}),length(compartmenty(:,1)));
    compartmentyp2 = zeros(length(compartmenty{1}),length(compartmenty(:,1)));
    compartmentzp1 = zeros(length(compartmentz{1}),length(compartmentz(:,1)));
    compartmentzp2 = zeros(length(compartmentz{1}),length(compartmentz(:,1)));
    
 
    for i = 1:length(compartmentx)    
       
        compartmentxp1(:,i) = compartmentx{:,i}(:,1);
        compartmentxp2(:,i) = compartmentx{:,i}(:,2);
        compartmentyp1(:,i) = compartmenty{:,i}(:,1);
        compartmentyp2(:,i) = compartmenty{:,i}(:,2);
        compartmentzp1(:,i) = compartmentz{:,i}(:,1);
        compartmentzp2(:,i) = compartmentz{:,i}(:,2);
    end
    
  
    point1.x = compartmentxp1;
    point1.y = compartmentyp1; 
    point1.z = compartmentzp1;
    
    point2.x = compartmentxp2;
    point2.y = compartmentyp2;
    point2.z = compartmentzp2;
    

    
end

