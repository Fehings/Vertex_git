%Simulation settings:
%Keep max delay steps at 80, 
%Simulation time can be varied, it is in milliseconds, currently running
%for 500 ms.
%We want to run this simulation in parallel, this means that all cpu cores
%will be utilised in the simulations, with the neurons being distributed
%across them, as this simulation is large this is necessary to minimize the
%run time of the simulation. 
SimulationSettings.maxDelaySteps = 80;
SimulationSettings.simulationTime = 50;
SimulationSettings.timeStep = 0.025;
SimulationSettings.parallelSim = true;