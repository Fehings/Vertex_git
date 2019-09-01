function [NeuronModel, SynModel, InModel, wArr] = ...
    groupUpdateSchedule(NP,TP,SS,NeuronModel,SynModel,InModel,iGroup, synArr,wArr, IDMap,neuronInGroup)


% update synaptic conductances/currents according to buffers

for iSyn = 1:size(SynModel, 2)
    if ~isempty(SynModel{iGroup, iSyn})
        % Get absolute presynaptic IDs of spikes arriving currently
        % getCurrSpikesPreIndex returns  a neuron group relative ID. We then add the neuron
        % group boundary to get the absolute ID.
        if  isa(SynModel{iGroup, iSyn}, 'STDPModel_delays')
            if SynModel{iGroup,iSyn}.hasArrivingSpikes()
                wArr = updateWeights(SynModel{iGroup,iSyn},wArr,IDMap,iGroup, synArr);
            end
            updateSTDPBuffer(SynModel{iGroup, iSyn});
        end
        
        updateBuffer(SynModel{iGroup, iSyn});
        updateSynapses(SynModel{iGroup, iSyn}, NeuronModel{iGroup}, SS.timeStep);
        

    end
end



% update axial currents
if NP(iGroup).numCompartments > 1
    updateI_ax(NeuronModel{iGroup}, NP(iGroup));
end




% update inputs
if ~isempty(InModel)
    for iIn = 1:length(InModel(iGroup,:))
        if ~isempty(InModel{iGroup, iIn})
            updateInput(InModel{iGroup, iIn},NeuronModel{iGroup});
        end
        
    end
end



% update neuron model variables
if ~isempty(InModel)
    
    updateNeurons(NeuronModel{iGroup}, InModel(iGroup, :), ...
        NP(iGroup), SynModel(iGroup, :), SS.timeStep);
else
    updateNeurons(NeuronModel{iGroup}, [], ...
        NP(iGroup), SynModel(iGroup, :), SS.timeStep);
end