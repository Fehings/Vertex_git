function plotweightchangesandspikes(preABSID,postABSID,Results)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
postRecID = find(Results.params.RecordingSettings.v_m==postABSID);
if isempty(postRecID )
    disp('Post synaptic neuron not recorded.')
    return
end
preRecID = find(Results.params.RecordingSettings.weights_preN_IDs== preABSID);
if isempty(preRecID )
    disp('Weights of pre synaptic neuron not recorded.')
    return
end
postlocation = find(Results.synapsePostIDs{preRecID}==postABSID);

if isempty(postlocation)
    disp('No connections from pre neuron to post neuron')
    disp('Postsynaptic neurons recorded from the neuron are: ')
    disp(Results.params.RecordingSettings.v_m(ismember(Results.params.RecordingSettings.v_m,Results.synapsePostIDs{preRecID})));
    return
end
rectimes = (0:length(Results.params.RecordingSettings.samplingSteps))./Results.params.RecordingSettings.sampleRate;
rectimes = rectimes*1000;

spiketimes = Results.spikes(Results.spikes(:,1)==preABSID,2);
[a,spkloc] = min(abs(rectimes-spiketimes)');
Results.v_m(Results.params.RecordingSettings.v_m==preABSID,spkloc) = 30;

spiketimes = Results.spikes(Results.spikes(:,1)==postABSID,2);
[a,spkloc] = min(abs(rectimes-spiketimes)');
Results.v_m(Results.params.RecordingSettings.v_m==postABSID,spkloc) = 30;

ax1 = subplot(3,1,1);
plot(rectimes,Results.v_m(Results.params.RecordingSettings.v_m==preABSID,:));
ylabel('Vm (mV)')
title('Presynaptic membrane potential');
ax2 = subplot(3,1,2);
plot(rectimes,Results.v_m(Results.params.RecordingSettings.v_m==postABSID,:));
title('Postsynaptic membrane potential');
ylabel('Vm (mV)')
ax3 = subplot(3,1,3);
rectimes = (1:length(Results.weights{preRecID}(postlocation,:)))./Results.params.RecordingSettings.sampleRate;
rectimes = rectimes*1000;
plot(rectimes',Results.weights{preRecID}(postlocation,:));
xlabel('Time (ms)')
ylabel('Syanpse weight (nS)')
title('Change in synaptic weight');
linkaxes([ax1,ax2,ax3],'x');
end

