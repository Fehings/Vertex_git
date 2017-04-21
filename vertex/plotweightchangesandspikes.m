function plotweightchangesandspikes(preRecID,postRecID,Results)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
postABSID = Results.params.RecordingSettings.v_m(postRecID);
postlocation = find(Results.synapsePostIDs{preRecID}==postABSID);
if isempty(postlocation)
    disp('No connections from pre neuron to post neuron')
    disp('Postsynaptic neurons recorded from the neuron are: ')
    disp(find(ismember(Results.params.RecordingSettings.v_m,Results.synapsePostIDs{preRecID})));
    return
end

ax1 = subplot(3,1,1)
plot(Results.v_m(preRecID,:))
title('Presynaptic membrane potential')
ax2 = subplot(3,1,2)
plot(Results.v_m(postRecID,:))
title('Postsynaptic membrane potential')
ax3 = subplot(3,1,3)
plot(Results.weights{preRecID}(postlocation,:));

linkaxes([ax1,ax2,ax3],'x')
end

