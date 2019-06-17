function plotSynapticResource(time, Results)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure;
t = getTimeVector(Results,'ms');
plot(t(time),mean( (Results.stp_syn{1,1}(1:end,time)+ ((1-Results.stp_syn{1,1}(1:end,time)).*Results.params.ConnectionParams(3).U{1})) .*Results.stp_syn{1,3}(1:end,time) ));
end

