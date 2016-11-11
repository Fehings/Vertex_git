classdef InputModel_i_efield < InputModel
  %InputModel_i_step Step input current
  %   Parameters to set in NeuronParams.Input:
  %   - amplitude, the step current amplitude (in pA). This can either be a
  %   single value for all the neurons in the group, or an array of length
  %   equal to the number of neurons in the group, specifying the
  %   amplitude per neuron.
  %   - timeOn, the simulation time (in ms) to turn the current on.
  %   - timeOff, the simulation time (in ms) to turn the current off.
  %
  %   Optional parameters to set in NeuronParams.Input:
  %   - compartmentsInput, which compartments of the neurons the current
  %   should be applied to. If not specified, the current is applied to
  %   all compartments. For standard somatic current injection,
  %   compartmentsInput should be set to 1.
  %   
  %   The current is weighted by compartment membrane area.
  
  properties (SetAccess = private)
    count
    oscount
    stepOn
    stepOff
    meanInput
  end
  
  methods
    function IM = InputModel_i_efield(N, inputID, number, timeStep, compartmentsInput, subset)
      %narginchk(4, 6)
      if nargin == 4
        compartmentsInput = 1:N.numCompartments;
        subset = 1:number;
      elseif nargin == 5
        subset = 1:number;
      end
      N.Input(inputID).amplitude = 0;
      N.Input(inputID).meanInput = N.Input(inputID).amplitude;
      
      IM = IM@InputModel(N, inputID, number, compartmentsInput, subset);
      IM = setupStepCurrent(IM, N, inputID, timeStep, subset);
    end
    
    function IM = setupStepCurrent(IM, N, inputID, timeStep, subset)
      
      mi = N.Input(inputID).amplitude(:);
      IM.meanInput = bsxfun(@times, mi, IM.membraneAreaRatio);
      if size(IM.meanInput, 1) > 1
        IM.meanInput = IM.meanInput(subset, :);
      end
      IM.count = 1; % initialise count
      IM.oscount = 1; % in case of oscillatory stim, initialise a second count to tick through time dimensions.
      if N.Input(inputID).timeOn <= 0
        IM.stepOn  = 1;
      else
        IM.stepOn  = round(N.Input(inputID).timeOn  / timeStep);
      end
      IM.stepOff = round(N.Input(inputID).timeOff / timeStep);
      IM.I_input = IM.I_input .* 0;
    end
    
    
    function IM = updateInput(IM,NI,activation)
        
        if isfield(NI,'timeDependence')
            
            if strcmp(NI.timeDependence,'rand')
            %multiply activation by a random number
            activation = activation.*wgn(1,1,0); 
            
            % multiply by a random number generated via matlab's random white gaussian noise function.
            elseif strcmp(NI.timeDependence,'oscil')
            %in this case the activation matrix should have an extra time
            %dimension that will need to be stepped through, need to figure
            %this out.
            max_oscount=size(activation,3); % maximum should be the max number of time dimensions present
            activation=activation(:,:,IM.oscount);
            %activation = activation;
            IM.oscount=IM.oscount + 1;
                if IM.oscount > max_oscount
                     IM.oscount = 1; % reset oscount when it gets above the max number of time dimensions. 
                end
    
            else
            activation = activation;
            end
        end
        
        
        IM.meanInput = bsxfun(@times, activation', IM.membraneAreaRatio);
        
     if IM.count >= IM.stepOn && IM.count <= IM.stepOff
            IM.I_input = IM.meanInput;
     else 
            IM.I_input = 0;
     end
        IM.count = IM.count + 1;
    
    end
    
    function I = getRecordingVar(IM)
      I = IM.I_input;
    end
    
  end % methods
  
  methods(Static)
    function params = getRequiredParams()
      params = {};
    end
  end
  
end % classdef