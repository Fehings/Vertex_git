classdef NeuronModel < handle
  properties (SetAccess = protected)
    v
    I_ax
    treeChildren
    midpoints
    incorporate_vext
    maxExtracellularPotential
    %doUpdate
  end
 properties (SetAccess = private)

    v_ext

    %doUpdate
 end
  
  methods
    function NM = NeuronModel(Neuron, number)
      NM.v = zeros(number, Neuron.numCompartments);
      NM.I_ax = zeros(number, Neuron.numCompartments);
      NM.treeChildren = length(Neuron.adjCompart);
      NM.v_ext = zeros(number, Neuron.numCompartments);
      if isfield(Neuron, 'v_ext')
        setVext(NM,Neuron.v_ext);
      end
      NM.incorporate_vext = false;
      NM.maxExtracellularPotential = 500;
      %NM.doUpdate = true(size(NM.v, 1));
    end
    
    function [NM] = updateNeurons(NM, IM, N, SM, dt)
      I_syn = NeuronModel.sumSynapticCurrents(SM);
      I_input = NeuronModel.sumInputCurrents(IM);
      
 
      kv = bsxfun(@rdivide, (-bsxfun(@times, N.g_l, (NM.v - N.E_leak)) -...
        I_syn - NM.I_ax + I_input), N.C_m);
      
      k2v_in = NM.v + 0.5 .* dt .* kv;
      
      kv = bsxfun(@rdivide,(-bsxfun(@times, N.g_l,(k2v_in - N.E_leak)) -...
        I_syn - NM.I_ax + I_input), N.C_m);
      
      NM.v = NM.v + 0.5 .* dt .* kv;
%        if max(abs(kv)>0.00001)
%           [a,i] = max(abs(kv)>0.00001);
%           error(['First deviation at compartment: ' num2str(i)]);
%       end
    end
    
    function [NM] = updateI_ax(NM, N)
      % update axial currents
      NM.I_ax = NM.I_ax .* 0;
      %tree children is max number of children (neighbours) a node can have
      %so vectorised over all compartments for each connecting neighbour
      for iTree = 1:NM.treeChildren %3
          %Axial current is proportional to the difference between the
          %membrane potential in adjacent compartments
        NM.I_ax(:, N.adjCompart{iTree}(1, :)) = ...
          NM.I_ax(:, N.adjCompart{iTree}(1, :)) + ...
          bsxfun(@times, N.g_ax{iTree}, ...
                         (NM.v(:, N.adjCompart{iTree}(1, :)) - ...
                         NM.v(:, N.adjCompart{iTree}(2, :))));
      end
     %disp('initial axial current')
     %max(max(NM.I_ax))
         if NM.incorporate_vext
             %tree children is max number of children (neighbours) a node can have
             %so vectorised over all compartments for each connecting neighbour
             for iTree = 1:NM.treeChildren
                 %Additional Axial current caused by temporary v_ext change is proportional to the difference between the
                  %external potential in adjacent compartments
                  NM.I_ax(:, N.adjCompart{iTree}(1, :)) = ...
                      NM.I_ax(:, N.adjCompart{iTree}(1, :)) + ...
                      bsxfun(@times, N.g_ax{iTree}, ...
                      (NM.v_ext(:, N.adjCompart{iTree}(1, :)) - ...
                      NM.v_ext(:, N.adjCompart{iTree}(2, :))));

              end
         end

         

    end

      
    
    
    function v = get.v(NM)
      v = NM.v;
    end
    
    function I_ax = get.I_ax(NM)
      I_ax = NM.I_ax;
    end
    function v_ext = get.v_ext(NM)
      v_ext = NM.v_ext;
    end
    %function NM = setSilentNeurons(NM, IDs)
    %  NM.doUpdate(IDs) = false;
    %end
    
    function s = spikes(NM)
      s = false(size(NM.v,1),1);
    end
      
  function setVext(NM,V_ext)
    NM.v_ext = V_ext;
    NM.v_ext(NM.v_ext>NM.maxExtracellularPotential) =  NM.maxExtracellularPotential;
    NM.v_ext(NM.v_ext<-NM.maxExtracellularPotential) = - NM.maxExtracellularPotential;
%     maxvoltage = 10000;
%     maxvs = max(abs(NM.v_ext)');
%     i_gt = max(abs(NM.v_ext)')>maxvoltage;
%     ratio = maxvoltage./maxvs(i_gt);
%     NM.v_ext(i_gt,:) = NM.v_ext(i_gt,:).*(maxvoltage./maxvs(i_gt))';
    
    if min(size(NM.v_ext) ~= size(NM.I_ax))
        throw(MException('NeuronModel:setVextError', ...
            ['V_ext should be of the same size as I_ax: size(I_ax) = '...
            num2str(size(NM.I_ax)) ' size(I_ax) = '  num2str(size(NM.v_ext))] ));
    end

  end
  
  function stimulationOn(NM)
      NM.incorporate_vext = true;
  end
    
  function stimulationOff(NM)
      NM.incorporate_vext = false;

  end
  
  function setmidpoints(NM,midpoints)
      NM.midpoints = midpoints;
  end
  
    
  end % methods

  methods(Static)
    
    function params = getRequiredParams()
      params = {'C_m','g_l','g_ax','adjCompart','E_leak'};
    end

    function [I_syn] = sumSynapticCurrents(SM)
      first = true;
      for iSyn = 1:size(SM, 2)
        if ~isempty(SM{iSyn})
          if first
            I_syn = SM{iSyn}.I_syn();
            first = false;
          else
              I_syn = I_syn + SM{iSyn}.I_syn();
          end
        end
      end
      if first % no synapses to update, so return 0
        I_syn = 0;
      end
    end
    
    function [I_input] = sumInputCurrents(IM)
      I_input = 0;
      for iIn = 1:size(IM, 2)
        if iIn == 1
          if ~isempty(IM{iIn})
            I_input = IM{iIn}.I_input();
          end
        else
          if ~isempty(IM{iIn})
            I_input = I_input + IM{iIn}.I_input();
          end
        end
      end
    end
    
  end % methods(Static)
end % classdef
