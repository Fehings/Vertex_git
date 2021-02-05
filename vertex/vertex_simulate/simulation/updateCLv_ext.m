function [RecVar] = updateCLv_ext(NeuronModel,RecVar,iGroup,recTimeCounter)
%Saves the currently applied v_ext 

RecVar.CLv_ext{iGroup}(recTimeCounter,:) = ...
    sum(sum(NeuronModel{iGroup}.currentV_ext));

end

