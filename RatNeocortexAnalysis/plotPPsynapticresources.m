t = getTimeVector(Results,'ms');
synRecMC = mean((Results.stp_syn{20,1}(1:100,:) +((1-Results.stp_syn{20,1}(1:100,:)).*Results.params.ConnectionParams(13).U_mu{20})) .*Results.stp_syn{20,3}(1:100,:));
synRecPC = mean((Results.stp_syn{13,1}(1:100,:)+ ((1-Results.stp_syn{13,1}(1:100,:)).*Results.params.ConnectionParams(13).U_mu{13})) .*Results.stp_syn{13,3}(1:100,:));
plot(t,synRecPC./synRecPC(1), 'LineWidth', 2);
hold on;
plot(t,synRecMC./synRecMC(1), 'LineWidth', 2);
xlim([400 900]);
ylabel('Synaptic Resource')
legend('L5TTPC \rightarrow L5TTPC', 'L5TTPC \rightarrow L5MC');
xticks(400:100:900)