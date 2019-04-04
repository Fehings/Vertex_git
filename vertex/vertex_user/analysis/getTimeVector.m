function time = getTimeVector(Results,units)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
if nargin == 1
    units = 's';
end
if strcmp(units,'ms')
    time = ((1:length(Results.params.RecordingSettings.samplingSteps))./Results.params.RecordingSettings.sampleRate).*1000;
elseif strcmp(units, 's')
    time = ((1:length(Results.params.RecordingSettings.samplingSteps))./Results.params.RecordingSettings.sampleRate).*1;
end
    
end

