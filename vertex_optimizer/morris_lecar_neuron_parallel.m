function [ result ] = morris_lecar_neuron_parallel(g_Ca,g_K,g_l,V1,V3,phi)
disp(['Running morris lecar neuron in parallel with parameters g_Ca: ' ...
    num2str(g_Ca) ' g_K: ' num2str(g_K) ' g_l: ' num2str(g_l) ' V1: ' num2str(V1) ' V3: ' ...
    num2str(V3) ' phi: ' num2str(phi)]);
    I = [10000,1000,500,100];
    ilength = length(I);
    parfor y = 1:ilength
        [trace(y,:), spikes(y,:)] = morris_lecar_neuronL5PC(g_Ca,g_K,g_l,V1,V3,phi,I(y));
    end
    result.trace = trace;
    result.spikes = spikes;
end