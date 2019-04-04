classdef NeuronModel_adex < NeuronModel
  %NeuronModel_adex Adaptive Exponential Integrate and Fire neuron model
  %   Parameters to set in NeuronParams in addition to passive parameters:
  %   - a, the adaptation coupling parameter (in nS)
  %   - b, the post-spike adaptation current increase (in pA)
  %   - tau_w, the adaptation time constant (in ms)
  %   - delta_t, the spike steepness (in mV)
  %   - V_t, the spike current initiation threshold
  %   - v_cutoff, the spike cutoff value (in mV, recommended to set to V_t+5 mV)
  
  properties (SetAccess = private)
    w
    spikes
  end
  
  methods
    function NM = NeuronModel_adex(Neuron, number)
      NM = NM@NeuronModel(Neuron, number);
      NM.v = Neuron.E_leak .* ones(number, Neuron.numCompartments);
      NM.w = zeros(number, length(Neuron.axon_ID));
      NM.spikes = [];
      
    end
    
    function [NM] = updateNeurons(NM, IM, N, SM, dt)
      I_syn = NeuronModel.sumSynapticCurrents(SM);
      I_input = NeuronModel.sumInputCurrents(IM);
       
    
       
    
      
      kv = bsxfun(@rdivide, (-bsxfun(@times, N.g_l, (NM.v - N.E_leak)) -...
        I_syn - NM.I_ax + I_input), N.C_m);
      kv(:, N.axon_ID) = kv(:, N.axon_ID) + ...
        (((N.g_l(:, N.axon_ID) .* N.delta_t) .* ...
        exp((NM.v(:, N.axon_ID) - N.V_t) ./ N.delta_t) - NM.w) ./  ...
        N.C_m(:, N.axon_ID));
      
      kw = (N.a .* (NM.v(:, N.axon_ID) - N.E_leak) - NM.w) ./ N.tau_w;
      
      k2v_in = NM.v + 0.5 .* dt .* kv;
      k2w_in = NM.w + 0.5 .* dt .* kw;
      
      kv = bsxfun(@rdivide,(-bsxfun(@times, N.g_l,(k2v_in - N.E_leak)) -...
        I_syn - NM.I_ax + I_input), N.C_m);
      kv(:, N.axon_ID) = kv(:, N.axon_ID) + ...
        (((N.g_l(:, N.axon_ID) .* N.delta_t) .* ...
        exp((k2v_in(:, N.axon_ID) - N.V_t) ./ N.delta_t) - NM.w) ./  ...
        N.C_m(:, N.axon_ID));
      
      kw = (N.a .* (NM.v(:, N.axon_ID) - N.E_leak) - k2w_in) ./ N.tau_w;
      
      NM.v = NM.v + dt .* kv;
      NM.w = NM.w + dt .* kw;
      
      
      NM.spikes = max(NM.v(:,N.axon_ID) >= N.v_cutoff,[],2);
      NM.v(NM.spikes, N.axon_ID) = N.v_reset;
      NM.w(NM.spikes,:) = NM.w(NM.spikes, :) + N.b;
      NM.v(NM.v>0) = 0;
    end
    
    function spikes = get.spikes(NM)
      spikes = NM.spikes;
    end
    
  end % methods
  
  methods(Static)
    
    function params = getRequiredParams()
      params = [getRequiredParams@NeuronModel, ...
                {'a','b','tau_w','delta_t','V_t','v_cutoff'}];
    end
  end
end % classdef
