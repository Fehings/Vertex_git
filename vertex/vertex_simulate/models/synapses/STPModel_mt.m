classdef (Abstract) STPModel_mt < STPModel
  %STPModel_mt Markram Tsodyks model of short term plasticity. 
  %   Parameters to set in ConnectionParams:
  %   - fac_tau, the decay time constant for facilitation (in ms)
  %   - rec_tau, the decay time constant for recovery from depression (in ms)
  %   - tau_s, the synaptic decay time constant (in ms)
  %   - U, the transmitter release probability

  properties (SetAccess = protected)
    x
    y
    z
    u
    tau_s
  end
  
  properties (SetAccess = public)
      fac_tau
      rec_tau
      U
  end
  
  methods
    function SM = STPModel_mt(CP, SimulationSettings, postID,number_in_pre,pre_group_ids)
      
      SM = SM@STPModel(number_in_pre,pre_group_ids);
      number_in_pre = sum(number_in_pre);
   
      for param = SM.getSTPParams()
          SM.(param{1}) = getAttributeDist(CP,param,sum(number_in_pre),postID,SimulationSettings,true);
      end
      SM.x = ones(sum(number_in_pre), 1);
      SM.y = zeros(sum(number_in_pre), 1);
      SM.z = zeros(sum(number_in_pre), 1);
      SM.u = zeros(sum(number_in_pre), 1);

    end

    
    
    
    function SM = updateSynapses(SM, dt)
        

      % update x

     % update y   

      dy = (-SM.y./SM.tau_s);
      y_in = SM.y + 0.5 .* dy .* dt;

      
      % update z
      dz = (SM.y./SM.tau_s) - (SM.z ./SM.rec_tau);
      z_in = SM.z + 0.5 .* dz .* dt;

      % update u

      du = (-SM.u./SM.fac_tau) ;
      u_in = SM.u + 0.5 .* du .* dt;

      
      dx = (z_in ./ SM.rec_tau );
      SM.x = SM.x + dx .* dt;
      
      dy = (-y_in ./ SM.tau_s );
      SM.y = SM.y + dy .* dt;
      
      dz = (SM.y./SM.tau_s) - (z_in ./SM.rec_tau);
      SM.z = SM.z + dz .* dt;
      
      du = (-u_in./SM.fac_tau) ;
      SM.u = SM.u + du .* dt;
      
      
    end

    function [SM] = applySpikes2STPVars(SM, preInd,groupID)
        
        
        %In stp the changes to facilitation and depression depend only on
        %the presynaptic activity. When this function is called we know
        %that a spike has been generated in the neurons identified by
        %preInd, an index then made relative to each synapse group by
        %subtracting the presynaptic group boundary.
        %update the facilitation variable by adding the facilitation rate
        preInd = preInd + SM.preBoundaryArr(SM.preGroupIDs==groupID);

        if length(SM.U) > 1
            SM.u(preInd) = SM.u(preInd) + SM.U(preInd) .* (1 - SM.u(preInd));
    
        else
            SM.u(preInd) = SM.u(preInd) + SM.U .* (1 - SM.u(preInd));
        end
        SM.y(preInd) = SM.y(preInd) + SM.u(preInd) .* SM.x(preInd);
        SM.x(preInd) = SM.x(preInd) - SM.u(preInd) .* SM.x(preInd);
        
        %Add the weights multiplied by the plasticity variables to the
        %spike accumulator at the postsynaptic neuron (and compartment and
        %time) determined by synIndeces.

    end

    
    function [VAR] = getSTPVars(SM, preInd, groupID)
        preInd = preInd + SM.preBoundaryArr(SM.preGroupIDs==groupID);

        VAR = [SM.u(preInd),SM.y(preInd),SM.x(preInd),SM.z(preInd)];
    end
  end % methods
  
  methods(Static)      
      
      % Synaptic attributes defined on the pre synaptic side.
      function params = getSTPParams()
          params =  {'fac_tau','rec_tau','U','tau_s'};
      end
      
          
  end

end % classdef
