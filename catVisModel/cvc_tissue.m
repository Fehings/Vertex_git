TP.X = 2000;
TP.Y = 400; % the thickness of the slice
TP.Z = 1240; % the total depth, taken from Beaulieu and Colonnier (1983)
TP.neuronDensity = 50000;
TP.layerBoundaryArr = [1240, 1058, 691, 345, 240, 0];
TP.numLayers = 5;
TP.numGroups = 15;
TP.tissueConductivity = 0.3;
TP.numStrips = 44;
TP.maxZOverlap = [0 -25];

%stimstrength=50;
%B=20; % the frequency in Hz.
%SimulationSettings.timeStep = 0.03125;
%TP.StimulationField = invitroSliceStimAC('largemod2.stl',SimulationSettings.timeStep,stimstrength,B);