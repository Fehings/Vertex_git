classdef NeuronModel_adex_RK < NeuronModel
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
      NM.w = zeros(number, 1);
      NM.spikes = [];
    end
    
    function [NM] = updateNeurons(NM, IM, N, SM, dt)
      I_syn = NeuronModel.sumSynapticCurrents(SM);
      I_input = NeuronModel.sumInputCurrents(IM);
       
      % k1 step
      
      kv1 = bsxfun(@rdivide, (-bsxfun(@times, N.g_l, (NM.v - N.E_leak)) -...
        I_syn - NM.I_ax + I_input), N.C_m);
      kv1(:, 1) = kv1(:, 1) + ...
        (((N.g_l(:, 1) .* N.delta_t) .* ...
        exp((NM.v(:, 1) - N.V_t) ./ N.delta_t) - NM.w) ./  ...
        N.C_m(:, 1));
      
      kw1 = (N.a .* (NM.v(:, 1) - N.E_leak) - NM.w) ./ N.tau_w;
      
      % k2 step
      
      k2v_in = NM.v + 0.5 .* dt .* kv1;
      k2w_in = NM.w + 0.5 .* dt .* kw1;
      
      kv2 = bsxfun(@rdivide,(-bsxfun(@times, N.g_l,(k2v_in - N.E_leak)) -...
        I_syn - NM.I_ax + I_input), N.C_m);
      kv2(:, 1) = kv2(:, 1) + ...
        (((N.g_l(:, 1) .* N.delta_t) .* ...
        exp((k2v_in(:, 1) - N.V_t) ./ N.delta_t) - NM.w) ./  ...
        N.C_m(:, 1));
      
      kw2 = (N.a .* (NM.v(:, 1) - N.E_leak) - k2w_in) ./ N.tau_w;
      
      % k3 step
      
      k3v_in = NM.v + 0.5 .* dt .* kv2;
      k3w_in = NM.w + 0.5 .* dt .* kw2;
      
      kv3 = bsxfun(@rdivide,(-bsxfun(@times, N.g_l,(k3v_in - N.E_leak)) -...
        I_syn - NM.I_ax + I_input), N.C_m);
      kv3(:, 1) = kv3(:, 1) + ...
        (((N.g_l(:, 1) .* N.delta_t) .* ...
        exp((k3v_in(:, 1) - N.V_t) ./ N.delta_t) - NM.w) ./  ...
        N.C_m(:, 1));
      
      kw3 = (N.a .* (NM.v(:, 1) - N.E_leak) - k3w_in) ./ N.tau_w;
      
      % k4 step
      
      k4v_in = NM.v + dt .* kv3;
      k4w_in = NM.w + dt .* kw3;
      
      kv4 = bsxfun(@rdivide,(-bsxfun(@times, N.g_l,(k4v_in - N.E_leak)) -...
        I_syn - NM.I_ax + I_input), N.C_m);
      kv4(:, 1) = kv4(:, 1) + ...
        (((N.g_l(:, 1) .* N.delta_t) .* ...
        exp((k4v_in(:, 1) - N.V_t) ./ N.delta_t) - NM.w) ./  ...
        N.C_m(:, 1));
      
      kw4 = (N.a .* (NM.v(:, 1) - N.E_leak) - k4w_in) ./ N.tau_w;
      
      % weighted sum of the above:
      
      kv = (1/6)*(kv1+2*kv2+2*kv3+kv4);
      kw = (1/6)*(kw1+2*kw2+2*kw3+kw4);
      
      NM.v = NM.v + dt .* kv;
      NM.w = NM.w + dt .* kw;
      NM.spikes = NM.v(:,1) >= N.v_cutoff;
      NM.v(NM.spikes, 1) = N.v_reset;
      NM.w(NM.spikes, 1) = NM.w(NM.spikes, 1) + N.b;
    
  end % methods
  
    function spikes = get.spikes(NM)
          spikes = NM.spikes;
    end
  
  end
  
  methods(Static)
    
    function params = getRequiredParams()
      params = [getRequiredParams@NeuronModel, ...
                {'a','b','tau_w','delta_t','V_t','v_cutoff'}];
    end
  end
end % classdef