classdef InputModel_i_focusedultrasound < InputModel % inherits from InputModel class
  %InputModel_i_focusedultrasound focused ultrasound capacitance displacement current input 
  % NB: also needs to have a track of the membrane capacitance changes in
  % general.
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
    meanInput
    fusParams
  end
  
  methods
    function IM = InputModel_i_focusedultrasound(N, inputID, number, timeStep, compartmentsInput, subset)
      %narginchk(4, 6)
      if nargin == 4 % if compartmentsInput is not specified, define it here.
          % N is presumably neuron pop. info and number the number of
          % neurons in the population?
        compartmentsInput = 1:N.numCompartments;
        subset = 1:number;
      elseif nargin == 5 % if subset not specified define here
        subset = 1:number;
      end
      N.Input(inputID).amplitude=0;
      N.Input(inputID).meanInput = N.Input(inputID).amplitude; % set the mean input to equal the amplitude passed to the object? 
      IM = IM@InputModel(N, inputID, number, compartmentsInput, subset);
      IM = setupStepCurrent(IM, N, inputID, timeStep, subset);
    end % IM is the output of this method, it calls setupStepCurrent, defined next.
    
    function IM = setupStepCurrent(IM, N, inputID, timeStep, subset)
      
      mi = N.Input(inputID).amplitude(:);
      IM.meanInput = bsxfun(@times, mi, IM.membraneAreaRatio);
      if size(IM.meanInput, 1) > 1
        IM.meanInput = IM.meanInput(subset, :);
      end
      IM.I_input = IM.I_input .* 0;
    end 
    
    function IM = updateInput(IM,fusParams)

        IM.I_input = fusParams.dCmVm;
        %unique(fusparams.dCmVm)
        %unique(IM.I_input)
    end
    
    function StimParams = updateCapacitance(~,NM,ultrasound,fusparams,simStep)
        % NM.v is the voltage membrane potential, ultrasound is the acoustic 
        % pressure found from a FEM and fusparams are previously defined. 
        %this calculates the dCmVm value, which acts as an input current. It also
%calculates capacitance, which is stored in fusparams and extracted in
%groupUpdateSchedule.
        StimParams.fusparams = fusBLS(ultrasound',NM.v,fusparams,simStep);
        unique(StimParams.fusparams.C)
    end
    
    function I = getRecordingVar(IM)
      I = IM.I_input;
    end
    
  end % methods
  
  methods(Static)
    function params = getRequiredParams()
      params = {};
      
    end % parameters to be attached to this object 
  end
  
end % classdef