classdef InputModel_i_janrit < InputModel
    
      
  properties (SetAccess = private)
      extIn
      multiplier
  end
  
  methods
      function IM = InputModel_i_janrit(N, inputID, number, timeStep, compartmentsInput, subset)
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
      IM.multiplier = N.Input(inputID).multiplier;
    end
      
      function IM = getExternalInput(IM,externalIn)
          IM.extIn = sum(externalIn)*IM.multiplier;
      end
      
      function IM = updateInput(IM,~)
          IM.I_input=IM.extIn;
      end
    
  end
end