classdef (Abstract) STPModel < PlasticityModel
  %STPModel Abstact short term plasticity model
  % Defines the interface that STPModels must adhere to.




  
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
