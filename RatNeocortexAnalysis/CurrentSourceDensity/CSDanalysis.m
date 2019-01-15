LFP = zeros(size(Results.LFP));
for i = 1:size(Results.LFP,1)
    LFP(i,:) = smooth(Results.LFP(i,:)-median(Results.LFP(i,:)));
end
CSD = diff(diff(LFP(1:16,:)));
