classdef DiseaseVectorModel < handle
    %DiseaseVectorModel Class that represents the concentration of pathogeneic protein in each
    %cell
    %   Detailed explanation goes here
    
    properties
        pC % amount of pathogeneic protein (mg)
        nC % amount of normal protein (mg)
        buffer
        bufferCount
        bufferMax
        bufferMaxDV
        Rpp % rate of production of pathogenic protein (mg/s)
        Rpn % rate of production of normal protein (mg/s)
        Rm % rate of misfolding 
        Rcp % rate of clearance of pathogenic protein (mg/s)
        Rcn % rate of clearance of normal protein (mg/s)
        Cpn % baseline of pathogenic protein (mg)
        Cnn % baseline of normal protein (mg)
        Rsyn 
        pCTraceInd
    end
    
    methods
        function DVM = DiseaseVectorModel(number,DVMP, SS)
            %DiseaseVectorModel Construct an instance of this class
            %   Currently all parameters initialised to single value but
            %   can be replaced by distributions. 
            
            
            DVM.pC = zeros(SS.maxDelayStepsDV,number);
            
                DVM.pC(1,:) = DVMP.initpC;
            

            DVM.nC = DVMP.initnC .* ones(1,number);
            DVM.buffer = zeros(number, SS.maxDelaySteps);

            DVM.pCTraceInd = 1;
            DVM.bufferCount = 1;
            DVM.bufferMax = SS.maxDelaySteps;
            DVM.bufferMaxDV = SS.maxDelayStepsDV;
            
            % Model parameters
            DVM.Rpp = DVMP.Rpp;
            DVM.Rpn = DVMP.Rpn;
            DVM.Rm = DVMP.Rm;
            DVM.Rcp = DVMP.Rcp;
            DVM.Rcn = DVMP.Rcn;
            DVM.Cpn = DVMP.Cpn;
            DVM.Cnn = DVMP.Cnn;
            DVM.Rsyn = DVMP.Rsyn;

            
            
        end
        
        function DVM = updateDiseaseVectorModel(DVM, dt)
            %updateDiseaseVectorModel Updates the state of the DVM at each
            %time step.
            %   Based on the equations in (Modat,2018) https://doi.org/10.1371/journal.pone.0192518

            % check whether we have reached the end of our circular array.
             if DVM.pCTraceInd < DVM.bufferMaxDV
                 DVM.pCTraceInd = DVM.pCTraceInd+1;
                 DVM.pC(DVM.pCTraceInd,:) = DVM.pC(DVM.pCTraceInd-1,:);
             else % if we have then go back to the start. 
                 DVM.pCTraceInd = 1;
                 DVM.pC(DVM.pCTraceInd,:) = DVM.pC(DVM.bufferMaxDV,:);    
             end
            
             %proteins accumulate through production
             DVM.pC(DVM.pCTraceInd,:) = DVM.pC(DVM.pCTraceInd,:) + DVM.Rpp.*dt;
             DVM.nC = DVM.nC + DVM.Rpn.*dt;
             
             % proteins misfold at a rate of b
             b = DVM.Rm .* DVM.pC(DVM.pCTraceInd,:) .* DVM.nC;
             DVM.pC(DVM.pCTraceInd,:) = DVM.pC(DVM.pCTraceInd,:) + b.*dt;
             DVM.nC = DVM.nC - b.*dt;
             
             % proteins clear at a rate of qp,qn so as to get back to
             % baseline concentrations Cpn, Cnn
             qp = DVM.Rcp .* log(1+ (exp(1) - 1).*(DVM.pC(DVM.pCTraceInd,:)./DVM.Cpn));
             qn = DVM.Rcn .* log(1+ (exp(1) - 1).*(DVM.nC./DVM.Cnn));
             DVM.pC(DVM.pCTraceInd,:) = DVM.pC(DVM.pCTraceInd,:) - qp.*dt;
             DVM.nC = DVM.nC - qn.*dt;            
        end
        
        % applied in simulate/simulateParallel after each spike.
        % removes the vector from the presynaptic neuron.
        function DVM = updatePresynapticCellsAfterSpike(DVM, presynIDs)
            DVM.pC(DVM.pCTraceInd,presynIDs) = DVM.pC(DVM.pCTraceInd,presynIDs) - DVM.pC(DVM.pCTraceInd,presynIDs).*DVM.Rsyn;
        end
        
        % updates the buffer for axonal transmission delay
        function DVM = updateBuffer(DVM)
            DVM.pC(DVM.pCTraceInd,:) = DVM.pC(DVM.pCTraceInd,:) + DVM.buffer(:, DVM.bufferCount)';
            DVM.buffer(:, DVM.bufferCount) = 0;
            DVM.bufferCount = DVM.bufferCount + 1;
            
            if DVM.bufferCount > DVM.bufferMax
                DVM.bufferCount = 1;
            end
        end
        
        % updates the post synaptic buffer with the synaptically
        % transmitted concentration.
        function DVM = bufferVectorFlow(DVM, postNeuronIDs,delays, weights,presynPrC)
            for i = 1:length(postNeuronIDs)
                DVM.buffer(postNeuronIDs(i),delays(i)) =  DVM.buffer(postNeuronIDs(i),delays(i)) + (presynPrC(i).*DVM.Rsyn)./length(postNeuronIDs);
            end
        end
        
    end
end

