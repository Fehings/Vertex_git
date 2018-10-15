classdef SynapseModel_g_exp < SynapseModel
  %SynapseModel_g_exp Conductance-based single exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - E_reversal, the reversal potential (in mV)
  %   - tau, the synaptic decay time constant (in ms)

  properties (SetAccess = protected)
    E_reversal
    tau
    g_exp
    g_expEventBuffer
    bufferCount
    bufferMax
  end
  
  methods
    function SM = SynapseModel_g_exp(Neuron, CP, SimulationSettings, ...
                                     postID, number,~,~,~)
      SM = SM@SynapseModel(Neuron, number);
      for param = SynapseModel_g_exp.getPostSynapticParams()
            SM.(param{1}) = getAttributeDist(CP,param,number,postID,SimulationSettings,false);
      end
      
      SM.bufferCount = 1;
      maxDelaySteps = SimulationSettings.maxDelaySteps;
      numComparts = Neuron.numCompartments;
      
      %for each connection a conductance value for each neuron is stored. 
      %the weight of this is summed from all synapses onto the particular
      %compartment of the neuron for a particular group.
      SM.g_exp = zeros(number, numComparts);
      
      %for each connection group an event buffer stores the spike accumulation at
      %each compartment for each time step of each post synaptic neuron. 
      SM.g_expEventBuffer = zeros(number, numComparts, maxDelaySteps);
      SM.bufferMax = maxDelaySteps;

      if min(SM.tau) <= 0
        error('vertex:SynapseModel_g_exp', ...
           'tau must be greater than zero');
      end
    end
    
    function SM = updateBuffer(SM)

      SM.g_exp = SM.g_exp + SM.g_expEventBuffer(:, :, SM.bufferCount);
      SM.g_expEventBuffer(:, :, SM.bufferCount) = 0;
      SM.bufferCount = SM.bufferCount + 1;
      
      if SM.bufferCount > SM.bufferMax
        SM.bufferCount = 1;
      end
    end
    
    function SM = updateSynapses(SM, NM, dt)
        
      % update synaptic currents
      SM.I_syn = SM.g_exp .* (NM.v() - SM.E_reversal);

      % update synaptic conductances
      kg = - SM.g_exp ./ SM.tau;
      k2g_in = SM.g_exp + 0.5 .* dt .* kg;
      kg = - k2g_in ./ SM.tau;
      SM.g_exp = SM.g_exp + dt .* kg;
    end
    
    
    function SM = bufferIncomingSpikes(SM, synIndeces, weightsToAdd)
      SM.g_expEventBuffer(synIndeces) = ...
                            SM.g_expEventBuffer(synIndeces) + weightsToAdd;
      
    end
    function set_event_buffer(SM,buffer, synIndeces)
        SM.g_expEventBuffer(synIndeces) = ...
            buffer(synIndeces);
    end
    function buffer = get_event_buffer(SM)
        buffer = SM.g_expEventBuffer;
    end
    
    function SM = randomInit(SM, g_mean, g_std)
      SM.g_exp = g_std .* randn(size(SM.g_exp)) + g_mean;
      SM.g_exp(SM.g_exp < 0) = 0;
    end
    
    function g = get.g_exp(SM)
      g = SM.g_exp;
    end

  end % methods
  
  
  methods(Static)

    function params = getPostSynapticParams()
          params = {'tau', 'E_reversal'};
    end
     function params = getRequiredParams()
      params = SynapseModel_g_exp.getPostSynapticParams();
    end
  end
end % classdef
