function [posttopresynarr ] = getPosttoPreSynArr( synarr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
posttopresynarr = cell(length(synarr),1);
disp('Finding the neuron ids of synapses on to each neuron. May take a while...')
for i = 1:length(synarr)
    for j = 1:length(synarr)
        if sum(synarr{j,1}==i)>0
            posttopresynarr{i}(end+1) = j;
        end
    end
end
end

