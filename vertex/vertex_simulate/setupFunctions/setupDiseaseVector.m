function DVM = setupDiseaseVector(TP, SS,DVMP,connections)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
if nargin == 4
    if SS.parallelSim
        spmd
            neuronInThisLab = find(SS.neuronInLab == labindex);
            initiatingcells = ismember(neuronInThisLab,DVMP.initpIDs);
            initpC = DVMP.initpC;
            DVMP.initpC = zeros(1,length(neuronInThisLab));
            DVMP.initpC(initiatingcells) = initpC;
            DVM = DiseaseVectorModel(sum(TP.numInGroupInLab(:,labindex())),DVMP, SS);
            
        end
    else
        initpC = DVMP.initpC;
        DVMP.initpC = zeros(1,TP.N);
        DVMP.initpC(DVMP.initpIDs) = initpC;
        DVM = DiseaseVectorModel(TP.N,DVMP, SS);
    end
else
    DVM = {};
end

end
