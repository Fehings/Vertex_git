function [PopSpks,LaySpks] = findSpikesByPopAndLayer(Results)
% script to seperate spikes by neuron population

% need to find the neuron population boundaries, and do the same thing as
% the layer separating bounds.

%% spikes by layer
LayBounds = [7187 15102 16810 21824] % none in L1
% need to find this automatically!


    
    % need to find for each result what the spike count is for each layer
    Spk = Results.spikes(:,1);
    
    LaySpks(1) = sum(Spk<=LayBounds(1));
    Spk(Spk<=LayBounds(1))=[];
    LaySpks(2) = sum(Spk<=LayBounds(2));
    Spk(Spk<=LayBounds(2))=[];
    LaySpks(3) = sum(Spk<=LayBounds(3));
    Spk(Spk<=LayBounds(3))=[];
    LaySpks(4) = sum(Spk<=LayBounds(4));
    Spk(Spk<=LayBounds(4))=[]; 

    Spk = Results.spikes(:,1);

PopBounds = Results.params.TissueParams.groupBoundaryIDArr;

for i = 2:length(PopBounds)
    PopSpks(i) = sum(Spk<=PopBounds(i));
    Spk(Spk<=PopBounds(i))=[];
end

end
