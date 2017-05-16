classdef NeuronModel_passive < NeuronModel
  %NeuronModel_passive Purely passive neurons. No additional parameters.
  properties (SetAccess = private)
    number
    spikes
  end
  
  methods
    function NM = NeuronModel_passive(Neuron, number)
      NM = NM@NeuronModel(Neuron, number);
      NM.v = Neuron.E_leak .* ones(number, Neuron.numCompartments);
      NM.number = number;
      NM.spikes = [];
    end
    
    function [NM] = updateNeurons(NM, IM, N, SM, dt)
      NM = updateNeurons@NeuronModel(NM, IM, N, SM, dt);
    end
    
    function spikes = get.spikes(NM)
      spikes = NM.spikes;
    end
    
    function NM = assignSpikes(NM,spikes)
        NM.spikes = spikes;
    % as passive neurons can't spike on their own, this method allows
    % spikes to be assigned to them, intended particularly for use in the
    % multiregional simulations where dummy passive neurons work as
    % conduits for the spikes that should be passed from another external
    % population. 'spikes' should be a logical vector the length of the
    % number of passive dummy neurons in the current region.
    end
  end % methods
end % classdef