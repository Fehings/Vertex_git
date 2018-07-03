
brainslice3Dorig % this script sets up the electric field, open to modify.
TP.StimulationField = result; % assign the result to the tissue paramters.

% Assign start and stop times for stimulation. These can be vectors of time
% points if you want multiple bursts of stimulation.
TP.StimulationOn = 0;
TP.StimulationOff = SS.simulationTime;

