classdef SynapseModel_g_exp_mt_stdp_delays < SynapseModel_g_exp_mt & STDPModel_delays
  %SynapseModel_g_exp Conductance-based single exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - E_reversal, the reversal potential (in mV)
  %   - tau, the synaptic decay time constant (in ms)

  
  methods
      % Synapse model will be a cell array containing a struct for each
      % connection type indexed by the post synaptic group then the
      % presynaptic synapse group(may contain multiple neuron groups). The struct contains variables for all
      % neurons in the presynatpic synapse group and all neurons in the post
      % synaptic group. Or all post synaptic neurons on the lab and all
      % presynaptic neurons regardless of lab, if using parallel mode. 
    function SM = SynapseModel_g_exp_mt_stdp_delays(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids, GBA)
                                 
      SM = SM@SynapseModel_g_exp_mt(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids);
      SM = SM@STDPModel_delays(CP, SimulationSettings, postID, number_in_post,number_in_pre,pre_group_ids,GBA);

      
    end

    
    function SM = updateSynapses(SM, NM, dt)
        
        updateSynapses@SynapseModel_g_exp_mt(SM, NM, dt);
      updateSynapses@STDPModel(SM, dt);
    end
    


  end % methods
  
  methods(Static)
      function params = getRequiredParams()
         params =[SynapseModel_g_exp_mt.getRequiredParams STDPModel_delays.getSTDPParams];
      end
  end

end % classdef
