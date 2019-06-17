classdef SynapseModel_g_2exp_mt < SynapseModel_g_2exp & STPModel_mt
  %SynapseModel_g_2exp_mt Conductance-based double exponential synapses
  %with Markram Tsodyks STP


  
  methods
    function SM = SynapseModel_g_2exp_mt(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids,~)
      SM = SM@SynapseModel_g_2exp(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids );
      SM = SM@STPModel_mt(CP,SimulationSettings,postID,number_in_pre,pre_group_ids);

    end

    
    
    
    function SM = updateSynapses(SM, NM, dt)
        
      updateSynapses@SynapseModel_g_2exp(SM, NM, dt);
      updateSynapses@STPModel_mt(SM,dt);

      
      
    end

    function [SM] = bufferIncomingSpikes(SM, synIndeces, weightsToAdd, preInd,groupID)
        
        SM.applySpikes2STPVars( preInd,groupID);
        SM.g_expEventBuffer(synIndeces) = ...
            SM.g_expEventBuffer(synIndeces) + (weightsToAdd).*(SM.y(preInd));
        

    end

    

  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = [SynapseModel_g_2exp.getRequiredParams() STPModel_mt.getSTPParams()];
      end
           
  end

end % classdef
