classdef SynapseModel_g_2exp < SynapseModel_g_exp
  %SynapseModel_g_2exp Conductance-based double exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - scaler_2, the strength of the second component relative to the
  %   first.
  %   - tau_2, the synaptic decay time constant of the second component (in ms)

  properties (SetAccess = protected)

    tau_2
    g_exp_2
    scaler_2
  end
  
  methods
    function SM = SynapseModel_g_2exp(Neuron, CP, SimulationSettings, postID, number_in_post, ...
            ~,~,~)
        
       SM = SM@SynapseModel_g_exp(Neuron, CP, SimulationSettings,postID, number_in_post);                           
      for param = SynapseModel_g_2exp.get2expParams()
            SM.(param{1}) = getAttributeDist(CP,param,number_in_post,postID,SimulationSettings,false);
      end

      numComparts = Neuron.numCompartments;

      SM.g_exp_2 = zeros(number_in_post, numComparts);
  

      if SM.tau_2 <= 0
        error('vertex:SynapseModel_g_2exp', ...
           'tau must be greater than zero');
      end
    end

    
    function SM = updateBuffer(SM)
        %Extract spike acumulator value at current buffer location
      SM.g_exp = SM.g_exp + SM.g_expEventBuffer(:, :, SM.bufferCount);
      SM.g_exp_2 = SM.g_exp_2 + SM.g_expEventBuffer(:, :, SM.bufferCount).*SM.scaler_2;

      SM.g_expEventBuffer(:, :, SM.bufferCount) = 0;
      SM.bufferCount = SM.bufferCount + 1;
      
      if SM.bufferCount > SM.bufferMax
        SM.bufferCount = 1;
      end
    end
    
    function SM = updateSynapses(SM, NM, dt)
        
      % update synaptic currents
      SM.I_syn = (SM.g_exp+SM.g_exp_2) .* (NM.v() - SM.E_reversal);
          
      
      % update synaptic conductances
      kg = - SM.g_exp ./ SM.tau;
      k2g_in = SM.g_exp + 0.5 .* dt .* kg;
      kg = - k2g_in ./ SM.tau;
      SM.g_exp = SM.g_exp + dt .* kg;
      
      kg_n = - SM.g_exp_2 ./ SM.tau_2;
      k2g_in_n = SM.g_exp_2 + 0.5 .* dt .* kg_n;
      kg_n = - k2g_in_n ./ SM.tau_2;
      SM.g_exp_2 = SM.g_exp_2 + dt .* kg_n;

      
    end


    
    function SM = randomInit(SM, g_mean, g_std,g_mean2,g_std2 )
      SM.g_exp = g_std .* randn(size(SM.g_exp)) + g_mean;
      SM.g_exp(SM.g_exp < 0) = 0;
      SM.g_exp2 = g_std2 .* randn(size(SM.g_exp2)) + g_mean2;
      SM.g_exp2(SM.g_exp2 < 0) = 0;
      
      
    end
    

  end % methods
  
  methods(Static)
      function params = get2expParams()
          params = {'tau_2', 'scaler_2'};
      end
     function params = getRequiredParams()
          params = [SynapseModel_g_2exp.get2expParams() SynapseModel_g_exp.getRequiredParams()];
      end
  end

end % classdef
