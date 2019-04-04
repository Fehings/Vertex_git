classdef SynapseModel_g_exp_ab_stdp_delays < SynapseModel_g_exp_ab & STDPModel_delays
  %SynapseModel_g_exp_ab_stdp_delays Conductance-based single exponential
  %synapses with STDP and STDP with delays


  
  methods

    function SM = SynapseModel_g_exp_ab_stdp_delays(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids, GBA)
                                 
      SM = SM@SynapseModel_g_exp_ab(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids);
      SM = SM@STDPModel_delays(CP, SimulationSettings, postID, number_in_post,number_in_pre,pre_group_ids,GBA);
      

      
    end

    
    function SM = updateSynapses(SM, NM, dt)
        
        updateSynapses@SynapseModel_g_exp_ab(SM, NM, dt);
        updateSynapses@STDPModel_delays(SM, dt);
    end
    


  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params =[SynapseModel_g_exp_ab.getRequiredParams STDPModel_delays.getSTDPParams];
      end
  end

end % classdef
