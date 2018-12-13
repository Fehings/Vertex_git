function [peaks, troughs] = getpeaksofresponse(LFP,params)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
LFP = LFP - median(LFP);
startstep = ((params.TissueParams.StimulationOff(1)*params.RecordingSettings.sampleRate)./1000) + 1;
stopstep =  (params.TissueParams.StimulationOn(2)*params.RecordingSettings.sampleRate./1000)-1 ;
baselinestart = ((params.TissueParams.StimulationOn(1)*params.RecordingSettings.sampleRate)./1000) - 11;
baselinestop = ((params.TissueParams.StimulationOn(1)*params.RecordingSettings.sampleRate)./1000) - 1;
baseline = mean(LFP(baselinestart:baselinestop));
[max1, additionalstep] = max(LFP(startstep:stopstep));
startstep = startstep + additionalstep;

min1 = min(LFP(startstep:stopstep));
startstep = (params.TissueParams.StimulationOff(2)*params.RecordingSettings.sampleRate./1000) + 1;

baselinestart = ((params.TissueParams.StimulationOn(2)*params.RecordingSettings.sampleRate)./1000) - 11;
baselinestop = ((params.TissueParams.StimulationOn(2)*params.RecordingSettings.sampleRate)./1000) - 1;
baseline = mean(LFP(baselinestart:baselinestop));

[max2, additionalstep] = max(LFP(startstep:startstep+additionalstep*2));
startstep = startstep + additionalstep;
max2 = max2-baseline;

min2 = min(LFP(startstep:end));

min2 =min2 - baseline ;

peaks = [max1, max2];
troughs = [min1, min2];
end

