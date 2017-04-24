function [posttopresynarr ] = getPosttoPreSynArr( synarr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
posttopresynarr = cell(length(synarr),2);
numrows = length(synarr);
disp('Finding the neuron ids of synapses on to each neuron. May take a while...')
count = zeros(numrows);
% find the number of presynatpic connections for each neuron
for i = 1:length(synarr)
    for j = 1:length(synarr)
        x = find(synarr{j,1}==i);
        count(i) = count(i) +length(x);
    end
end
%construct the cell array to contain the empty arrays for each neuron of
%the size calculated above
for i = 1:length(synarr)
    posttopresynarr{i,1} = zeros(count(i),1);
    posttopresynarr{i,2} = zeros(count(i),1);
end
%populate the array by looking at each neuron id i
%searching synarr for mentions of it. Where it is mentioned 
%the index into synarr j is the neuron presynatic to i. We place this as
%the first row of our array. x(k)
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
% for i = 1:length(synarr)
%     i
%     index = 1;
%     for j = 1:length(synarr)
%         for x = 1:length(synarr{j,1})
%             if synarr{j,1}(x) == i
%                  posttopresynarr{i,1}(index) = j;
%                  posttopresynarr{i,2}(index) = x;
%                  index = index +1;
%             end
%         end
% 
%     end
% end


end

