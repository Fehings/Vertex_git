function [ result ] = morris_lecar_neuron( g_Ca,g_K,g_l, I)

    NeuronParams.neuronModel = 'ML';

    NeuronParams.v_cutoff = 30;
    NeuronParams.V1 = 1.2;
    NeuronParams.V2 = 18;
    NeuronParams.V3 = 12;
    NeuronParams.V4 = 17.4;
    NeuronParams.phi = 0.5;
    NeuronParams.T0 = 0.08;
    NeuronParams.g_l = g_l;
    NeuronParams.g_Ca = g_Ca;
    NeuronParams.g_K = g_K;
    NeuronParams.Ca_leak = 60;
    NeuronParams.K_leak = -84;
    NeuronParams.v_cutoff = 30;
NeuronParams.V1 = -1;
NeuronParams.V2 = 18;
NeuronParams.V3 = 18;
NeuronParams.V4 = 17.4;
NeuronParams.phi = 0.5;
NeuronParams.T0 = 0.08;
NeuronParams.g_l = 0.8;
NeuronParams.g_Ca = 4.4;
NeuronParams.g_K = 20;
NeuronParams.Ca_leak = 60;
NeuronParams.K_leak = -84;

    NeuronParams.numCompartments =8;
    NeuronParams.compartmentParentArr = [0, 1, 2, 2, 4, 1, 6, 6];
    NeuronParams.compartmentLengthArr = [13 48 124 145 137 40 143 143];
    NeuronParams.compartmentDiameterArr = ...
      [29.8, 3.75, 1.91, 2.81, 2.69, 2.62, 1.69, 1.69];
    NeuronParams.compartmentXPositionMat = ...
    [   0,    0;
        0,    0;
        0,  124;
        0,    0;
        0,    0;
        0,    0;
        0, -139;
        0,  139];
    NeuronParams.compartmentYPositionMat = ...
    [   0,    0;
        0,    0;
        0,    0;
        0,    0;
        0,    0;
        0,    0;
        0,    0;
        0,    0];
    NeuronParams.compartmentZPositionMat = ...
    [ -13,    0;
        0,   48;
       48,   48;
       48,  193;
      193,  330;
      -13,  -53;
      -53, -139;
      -53, -139];
    NeuronParams.C = 2;
    NeuronParams.R_M = 20000/2.96;
    NeuronParams.R_A = 500;
    NeuronParams.E_leak = -70;
    NeuronParams.ref = 20;

    NeuronParams.Input.inputType = 'i_step';
%     
    if I < 0.9
        NeuronParams.Input.amplitude = [50];
    elseif I < 1.9
        NeuronParams.Input.amplitude = [250];
    elseif I < 2.9
        NeuronParams.Input.amplitude = [2500];
    elseif I < 3.9
        NeuronParams.Input.amplitude = [4500];
    end
    

    disp(['Stim amplitude: ' num2str(NeuronParams.Input.amplitude) ' pA']);
    
    NeuronParams.Input.timeOn = 10;
    NeuronParams.Input.timeOff = 300;
    NeuronParams.Input.compartmentsInput = 1;

    
    SimulationParams.timeStep = 0.025;
    SimulationParams.simulationTime = 500;
    
    [v_m, I_input,NP,spikes] = neuronDynamics(NeuronParams, SimulationParams);
    
    v_m = squeeze(v_m);
    v_m = v_m(1,:);
    step = SimulationParams.timeStep;
    
    time = step:step:SimulationParams.simulationTime;
    
    
    result.trace = v_m;
    result.spikes = spikes;
    result.time = time;
    plot(time, v_m);
end

