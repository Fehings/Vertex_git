classdef (Abstract) STPModel < PlasticityModel
  %SynapseModel_g_exp Conductance-based single exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - E_reversal, the reversal potential (in mV)
  %   - tau, the synaptic decay time constant (in ms)


  
  methods
    function SM = STPModel(number_in_pre,pre_group_ids)
        SM = SM@PlasticityModel(number_in_pre,pre_group_ids);

    end

  end
  methods (Abstract)
      
    applySpikes2STPVars(SM, preInd,groupID)
    getSTPVars(SM, preInd, groupID)

  end % methods
  
  methods(Static)

  end

end % classdef
