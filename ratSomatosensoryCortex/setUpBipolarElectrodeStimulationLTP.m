[TissueParams.StimulationField,model] = invitroSliceStim('6layermodelstiml4placedinnobacktrueunits.stl',750); % slicecutoutsmallnew
%Thalamic burst stimulation
TissueParams.StimulationOn = [500 ]; 
TissueParams.StimulationOff = [ 500.5]; 

TissueParams.StimulationOn = [500,1200,1210,1220,1230,1240,1400,1410,1420,1430,1440,1600,1610,1620,1630,1640,1800,1810,1820,1830,1840,2000,2010,2020,2030,2040,2200,2210,2220,2230,2240,2940];
TissueParams.StimulationOff = [500.5,1200.5,1210.5,1220.5,1230.5,1240.5,1400.5,1410.5,1420.5,1430.5,1440.5,1600.5,1610.5,1620.5,1630.5,1640.5,1800.5,1810.5,1820.5,1830.5,1840.5,2000.5,2010.5,2020.5,2030.5,2040.5,2200.5,2210.5,2220.5,2230.5,2240.5,2940.5];
%%
% 
% TissueParams.StimulationOn = [500 800 1000 1200 ...
%     1400 1600 1800 2100]; % Turn stimulation on at 50 ms
% TissueParams.StimulationOff = [500.5 800.5 1000.5 1200.5 ...
%     1400.5 1600.5 1800.5 2100.5 ]; % Turn stimulation off at 55 ms
% TissueParams.StimulationOn = [100 200 300 ]; % Turn stimulation on at 50 ms
% TissueParams.StimulationOff = [100.5 200.5 300.5 ]; % Turn stimulation off at 55 ms
% %%
% meterstomicrons = 1e-6;
% mmtomicron = 1e-3;
% 
% x1 = 0.79839*mmtomicron;
% x2 = 0.80639*mmtomicron;
% y1 = 0.181*mmtomicron;
% y2 = 0.55658*mmtomicron;
% z1 = 1.20272*mmtomicron;
% z2 = 1.2158*mmtomicron;
% x = [x1:0.0001.*mmtomicron:x2];
% y = [y1:0.005.*mmtomicron:y2];
% z = [z1:0.0001.*mmtomicron:z2];
% 
% 
% [X1 Y1 Z1] = meshgrid(x,y,z(1));
% [X2 Y2 Z2] = meshgrid(x,y,z(end));
% [X3 Y3 Z3] = meshgrid(x(1),y,z);
% [X4 Y4 Z4] = meshgrid(x(end),y,z);
% [X5 Y5 Z5] = meshgrid(x,y(1),z);
% 
% %%
% currentDensity1 = TissueParams.StimulationField.evaluateCGradient(X1, Y1, Z1);
% currentDensity2 = TissueParams.StimulationField.evaluateCGradient(X2, Y2, Z2);
% currentDensity3 = TissueParams.StimulationField.evaluateCGradient(X3, Y3, Z3);
% currentDensity4 = TissueParams.StimulationField.evaluateCGradient(X4, Y4, Z4);
% currentDensity5 = TissueParams.StimulationField.evaluateCGradient(X5, Y5, Z5);
% 
% area1 = abs(x(1) - x(end)) * abs(y(1) - y(end));
% area2 = abs(x(1) - x(end)) * abs(y(1) - y(end));
% area3 = abs(z(1) - z(end)) * abs(y(1) - y(end));
% area4 = abs(z(1) - z(end)) * abs(y(1) - y(end));
% area5 = abs(z(1) - z(end)) * abs(x(1) - x(end));
% %%
% %current density is in milliamps per meter^2
% %total current in mA
% totalcurrent = (nanmean(currentDensity1) * area1) + (nanmean(currentDensity2) * area2) + (nanmean(currentDensity3) * area3) ... 
%     + (nanmean(currentDensity4) * area4) + (nanmean(currentDensity5 )* area5);
