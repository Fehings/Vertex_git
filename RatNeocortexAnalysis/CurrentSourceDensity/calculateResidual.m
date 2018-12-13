function [residual] = calculateResidual(Resultssyn, Resultsnosyn, time)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
syntvec = getTimeVector(Resultssyn).*1000;
nosyntvec = getTimeVector(Resultsnosyn).*1000;
timesyn = syntvec > (Resultssyn.params.TissueParams.StimulationOn - time/2)+1 & syntvec < (Resultssyn.params.TissueParams.StimulationOff + time);
timenosyn = nosyntvec > (Resultsnosyn.params.TissueParams.StimulationOn - time/2)+1 & nosyntvec < (Resultsnosyn.params.TissueParams.StimulationOff + time);

if iscell(Resultssyn.LFP)
    for iGroup = 1:length(Resultssyn.LFP)
        baseline = Resultsnosyn.LFP{iGroup}(:,timenosyn);
        res = Resultssyn.LFP{iGroup}(:,timesyn);
        residual{iGroup} = res-baseline(:,1:size(res,2)); 
    end
else
     residual = Resultssyn.LFP(:,timesyn) -Resultsnosyn.LFP(:,timenosyn); 
end
end

