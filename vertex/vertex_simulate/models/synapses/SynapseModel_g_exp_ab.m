classdef SynapseModel_g_exp_ab < SynapseModel_g_exp & STPModel_ab
  %SynapseModel_g_exp_ab Conductance-based single exponential synapses with
  %STP
  
  methods
    function SM = SynapseModel_g_exp_ab(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids,~)
      SM = SM@SynapseModel_g_exp(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids );
      SM = SM@STPModel_ab(CP,SimulationSettings,postID,number_in_pre,pre_group_ids);

    end

    
    function SM = updateSynapses(SM, NM, dt)
        
      updateSynapses@SynapseModel_g_exp(SM, NM, dt);
      updateSynapses@STPModel_ab(SM,dt);

    end

    function [SM] = bufferIncomingSpikes(SM, synIndeces, weightsToAdd, preInd,groupID)
        
        
        %In stp the changes to facilitation and depression depend only on
        %the presynaptic activity. When this function is called we know
        %that a spike has been generated in the neurons identified by
        %preInd, an index then made relative to each synapse group by
        %subtracting the presynaptic group boundary.
        %update the facilitation variable by adding the facilitation rate
        SM.applySpikes2STPVars(preInd,groupID);
        SM.g_expEventBuffer(synIndeces) = ...
            SM.g_expEventBuffer(synIndeces) + (weightsToAdd).*(SM.F(preInd) .* SM.D(preInd));
        
        %Add the weights multiplied by the plasticity variables to the
        %spike accumulator at the postsynaptic neuron (and compartment and
        %time) determined by synIndeces.

    end

    

  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = [SynapseModel_g_exp.getRequiredParams() STPModel_ab.getSTPParams()];
      end
           
  end

end % classdef
