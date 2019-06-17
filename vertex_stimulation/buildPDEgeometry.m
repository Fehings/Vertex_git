function [model] = buildPDEgeometry(geometryloc)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

model = createpde;
importGeometry(model,geometryloc);
pdegplot(model,'FaceAlpha',0.4, 'FaceLabels', 'on');
end

