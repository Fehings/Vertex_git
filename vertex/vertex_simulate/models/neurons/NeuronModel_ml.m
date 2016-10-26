classdef NeuronModel_ml < NeuronModel
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
    m
    spikes
    canfire
  end
  
  methods
    function NM = NeuronModel_ml(Neuron, number)
      NM = NM@NeuronModel(Neuron, number);
      NM.v = Neuron.E_leak .* ones(number, Neuron.numCompartments);
      
      NM.w = ones(number, 1) .* NM.W_inf(NM.v(:,1), Neuron);
      NM.spikes = [];
      NM.canfire = logical(ones(number,1));
    end
    
    function [NM] = updateNeurons(NM, IM, N, SM, dt)
      I_syn = NeuronModel.sumSynapticCurrents(SM);
      I_input = NeuronModel.sumInputCurrents(IM);
      
      
      
      kv = bsxfun(@rdivide, (-bsxfun(@times, N.g_l, (NM.v - N.E_leak)) -...
        I_syn - NM.I_ax + I_input), N.C_m);
    
      I_Ca = -(N.g_Ca .* NM.M_inf(NM.v(:,1), N) .* (NM.v(:,1) - N.Ca_leak));
      I_K = -(N.g_K .* NM.w .*(NM.v(:,1) - N.K_leak));
      
      kv(:, 1) = kv(:, 1) + ((I_Ca + I_K) );
      t = NM.T_w(NM.v(:,1), N);
      kw = N.phi.*(NM.W_inf(NM.v(:,1), N) - NM.w)./t;
      
      
%       k2v_in = NM.v + 0.5 .* dt .* kv;
%       k2w_in = NM.w + 0.5 .* dt .* kw;
%       
%       kv = bsxfun(@rdivide,(-bsxfun(@times, N.g_l,(k2v_in - N.E_leak)) -...
%         I_syn - NM.I_ax + I_input), N.C_m);
%     
%       kv(:, 1) = kv(:, 1) - (N.g_Ca .* NM.m .* (k2v_in(:,1) - N.Ca_leak) - N.g_K .* NM.w .*(k2v_in(:,1) - N.K_leak) ./  N.C_m(:, 1));
%       
%       kw = (NM.W_inf(NM.v(:,1), N) - k2w_in)./ NM.T_w(NM.v(:,1), N);
      
      NM.v = NM.v + dt .* kv;
      NM.w = NM.w + dt .* kw;
      unstable = abs(NM.v)>500;
      NM.v(unstable) = N.E_leak;
      NM.w(unstable(:,1)) = NM.W_inf(N.E_leak, N);
      
      NM.spikes = NM.v(:,1) > N.v_cutoff & NM.canfire;
      
      %if the neuron had gone into inactive depolarised state
      % and its membrane potential has dropped below threshold, 
      % then it becomes active again.
      canfirezero= NM.canfire==0;
      NM.canfire(logical(canfirezero)) = NM.v(canfirezero,1) < N.v_cutoff;
      %if the neuron was previously in the active resting state (1) then if
      %it goes above threshold it becomes inactive
      canfireone= NM.canfire==1;
      NM.canfire(canfireone) = NM.v(canfireone,1) < N.v_cutoff;
         
    end
    
    function spikes = get.spikes(NM)
      spikes = NM.spikes;
    end
    
    function w_inf = W_inf(~,V, N)
        w_inf = (1+tanh((V - N.V3)./N.V4)).*0.5;
    end
    
    function m_inf = M_inf(~,V, N)
        m_inf = (1+tanh((V - N.V1)./N.V2)).*0.5;
    end
    function t_w = T_w(~,V, N)
        a = (V - N.V3)./(N.V4.*2);
        t_w = 1./cosh(a) ;
        %t_w(t_w==0) = t_w(t_w==0)+1*10^-1000;
    end
    
  end % methods
  
  
  
  methods(Static)
    
    function params = getRequiredParams()
      params = [getRequiredParams@NeuronModel, ...
                {'a','b','tau_w','delta_t','V_t','v_cutoff'}];
    end
  end
end % classdef