
% quick script for looping the stimulation_3D_2 script with different
% stimulation values.
%clear vars
steps = [-2 -1 -0.5 -0.2 0.2 0.5 1 2]; % change range?

% load firing rates from zero stim run
%firingatzero = load() % fill this bit in!





for i=1:length(steps) 
    stimstrength = steps(i) 
    stimulation_3D_2
    
    if sum(firingatzero-firingRates) == 0
        continue
    else
        disp('Stop condition met, the stim strength = ', num2str(stimstrength))
        break
    end
    
    
    %clear vars
    close all
end


