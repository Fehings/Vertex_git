classdef SynapseModel_g_exp_ab_stdp < SynapseModel_g_exp_ab & STDPModel
  %SynapseModel_g_exp_ab_stdp Conductance-based single exponential synapses
  %with STP and STDP


  
  methods

    function SM = SynapseModel_g_exp_ab_stdp(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids, ~)
                                 
      SM = SM@SynapseModel_g_exp_ab(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids);
      SM = SM@STDPModel(CP, SimulationSettings, postID, number_in_post,number_in_pre,pre_group_ids);

      
    end

    
    function SM = updateSynapses(SM, NM, dt)
        
        updateSynapses@SynapseModel_g_exp_stp_ab(SM, NM, dt);
      updateSynapses@STDPModel(SM, dt);
    end
    


  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params =[SynapseModel_g_exp_ab.getRequiredParams STDPModel.getSTDPParams];
      end
  end

end % classdef
