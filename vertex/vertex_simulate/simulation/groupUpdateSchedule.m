function [NeuronModel, SynModel, InModel] = ...
  groupUpdateSchedule(NP,SS,NeuronModel,SynModel,InModel,iGroup, StimParams)

% update synaptic conductances/currents according to buffers
for iSyn = 1:size(SynModel, 2)
  if ~isempty(SynModel{iGroup, iSyn})
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
    for iIn = 1:size(InModel, 2)
        if ~isempty(InModel{iGroup, iIn})
            %if it is an electric field input pass it the electric field
            %effect at each compartment
            if isa(InModel{iGroup, iIn}, 'InputModel_i_efield')
                
                    if isfield(NP(iGroup).Input(iIn),'timeDependence')
                     if strcmp(NP(iGroup).Input(iIn).timeDependence,'rand')
                        StimParams.activation=cellfun(@(x) x.*StimParams.trns,StimParams.activationAll,'UniformOutput',0);
                         %max(max(StimParams.activation{1})) % uncomment to check that trns is having an effect, and how varying this is.
                     end
                    end
                updateInput(InModel{iGroup, iIn},NP(iGroup).Input(iIn), StimParams.activation{iGroup});
                
            %if it is an electric input pass it the effect/field strength at
            %each compartment. 
            elseif isa(InModel{iGroup, iIn}, 'InputModel_i_focusedultrasound')
                %find parameters for ultrasound and calculate capacitance
                updateCapacitance(InModel{iGroup, iIn},NeuronModel{iGroup}.v, StimParams.ultrasound{iGroup},simStep);
            
                %Capacitance_print=unique(NP(iGroup).C)
                
                
                %update the main capacitance values
                NP(iGroup).C=InModel{iGroup,iIn}.C;
                l = NP(iGroup).compartmentLengthArr .* 10^-4;
                d = NP(iGroup).compartmentDiameterArr .* 10^-4;
                
                for compNo=1:size(NP(iGroup).C,2)
                NP(iGroup).C_m = ...
                 NP(iGroup).C(:,compNo) .* pi .* l(compNo) .* d(compNo) .* 10^6; % taken from the 
                %calculatePassiveProperties script for converting capacitance into the appropriate units.
                end
                %Capacitance_mean1=mean(NP(iGroup).C_m)
                %Now upate the input, which is the dCmVm value calculates in updateCapacitance 
                updateInput(InModel{iGroup, iIn});%,StimParams.FusParams(iGroup).fusparams);
               
            %if it is an focused ultrasound input pass it the effect/field strength at
            %each compartment
            elseif isa(InModel{iGroup, iIn}, 'InputModel_i_focusedultrasound')
                updateInput(InModel{iGroup, iIn},NeuronModel{iGroup}, StimParams.ultrasound{iGroup});
            else
                updateInput(InModel{iGroup, iIn},NeuronModel{iGroup});    
            end
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