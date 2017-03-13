function [isloop,children, ancestors ] = containsloop( parentid,ancestors, parentidarr, cousins )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
children = find(parentidarr==parentid);

if length(children)<1
    disp('no children, no loop')
    isloop = false;
elseif ismember(parentid,children)
    disp('child is parent')
    isloop = true;
elseif ismember(children,ancestors)
    disp('child is also ancestor, contains loop')
    isloop = true;
elseif ismember(children, cousins)
    disp('child is also cousin, contains loop')
    isloop = true;
else
    ancestors = [ancestors parentid];
    cousins = [];
    disp(['found ' num2str(length(children)) ' children, calling recursively'])
    for i = 1:length(children)
        disp(['child ' num2str(children(i))]);
        [isloop, kids] = containsloop(children(i),[ancestors parentid],parentidarr,cousins);
        cousins = [cousins kids];
    end
    children = [children cousins];
end
end

