function plotstdpchangesandspikes(preABSID,postABSID,Results)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
neuronInGroup = ...
    createGroupsFromBoundaries(Results.params.TissueParams.groupBoundaryIDArr);
preRecID = find(Results.params.RecordingSettings.v_m== preABSID);
preRecWID = find(Results.params.RecordingSettings.weights_preN_IDs== preABSID);

preGroup = neuronInGroup(preABSID);
postGroup = neuronInGroup(postABSID);

if isempty(preRecID )
    disp('Pre synaptic neuron not recorded.')
    return
end

if isempty(preRecWID)
    disp('Synapse weights from presynaptic id not recorded')
    return
end
postRecID = find(Results.params.RecordingSettings.v_m== postABSID);
postRecWID = find(Results.params.RecordingSettings.weights_preN_IDs== postABSID);


if max((Results.synapsePostIDs{preRecWID}==postABSID))==0
    disp('No synapse between neurons')
    disp('Pre synaptic neuron does connect to: ' )
    connto = Results.synapsePostIDs{preRecWID}(ismember(Results.synapsePostIDs{preRecWID},Results.params.RecordingSettings.v_m));
    
    %disp(Results.synapsePostIDs{preRecWID}(ismember(Results.synapsePostIDs{preRecWID},Results.params.RecordingSettings.v_m)))
    disp(connto(ismember(connto,Results.spikes(:,1))));
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


t = getTimeVector(Results);
length(t)
length(Results.v_m(Results.params.RecordingSettings.v_m==preABSID,:))
ax1 = subplot(4,1,1);
rectimes = (1:length(Results.v_m(Results.params.RecordingSettings.v_m==preABSID,:)))./Results.params.RecordingSettings.sampleRate;
rectimes = rectimes*1000;
plot(t,Results.v_m(Results.params.RecordingSettings.v_m==preABSID,1:end-1),'k', 'LineWidth', 2);
ylabel('Vm (mV)')
title('Presynaptic membrane potential');


ax2 = subplot(4,1,2);
plot(t,Results.v_m(Results.params.RecordingSettings.v_m==postABSID,1:end-1),'k', 'LineWidth', 2);
ylabel('Vm (mV)')
title('Postsynaptic membrane potential');


ax3 = subplot(4,1,3);
rectimes = (1:length(Results.weights{preRecWID}(Results.synapsePostIDs{preRecWID}==postABSID,:)))./Results.params.RecordingSettings.sampleRate;
rectimes = rectimes*1000;
plot(t,Results.weights{preRecWID}(Results.synapsePostIDs{preRecWID}==postABSID,:),'k', 'LineWidth', 2)
ylabel('Synapse weight')
title('Change in synaptic weight');

ax4 = subplot(4,1,4);
preind = find(Results.params.RecordingSettings.stdpvars== preABSID);
if isempty(preind)
    disp('No stdp variables recorded for specified presynaptic neuron')
    return;
end
rectimes = (1:length(Results.stdpvars{1}(preind,:)))./Results.params.RecordingSettings.sampleRate;
rectimes = rectimes*1000;
plot(t,Results.stdpvars{1,postGroup}(preind,1:end-1))
hold on;

postind = find(Results.params.RecordingSettings.stdpvars== postABSID);
if isempty(postind)
    disp('No stdp variables recorded for specified postsynaptic neuron')
    disp(Results.params.RecordingSettings.stdpvars)
    return;
end
plot(t,Results.stdpvars{2,preGroup}(postind,1:end-1))
legend('Apre', 'Apost')
title('Trace variables for STDP');
xlabel('Time (s)')

 linkaxes([ax1,ax2, ax3, ax4],'x');


end

