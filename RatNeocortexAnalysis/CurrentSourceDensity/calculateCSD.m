function [CSD] = calculateCSD(LFP)
%plotCSD Calculates the current source density calculated from the LFP matrix
%   Detailed explanation goes here
smoothedLFP = zeros(size(LFP));
for i = 1:size(LFP,1)
    smoothedLFP(i,:) = smooth(LFP(i,:)-median(LFP(i,:)));
end
CSD = diff(diff(smoothedLFP(1:16,:)));
end

