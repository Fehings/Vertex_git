classdef SynapseModel_i_exp_ab < SynapseModel_i_exp & STPModel_ab
  %SynapseModel_g_exp Conductance-based single exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - E_reversal, the reversal potential (in mV)
  %   - tau, the synaptic decay time constant (in ms)

  
  methods
    function SM = SynapseModel_i_exp_ab(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids,~)
      SM = SM@SynapseModel_i_exp(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids );
      SM = SM@STPModel_ab(CP,SimulationSettings,postID,number_in_pre,pre_group_ids);

    end

    
    
    
    function SM = updateSynapses(SM, NM, dt)
        
      updateSynapses@SynapseModel_i_exp(SM, NM, dt);
      updateSynapses@STPModel_ab(SM,dt);

      
      
    end

    function [SM] = bufferIncomingSpikes(SM, synIndeces, weightsToAdd, preInd,groupID)
        
        
        %In stp the changes to facilitation and depression depend only on
        %the presynaptic activity. When this function is called we know
        %that a spike has been generated in the neurons identified by
        %preInd, an index then made relative to each synapse group by
        %subtracting the presynaptic group boundary.
        %update the facilitation variable by adding the facilitation rate
        SM.applySpikes2STPVars(preInd,groupID)
        SM.i_expEventBuffer(synIndeces) = ...
                            SM.i_expEventBuffer(synIndeces) + weightsToAdd.*(SM.F(preInd) .* SM.D(preInd));
        
        %Add the weights multiplied by the plasticity variables to the
        %spike accumulator at the postsynaptic neuron (and compartment and
        %time) determined by synIndeces.

    end

    

  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = [SynapseModel_i_exp.getRequiredParams STPModel_ab.getSTPParams()];
      end
           
  end

end % classdef
