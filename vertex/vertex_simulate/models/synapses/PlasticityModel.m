classdef (Abstract) PlasticityModel < handle
  %PlasticityModel Abstract plasticity model
  % The base class for both STDP and STP models.
  % Defines the properties inherent in both - more presynaptic details are needed for plastic synapse models.
  %   preBoundaryArr - The group boundaries of presynaptic neurons.
  %   preGroupIDs - The IDs of presynaptic neurons.


  properties (SetAccess = protected)
    preBoundaryArr
    preGroupIDs
  end
  
  methods
    function SM = PlasticityModel(number_in_pre,pre_group_ids)
      
      SM.preBoundaryArr = [0; cumsum(number_in_pre)];
      SM.preGroupIDs = pre_group_ids;
      
    end

  end

  methods(Static)

  end

end % classdef
