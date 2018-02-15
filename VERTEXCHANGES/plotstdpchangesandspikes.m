function plotstdpchangesandspikes(preABSID,postABSID,Results)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

preRecID = find(Results.params.RecordingSettings.v_m== preABSID);
preRecWID = find(Results.params.RecordingSettings.weights_preN_IDs== preABSID);

if isempty(preRecID )
    disp('Pre synaptic neuron not recorded.')
    return
end
postRecID = find(Results.params.RecordingSettings.v_m== postABSID);
postRecWID = find(Results.params.RecordingSettings.weights_preN_IDs== postABSID);

if max((Results.synapsePostIDs{preRecWID}==postABSID))==0
    disp('No synapse between neurons')
    disp('Pre synaptic neuron does connect to: ' )
    disp(Results.synapsePostIDs{preRecWID}(ismember(Results.synapsePostIDs{preRecWID},Results.params.RecordingSettings.v_m)))
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

plot(rectimes,Results.v_m(Results.params.RecordingSettings.v_m==preABSID,:),'k', 'LineWidth', 2);
ylabel('Vm (mV)')
title('Presynaptic membrane potential');
rectimes = (1:length(Results.v_m(Results.params.RecordingSettings.v_m==preABSID,:)))./Results.params.RecordingSettings.sampleRate;
rectimes = rectimes*1000;

ax2 = subplot(3,1,2);
plot(rectimes,Results.v_m(Results.params.RecordingSettings.v_m==postABSID,:),'k', 'LineWidth', 2);
ylabel('Vm (mV)')
title('Presynaptic membrane potential');
rectimes = (1:length(Results.v_m(Results.params.RecordingSettings.v_m==postABSID,:)))./Results.params.RecordingSettings.sampleRate;


ax3 = subplot(3,1,3);
rectimes = (1:length(Results.weights{preRecWID}(Results.synapsePostIDs{preRecWID}==postABSID,:)))./Results.params.RecordingSettings.sampleRate;
rectimes = rectimes*1000;
plot(rectimes,Results.weights{preRecWID}(Results.synapsePostIDs{preRecWID}==postABSID,:))
xlabel('Time (ms)')
ylabel('Synapse weight')
title('Change in synaptic weight');
linkaxes([ax1,ax2, ax3],'x');


end

