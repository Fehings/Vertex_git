%% CVC step current -> add a step current to the simulation
% NB: at the moment this requires adding a current to every population, so
% here this is done in a loop. If you do not want a current for a given
% population, just set the on time to be later than the simulation end
% time.


for i=1:TP.numGroups
    NP(i).Input(2).inputType = 'i_step';
    NP(i).Input(2).amplitude = 500;
    NP(i).Input(2).timeOn = 350;
    NP(i).Input(2).timeOff = 351;
end