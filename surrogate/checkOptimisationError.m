function [error] = checkOptimisationError(Results,Ideal,checkType)
% a function to check the output of a simulation against the desired
% result. 
%Result is the Result of the simulation, while Ideal is the result that you
%want from the simulation, which can come in a number of forms. checkType
%is a string which determines what type of result you are looking to
%compare.


if checkType == 'spikeCount'
    % this requires Ideal to be an integer (or a range?) representing the
    % number of spikes for the time period of the simulation. This can be
    % found by running  apreliminary simulation without a stimulation
    % field, checking the number of spikes (the number within the
    % time length that the optimisation sims will run for)
    
    error = abs(Ideal - length(Results.spikes(:,1)));
    
%elseif checkType == 'spikePattern'
    
    
%elseif checkType == 'PYspike'
    
    
%elseif checkType == 'oscfreq'
       
end

end



