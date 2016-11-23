classdef SynapseModel_g_stp < SynapseModel
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
    function SM = SynapseModel_g_stp(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre)
      SM = SM@SynapseModel(Neuron, number_in_post);
      SM.E_reversal = CP.E_reversal{postID};
      SM.tF = CP.tF{postID};
      SM.tD = CP.tD{postID};
      SM.facilitation = CP.facilitation{postID};
      SM.depression = CP.depression{postID};
      SM.tau = CP.tau{postID};
      SM.bufferCount = 1;
      maxDelaySteps = SimulationSettings.maxDelaySteps;
      numComparts = Neuron.numCompartments;
      SM.g_exp = zeros(number_in_post, numComparts);

      SM.F = ones(number_in_pre, 1);
      SM.D = ones(number_in_pre, 1);
      
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

    function [SM] = bufferIncomingSpikes(SM, synIndeces, weightsToAdd, preInd, pregroup)
        preInd = preInd-pregroup;
        %In stp the changes to facilitation and depression depend only on
        %the presynaptic activity. When this function is called we know
        %that a spike has been generated in the neurons identified by
        %preInd which we also know are connected to the 
        %update the facilitation variable by adding the facilitation rate
        SM.F(preInd) = SM.facilitation + SM.F(preInd);
        SM.D(preInd) = SM.depression * SM.D(preInd);
        
        %Add the weights multiplied by the plasticity variables to the
        %spike accumulator at the postsynaptic neuron (and compartment and
        %time) determined by synIndeces.
      SM.g_expEventBuffer(synIndeces) = ...
                            SM.g_expEventBuffer(synIndeces) + ((weightsToAdd) .*(SM.F(preInd) * SM.D(preInd)));
      
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
