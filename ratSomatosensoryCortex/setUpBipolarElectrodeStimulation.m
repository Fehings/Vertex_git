[TissueParams.StimulationField,TissueParams.model] = invitroSliceStim('6layermodelstiml4placedinnobacktrueunits.stl',750); % slicecutoutsmallnew
TissueParams.StimulationOn = [1500]; % Turn stimulation on at 1500 ms
TissueParams.StimulationOff = [1501]; % Turn stimulation off at 1501 ms
% set the scale relative to SI units
TissueParams.scale = 1e-6;