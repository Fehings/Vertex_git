
stimstrength=4;
TP.StimulationField = invitroSliceStim('catvisblend1.stl',stimstrength);
% uncomment for tRNS:
%TP.tRNS = wgn(1,1,0);

% Uncomment below for AC stim (either loading from file or calculating with
% invitroSliceStimAC.
%Field = load('ACpderesult40hz10mv.mat');
%TP.StimulationField = Field.result;
%B=50000; % the frequency in Hz.
%TP.StimulationField = invitroSliceStimAC('catvisblend1.stl',SS.timeStep,stimstrength,B);

% Assign start and stop times for stimulation. These can be vectors of time
% points if you want multiple bursts of stimulation.
TP.StimulationOn = 0;
TP.StimulationOff = SS.simulationTime;

