%run this after cvc_model_init, or load 'params, connections, electrodes'
%from a cvc_model_init run.

brainslice3D




RS.saveDir = '/Documents/MATLAB/VERTEX_results/';

if isfield(TP, 'StimulationField')
    disp('Finding compartment locations...')
    if params.SimulationSettings.parallelSim
        spmd
            compartmentlocations = getCompartmentLocations(params.NeuronParams,params.SimulationSettings,params.TissueParams);
        end
        params.TissueParams.compartmentlocations = compartmentlocations;
    else
        params.TissueParams.compartmentlocations = getCompartmentLocations(params.NeuronParams,params.SimulationSettings,params.TissueParams);
    end
end

params.TissueParams = TP;

%%
% Run the simulation
runSimulation(params, connections, electrodes);

% Load the simulation results
Results = loadResults(RS.saveDir);