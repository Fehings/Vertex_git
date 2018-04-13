classdef SynapseModel_g_stp_mt < SynapseModel_g_stp
  %SynapseModel_g_exp Conductance-based single exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - E_reversal, the reversal potential (in mV)
  %   - tau, the synaptic decay time constant (in ms)

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
    function SM = SynapseModel_g_stp_mt(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids,~)
      SM = SM@SynapseModel_g_stp(Neuron, CP, SimulationSettings,postID, number_in_post,number_in_pre,pre_group_ids );
      number_in_pre = sum(number_in_pre);
      SM.fac_tau(SM.fac_tau<2) = 2;
      SM.rec_tau(SM.rec_tau<2) = 2;
      SM.U(SM.U<0.01) = 0.01;
      SM.tau_s = getAttributeDist(CP,{'tau'},number_in_pre,postID);
      SM.tau_s(SM.tau_s<2) = 2;
      SM.x = ones(sum(number_in_pre), 1);
      SM.y = zeros(sum(number_in_pre), 1);
      SM.z = zeros(sum(number_in_pre), 1);
      SM.u = zeros(sum(number_in_pre), 1);

    end

    
    
    
    function SM = updateSynapses(SM, NM, dt)
        
      updateSynapses@SynapseModel_g_exp(SM, NM, dt);

      % update x
     % disp(['size z: ' num2str(size(SM.z))])
     % disp(['size rectau: ' num2str(size(SM.rec_tau ))])


      
     % update y   
     %disp(['size y: ' num2str(size(SM.y))])
      %disp(['size tau: ' num2str(size(SM.tau ))])
      dy = (-SM.y./SM.tau_s);
      y_in = SM.y + 0.5 .* dy .* dt;

      
      % update z
      dz = (SM.y./SM.tau_s) - (SM.z ./SM.rec_tau);
      z_in = SM.z + 0.5 .* dz .* dt;

      % update u
      %disp(['size u: ' num2str(size(SM.y))])
      %disp(['size factau: ' num2str(size(SM.tau ))])
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

    function [SM] = bufferIncomingSpikes(SM, synIndeces, weightsToAdd, preInd,groupID)
        
        
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
        SM.g_expEventBuffer(synIndeces) = ...
            SM.g_expEventBuffer(synIndeces) + (weightsToAdd).*(SM.y(preInd));
       %max(SM.x(preInd))
        
        %Add the weights multiplied by the plasticity variables to the
        %spike accumulator at the postsynaptic neuron (and compartment and
        %time) determined by synIndeces.

    end
    
    function set_spike_modulated(SM,u, y, x, preInd)
        SM.u(preInd) = u;
        SM.x(preInd) = x;
        SM.y(preInd) = y;
    end


    
    function get_spike_modulated(SM,u, y, x, preInd)
        SM.u(preInd) = u;
        SM.x(preInd) = x;
        SM.y(preInd) = y;
    end
    

    
    function [VAR] = getSTPVars(SM, preInd, groupID)
        preInd = preInd + SM.preBoundaryArr(SM.preGroupIDs==groupID);

        VAR = [SM.u(preInd),SM.y(preInd),SM.x(preInd),SM.z(preInd)];
    end
  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = [SynapseModel_g_stp_mt.getPostSynapticParams() SynapseModel_g_stp_mt.getPreSynapticParams()];
      end
      
            % Synaptic attributes defined on the post synaptic side.
      function params = getPostSynapticParams()
          params = SynapseModel_g_stp.getPreSynapticParams();
      end
      
      % Synaptic attributes defined on the pre synaptic side.
      function params = getPreSynapticParams()
          params =  {'fac_tau','rec_tau','U'};
      end
  end

end % classdef
