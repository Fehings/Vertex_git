function [t,y]=solvefusBLS(tstep,tend,y0)
% the solver for the HH version of FUS BLS

% initialise count
count=1;
% initialise tspan
t=tstep:tstep:tend;

% set up the solution vector
y=zeros(length(y0),length(t));
y(:,1)=y0;
figure
hold on
for i=t

    dy=fusBLS_hh(i,tstep,y(:,count)); % dy represents dy/dt
    
    y(:,count+1)=y(:,count)+dy(:).*tstep;

%     if y(4,count)>1e15 % if n_a is being silly, plot and break.
%         figure
%         plot(y(4,1:count))
%         legend('n_a')
%         figure
%         plot(y(3,1:count))
%         legend('z')
%     msg='Na esploded';
%     error(msg)
%     
%     end
    
    count=count+1;
    
end
hold off

end