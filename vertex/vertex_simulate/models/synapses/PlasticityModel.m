classdef (Abstract) PlasticityModel < handle
  %SynapseModel_g_exp Conductance-based single exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - E_reversal, the reversal potential (in mV)
  %   - tau, the synaptic decay time constant (in ms)

  properties (SetAccess = protected)
    preBoundaryArr
    preGroupIDs
  end
  
  methods
    function SM = PlasticityModel(number_in_pre,pre_group_ids)
      
      % short term plasticity involves variables that are dependent on pre
      % synaptic activity.
      
      SM.preBoundaryArr = [0; cumsum(number_in_pre)];
      SM.preGroupIDs = pre_group_ids;
      
    end

  end

  methods(Static)

  end

end % classdef
