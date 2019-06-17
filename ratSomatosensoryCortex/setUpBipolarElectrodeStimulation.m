[TissueParams.StimulationField,model] = invitroSliceStim('6layermodelstiml4placedinnobacktrueunits.stl',500); % slicecutoutsmallnew

TissueParams.StimulationOn = [1.500 ];
TissueParams.StimulationOff = [ 2 ];
TissueParams.scale = 1e-6;


% 

%% For calculating the current flow. 
meterstomicrons = 1e-6;
mmtomicron = 1e-3;

x1 = 0.79839*mmtomicron;
x2 = 0.80639*mmtomicron;
y1 = 0.181*mmtomicron;
y2 = 0.55658*mmtomicron;
z1 = 1.20272*mmtomicron;
z2 = 1.2158*mmtomicron;
x = [x1:0.0001.*mmtomicron:x2];
y = [y1:0.005.*mmtomicron:y2];
z = [z1:0.0001.*mmtomicron:z2];


[X1 Y1 Z1] = meshgrid(x,y,z(1));
[X2 Y2 Z2] = meshgrid(x,y,z(end));
[X3 Y3 Z3] = meshgrid(x(1),y,z);
[X4 Y4 Z4] = meshgrid(x(end),y,z);
[X5 Y5 Z5] = meshgrid(x,y(1),z);


currentDensity1 = TissueParams.StimulationField.evaluateCGradient(X1, Y1, Z1);
currentDensity2 = TissueParams.StimulationField.evaluateCGradient(X2, Y2, Z2);
currentDensity3 = TissueParams.StimulationField.evaluateCGradient(X3, Y3, Z3);
currentDensity4 = TissueParams.StimulationField.evaluateCGradient(X4, Y4, Z4);
currentDensity5 = TissueParams.StimulationField.evaluateCGradient(X5, Y5, Z5);

area1 = abs(x(1) - x(end)) * abs(y(1) - y(end));
area2 = abs(x(1) - x(end)) * abs(y(1) - y(end));
area3 = abs(z(1) - z(end)) * abs(y(1) - y(end));
area4 = abs(z(1) - z(end)) * abs(y(1) - y(end));
area5 = abs(z(1) - z(end)) * abs(x(1) - x(end));
%%
%current density is in milliamps per meter^2
%total current in mA
totalcurrent = (nanmean(currentDensity1) * area1) + (nanmean(currentDensity2) * area2) + (nanmean(currentDensity3) * area3) ... 
    + (nanmean(currentDensity4) * area4) + (nanmean(currentDensity5 )* area5);
