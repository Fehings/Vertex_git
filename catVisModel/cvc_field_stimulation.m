
%stimstrength=10;
%B=30; % the frequency in Hz.
%TP.StimulationField = invitroSliceStimAC('catvisblend1.stl',SS.timeStep,stimstrength,B);
%TP.StimulationField = invitroSliceStim('catvisblend1.stl',stimstrength);

Field = load('ACpderesult40hz10mv.mat');
TP.StimulationField = Field.result;

for i = 1:length(NP)
    NP(i).Input(2).inputType = 'i_efield';
    NP(i).Input(2).timeOn = 0;
    NP(i).Input(2).timeOff = SS.simulationTime ;
   %NeuronParams(i).Input(2).timeDependence = 'rand'; % have 'oscil' and 'rand' as flags
end

SS.ef_stimulation = true;
SS.fu_stimulation = false;