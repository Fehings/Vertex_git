classdef (Abstract) SynapseModel_g_stp < SynapseModel_g_exp
  %SynapseModel_g_exp Conductance-based single exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - E_reversal, the reversal potential (in mV)
  %   - tau, the synaptic decay time constant (in ms)

  properties (SetAccess = protected)
    preBoundaryArr
    preGroupIDs
  end
  
  methods
    function SM = SynapseModel_g_stp(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids,~)
      SM = SM@SynapseModel_g_exp(Neuron, CP, SimulationSettings, postID, number_in_post );
      
      % short term plasticity involves variables that are dependent on pre
      % synaptic activity.
      for param = SM.getPreSynapticParams()
          SM.(param{1}) = getAttributeDist(CP,param,sum(number_in_pre),postID,SimulationSettings,true);
      end
      
      SM.preBoundaryArr = [0; cumsum(number_in_pre)];
      SM.preGroupIDs = pre_group_ids;
      
    end

  end
  methods (Abstract)
      
    updateSynapses(SM, NM, dt)
    bufferIncomingSpikes(SM, synIndeces, weightsToAdd, preInd,groupID)
    getSTPVars(SM, preInd, groupID)

  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = [SynapseModel_g_stp.getPostSynapticParams() SynapseModel_g_stp.getPreSynapticParams()];
      end
      
      % Synaptic attributes defined on the post synaptic side.
      function params = getPostSynapticParams()
          params = SynapseModel_g_exp.getPostSynapticParams();
      end
      
      % Synaptic attributes defined on the pre synaptic side.
      function params = getPreSynapticParams()
          params =  [];
      end
  end

end % classdef
