t = getTimeVector(Results,'ms');
plot(t,mean( (Results.stp_syn{13,1}(1:100,:)+ ((1-Results.stp_syn{13,1}(1:100,:)).*Results.params.ConnectionParams(13).U_mu{13})) .*Results.stp_syn{13,3}(1:100,:) ));
hold on;
plot(t,mean( (Results.stp_syn{20,1}(1:100,:) +((1-Results.stp_syn{20,1}(1:100,:)).*Results.params.ConnectionParams(13).U_mu{20})) .*Results.stp_syn{20,3}(1:100,:) ));
