function [ revsynarr ] =reverseSynArr( synarr )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
numrows = length(synarr);
revsynarr = cell(numrows,1);
count = ones(numrows,1);
for i= 1:numrows
    for j = 1:length(synarr{i,1})
        
        revsynarr{synarr{i,1}(j),1}(count(synarr{i,1}(j))) = i;
        revsynarr{synarr{i,1}(j),2}(count(synarr{i,1}(j))) = j;
         revsynarr{synarr{i,1}(j),3}(count(synarr{i,1}(j))) = synarr{i,3}(j);
        count(synarr{i,1}(j)) = count(synarr{i,1}(j)) + 1;
    end
end

end

