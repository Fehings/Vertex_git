
RS.LFP = true;
[meaX, meaY, meaZ] = meshgrid(400, 200, 1000);
RS.meaXpositions = meaX;
RS.meaYpositions = meaY;
RS.meaZpositions = meaZ;
RS.minDistToElectrodeTip = 20;
RS.maxRecTime = 200;
RS.sampleRate = 1000;

RS.v_m = [];%1000:1000:29759; %49600; %175000;
clear meaX meaY meaZ;