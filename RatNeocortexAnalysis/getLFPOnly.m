function [LFP,time,params] = getLFPOnly(directoryname)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
Results = loadResults(directoryname);
for i = 1:size(Results.LFP,1)
    LFP(i,:) = Results.LFP(i,:)-median(Results.LFP(i,:));
end
time = getTimeVector(Results);
params = Results.params;
end

