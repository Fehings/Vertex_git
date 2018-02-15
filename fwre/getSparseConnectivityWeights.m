function [ sparseConnectivity ] = getSparseConnectivityWeights( weightArr, synArr,N)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
wcount = 0;
for iN = 1:size(synArr, 1)
    s = synArr{iN, 1};
    allpost(wcount+1:wcount+length(s)) = s;
    allpre(wcount+1:wcount+length(s)) = iN;
    allweight(wcount+1:wcount+length(s)) = weightArr{iN};
    wcount = wcount+length(s);
end
    

sparseConnectivity = sparse(double(allpost(1:wcount)), ...
    double(allpre(1:wcount)), ...
    double(allweight(1:wcount)), N, N);


end

