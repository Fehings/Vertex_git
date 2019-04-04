classdef SynapseModel_g_2exp_stdp < SynapseModel_g_2exp & STDPModel
  %SynapseModel_g_2exp Conductance-based double exponential synapses with
  %STDP


  
  methods
    function SM = SynapseModel_g_2exp_stdp(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids,~)
      SM = SM@SynapseModel_g_2exp(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids );
      SM = SM@STDPModel(CP,SimulationSettings,postID,number_in_pre);

    end

    
    function SM = updateSynapses(SM, NM, dt)
        
      updateSynapses@SynapseModel_g_2exp(SM, NM, dt);
      updateSynapses@STDPModel(SM,dt);

    end


    

  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = [SynapseModel_g_2exp.getRequiredParams STDPModel.getSTPParams()];
      end
           
  end

end % classdef
