classdef SynapseModel_g_2exp_ab < SynapseModel_g_2exp & STPModel_ab
  %SynapseModel_g_2exp_ab Conductance-based double exponential synapses
  %with STP


  
  methods
    function SM = SynapseModel_g_2exp_ab(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids,~)
      SM = SM@SynapseModel_g_2exp(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids );
      SM = SM@STPModel_ab(CP,SimulationSettings,postID,number_in_pre,pre_group_ids);

    end

    
    
    function SM = updateSynapses(SM, NM, dt)
        
      updateSynapses@SynapseModel_g_2exp(SM, NM, dt);
      updateSynapses@STPModel_ab(SM,dt);
  
    end

    function [SM] = bufferIncomingSpikes(SM, synIndeces, weightsToAdd, preInd,groupID)
        
        SM.applySpikes2STPVars(preInd,groupID);
        SM.g_expEventBuffer(synIndeces) = ...
            SM.g_expEventBuffer(synIndeces) + (weightsToAdd).*(SM.F(preInd) .* SM.D(preInd));

    end

    

  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = [SynapseModel_g_2exp.getRequiredParams() STPModel_ab.getSTPParams()];
      end
           
  end

end % classdef
