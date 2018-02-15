classdef SynapseModel_g_stp_nmda < SynapseModel
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
    tau_nmda
    g_exp
    g_exp_nmda
    g_expEventBuffer
    bufferCount
    bufferMax
    preBoundaryArr
    preGroupIDs
  end
  
  methods
    function SM = SynapseModel_g_stpnmda(Neuron, CP, SimulationSettings, ...
                                     postID, number_in_post,number_in_pre,pre_group_ids,~)
      SM = SM@SynapseModel(Neuron, number_in_post);
      SM.E_reversal = CP.E_reversal{postID};
      SM.tF = CP.tF{postID};
      SM.tD = CP.tD{postID};
      SM.facilitation = CP.facilitation{postID};
      SM.depression = CP.depression{postID};
      SM.tau = CP.tau{postID};
      SM.tau_nmda = 100;
      SM.bufferCount = 1;
      SM.preBoundaryArr = [0; cumsum(number_in_pre)];
      disp(number_in_pre)
      SM.preGroupIDs = pre_group_ids;
      maxDelaySteps = SimulationSettings.maxDelaySteps;
      numComparts = Neuron.numCompartments;
      %for each connection a conductance value for each neuron is stored. 
      %the weight of this is summed from all synapses onto the particular
      %compartment of the neuron for a particular group.
      SM.g_exp = zeros(number_in_post, numComparts);
      SM.g_exp_nmda = zeros(number_in_post, numComparts);
      
      %STP is only dependent only on the firing of the presynaptic neuron
      %so we to store the facilitation and depression modifiers for only
      %the presynaptic neurons in each object.
      SM.F = ones(sum(number_in_pre), 1);
      SM.D = ones(sum(number_in_pre), 1);
      
      
      %for each connection group an event buffer stores the spike accumulation at
      %each compartment for each time step of each post synaptic neuron. 
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
      SM.g_exp = SM.g_exp_nmda + SM.g_expEventBuffer(:, :, SM.bufferCount)*0.1;

      SM.g_expEventBuffer(:, :, SM.bufferCount) = 0;
      SM.bufferCount = SM.bufferCount + 1;
      
      if SM.bufferCount > SM.bufferMax
        SM.bufferCount = 1;
      end
    end
    
    function SM = updateSynapses(SM, NM, dt)
        
      % update synaptic currents
      SM.I_syn = (SM.g_exp +SM.g_exp_nmda) .* (NM.v() - SM.E_reversal);
      
      % update synaptic conductances
      kg = - SM.g_exp ./ SM.tau;
      k2g_in = SM.g_exp + 0.5 .* dt .* kg;
      kg = - k2g_in ./ SM.tau;
      SM.g_exp = SM.g_exp + dt .* kg;
      
      kg_n = - SM.g_exp_nmda ./ SM.tau_nmda;
      k2g_in_n = SM.g_exp_nmda + 0.5 .* dt .* kg_n;
      kg_n = - k2g_in_n ./ SM.tau_nmda;
      SM.g_exp_nmda = SM.g_exp_nmda + dt .* kg_n;
      
      SM.F = SM.F + ((1 - SM.F)./SM.tF).*dt;
      SM.D = SM.D + ((1 - SM.D)./SM.tD).*dt;
      %size(SM.F)
      
    end

    function [SM] = bufferIncomingSpikes(SM, synIndeces, weightsToAdd, preInd,groupID)
        
        
        %In stp the changes to facilitation and depression depend only on
        %the presynaptic activity. When this function is called we know
        %that a spike has been generated in the neurons identified by
        %preInd, an index then made relative to each synapse group by
        %subtracting the presynaptic group boundary.
        %update the facilitation variable by adding the facilitation rate
        preInd = preInd + SM.preBoundaryArr(SM.preGroupIDs==groupID);
        SM.F(preInd) = SM.facilitation + SM.F(preInd);
        SM.D(preInd) = SM.depression * SM.D(preInd);
        SM.g_expEventBuffer(synIndeces) = ...
            SM.g_expEventBuffer(synIndeces) + ((weightsToAdd) .*(SM.F(preInd) * SM.D(preInd)));
       
        
        %Add the weights multiplied by the plasticity variables to the
        %spike accumulator at the postsynaptic neuron (and compartment and
        %time) determined by synIndeces.

    end
    
    function SM = randomInit(SM, g_mean, g_std)
      SM.g_exp = g_std .* randn(size(SM.g_exp)) + g_mean;
      SM.g_exp(SM.g_exp < 0) = 0;
    end
    
    function g = get.g_exp(SM)
      g = SM.g_exp;
    end
    
    function [F, D] = getSTPVars(SM, preInd, groupID)
        preInd = preInd + SM.preBoundaryArr(SM.preGroupIDs==groupID);
        F = SM.F(preInd);
        D = SM.D(preInd);
    end
  end % methods
  
  methods(Static)
      function params = getRequiredParams()
          params = {'tau', 'E_reversal', 'tD','tF','facilitation','depression'};
      end
  end

end % classdef
