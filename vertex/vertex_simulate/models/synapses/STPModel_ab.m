classdef (Abstract) STPModel_ab < STPModel
  %STPModel_ab Short term plasticity model based on (Abbott et.al 1997)
  %   Parameters to set in ConnectionParams:
  %   - tD, the decay time constant for Depression (in ms)
  %   - tD, the decay time constant for Facilitation (in ms)
  %   - facilitation, the rate of Facilitation (nS/ms)
  %   - depression, the rate of Depression (nS/ms)
  
  properties (SetAccess = public)
    facilitation
    F
    tF
    depression
    D
    tD
  end
  
  methods
    function SM = STPModel_ab( CP, SimulationSettings,postID,number_in_pre,pre_group_ids)
        SM = SM@STPModel(number_in_pre,pre_group_ids);
      for param = SM.getSTPParams()
          SM.(param{1}) = getAttributeDist(CP,param,sum(number_in_pre),postID,SimulationSettings,true);
      end
      %STP is dependent only on the firing of the presynaptic neuron
      %so we to store the facilitation and depression modifiers for only
      %the presynaptic neurons in each object.
      SM.F = ones(sum(number_in_pre), 1);
      SM.D = ones(sum(number_in_pre), 1);
      
      
    end

    
    function SM = updateSynapses(SM, dt)
     % update the short term plasticity variables.
      SM.F = SM.F + ((1 - SM.F)./SM.tF).*dt;
      SM.D = SM.D + ((1 - SM.D)./SM.tD).*dt;
      
    end

    function [SM] = applySpikes2STPVars(SM, preInd,groupID)
        
        
        %In stp the changes to facilitation and depression depend only on
        %the presynaptic activity. When this function is called we know
        %that a spike has been generated in the neurons identified by
        %preInd, an index then made relative to each synapse group by
        %subtracting the presynaptic group boundary.
        %update the facilitation variable by adding the facilitation rate
        preInd = preInd + SM.preBoundaryArr(SM.preGroupIDs==groupID);
        if length(SM.facilitation)>1
            SM.F(preInd) = SM.facilitation(preInd) + SM.F(preInd);
        else
            SM.F(preInd) = SM.facilitation + SM.F(preInd);
        end
        
        if length(SM.depression) > 1
             SM.D(preInd) = SM.depression(preInd) .* SM.D(preInd);
        else
            SM.D(preInd) = SM.depression .* SM.D(preInd);
        end
       
        
        %Add the weights multiplied by the plasticity variables to the
        %spike accumulator at the postsynaptic neuron (and compartment and
        %time) determined by synIndeces.

    end
    

    
    
    function [VAR] = getSTPVars(SM, preInd, groupID)
        preInd = preInd + SM.preBoundaryArr(SM.preGroupIDs==groupID);
        VAR = [SM.F(preInd), SM.D(preInd), zeros(length(preInd),1), zeros(length(preInd),1)];
        F = SM.F(preInd);
        D = SM.D(preInd);
    end
  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = [STPModel_ab.getPreSynapticParams()];
      end
      
      % Synaptic attributes defined on the pre synaptic side.
      function params = getPreSynapticParams()
          params =  {'tD','tF','facilitation','depression'};
      end
      function params = getSTPParams()
          params =  {'tD','tF','facilitation','depression'};
      end
  end

end % classdef
