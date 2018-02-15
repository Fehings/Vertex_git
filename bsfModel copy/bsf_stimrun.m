
%run this after bsf_model_init, or load 'params, connections, electrodes'
%from a bef_model_init run.

poolobj = gcp;

load('defaultbsfinit.mat')
addAttachedFiles(poolobj,'defaultbsfinit.mat')

params.TissueParams.StimulationField = result;
%B=50000; % the frequency in Hz.
%TP.StimulationField = invitroSliceStimAC('catvisblend1.stl',SS.timeStep,stimstrength,B);

% Assign start and stop times for stimulation. These can be vectors of time
% points if you want multiple bursts of stimulation.
params.TissueParams.StimulationOn = 0;
params.TissueParams.StimulationOff = params.SimulationSettings.simulationTime;

RS.saveDir = '/Users/a6028564/Documents/MATLAB/VERTEX_bsf_results/bsf_defaultparams_right5An_left3Cath_stim5s';


if isfield(params.TissueParams, 'StimulationField')
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



%%
% Run the simulation
runSimulation(params, connections, electrodes);

% Load the simulation results
Results = loadResults(RS.saveDir);