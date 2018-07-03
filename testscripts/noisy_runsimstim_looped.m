%noisy run stimstim

seeds = 1:20;

for i=1:length(seeds)
    rng(seeds(i))
    run_stimsim
    save_soma_vm_sidesideskewed4mv_long(i,:)=v_m(1,:);
    
end

save('singleNeuron_sidesideskewfield_longrun','save_soma_vm_sidesideskewed4mv_long')