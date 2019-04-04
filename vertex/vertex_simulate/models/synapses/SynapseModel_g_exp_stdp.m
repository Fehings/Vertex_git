classdef SynapseModel_g_exp_stdp < SynapseModel_g_exp & STDPModel
  %SynapseModel_g_exp Conductance-based single exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - E_reversal, the reversal potential (in mV)
  %   - tau, the synaptic decay time constant (in ms)

  
  methods
    function SM = SynapseModel_g_exp_stdp(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids,~)
      SM = SM@SynapseModel_g_exp(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids );
      SM = SM@STDPModel(CP, SimulationSettings, postID, number_in_post,number_in_pre,pre_group_ids);

    end

    
    
    
    function SM = updateSynapses(SM, NM, dt)
        
      updateSynapses@SynapseModel_g_exp(SM, NM, dt);
      updateSynapses@STDPModel(SM,dt);

      
      
    end


    

  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = [SynapseModel_g_exp.getRequiredParams STPModel_mt.getSTPParams()];
      end
           
  end

end % classdef
