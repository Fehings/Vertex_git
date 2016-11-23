classdef SynapseModel_g_stdp < SynapseModel
  %SynapseModel_g_exp Conductance-based single exponential synapses
  %   Parameters to set in ConnectionParams:
  %   - E_reversal, the reversal potential (in mV)
  %   - tau, the synaptic decay time constant (in ms)

  properties (SetAccess = protected)
    facilitation
    F
    tF
    depression
    D
    tD
    E_reversal
    tau
    g_exp
    g_expEventBuffer
    bufferCount
    bufferMax
  end
  
  methods
      % Synapse model will be a cell array containing a struct for each
      % connection type indexed by the post
    function SM = SynapseModel_g_stdp(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre)
      SM = SM@SynapseModel(Neuron, number_in_post);
      SM.E_reversal = CP.E_reversal{postID};
      SM.tPre = CP.tPre{postID};
      SM.tPost = CP.tPost{postID};
      SM.facilitation = CP.facilitation{postID};
      SM.depression = CP.depression{postID};
      SM.tau = CP.tau{postID};
      SM.bufferCount = 1;
      maxDelaySteps = SimulationSettings.maxDelaySteps;
      numComparts = Neuron.numCompartments;
      SM.g_exp = zeros(number_in_post, numComparts);

      %trace variable for presynaptic neurons, contains an entry for each
      %neuron in the presynaptic group of the connection.
      SM.Apre = ones(number_in_pre, 1);
      SM.Apost = ones(number_in_pre, 1);
      SM.g_expEventBuffer = zeros(number_in_post, numComparts, maxDelaySteps);
      SM.bufferMax = maxDelaySteps;

      if SM.tau <= 0
        error('vertex:SynapseModel_g_exp', ...
           'tau must be greater than zero');
      end
    end

    
    function SM = updateBuffer(SM)
       %Extract spike acumulator value at current buffer location
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
      SM.F = SM.F + ((1 - SM.F)./SM.tF).*dt;
      SM.D = SM.D + ((1 - SM.D)./SM.tD).*dt;
    end

    %The is called when spikes are generated in neurons specified by preInd
    function [SM,warr] = bufferIncomingSpikes(SM, synIndeces, weightsArr, preInd, pregroup)
        preInd = preInd-pregroup;
        %update presynaptic trace variable Apre, should be same for all
        %presynaptic connections because the synapse parameters should be
        %the same for all group to group defined connections. 
        Apre = 
        %update the weight array for all connections to presynaptic
        %neurons. 
        %update postsynaptic trace variable Apost, again should be the same
        %for all as is only dependent on the post synaptic activity. 
        %update weights for postsynaptically connected neurons.
        
        
    
      SM.g_expEventBuffer(synIndeces) = ...
                            SM.g_expEventBuffer(synIndeces) + ((weightsToAdd)));
      
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
      function params = getRequiredParams()
          params = {'tau', 'E_reversal', 'tD','tF','facilitation','depression'};
      end
  end

end % classdef
