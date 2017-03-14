function [posttopresynarr ] = getPosttoPreSynArr( synarr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
posttopresynarr = cell(length(synarr),2);
numrows = length(synarr)
disp('Finding the neuron ids of synapses on to each neuron. May take a while...')
count = zeros(numrows);
for i = 1:length(synarr)
    for j = 1:length(synarr)
        x = find(synarr{j,1}==i);
        count(i) = count(i) +length(x);
    end
end

for i = 1:length(synarr)
    posttopresynarr{i,1} = zeros(count(i),1);
end

for i = 1:length(synarr)
    index = 1;
    for j = 1:length(synarr)
         x = find(synarr{j,1}==i);
         if ~isempty(x)
             for k = 1:length(x)
                 posttopresynarr{i,1}(index) = j;
                 posttopresynarr{i,2}(index) = x(k);
                 index = index+1;
             end
         end
    end
end


end

