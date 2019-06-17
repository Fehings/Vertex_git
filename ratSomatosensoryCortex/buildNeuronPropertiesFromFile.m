
totalneurons = 0;
for n = 1:length(TissueParams.neuron_names)
    totalneurons = totalneurons + neuronnumbers.(TissueParams.neuron_names{n});
end
% 18294 neurons in 3 layers in volume of 0.29mm^2 
totalneurons = double(totalneurons);
%Number of all neurons from datasheet
for iN = 29:-1:1
    temp = load([TissueParams.neuron_names{iN} '.mat']);
    NeuronParams(iN) = temp.NeuronParams;
end
