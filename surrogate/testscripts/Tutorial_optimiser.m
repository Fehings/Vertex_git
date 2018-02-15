function LFP = Tutorial_optimiser(result)

load('Tutorial_optimiser_setup')

 params.TissueParams.StimulationField = result;
rng(127)
[RecVar]=runSimulation(params,connections,electrodes);

LFP = extractLFP(RecVar,params);

end

