function [ v_m, v_ext ] = getExtracellularInput(TP, StimParams, t, NeuronParams)
%Returns a matrix representing the potential change at each compartment
%given the PDE solution and locations of the compartments. Uses the
%activation function.



F = TP.StimulationField;
 
 
func = 'mirror';
 
for iGroup = 1:TP.numGroups
    point1 = StimParams.compartmentlocations{iGroup,1};
    point2 = StimParams.compartmentlocations{iGroup,2};
  
    midpoint = zeros(3,length(point1.x(:,1)),length(point1.x(1,:)));
    midpoint(1,:,:) = (point1.x + point2.x)./2;
    midpoint(2,:,:) = (point1.y + point2.y)./2;
    midpoint(3,:,:) = (point1.z + point2.z)./2;
    
%   
%     
%     max(max(max(midpoint<=0)))
%     max(max(point1.x<=0))
%     max(max(point1.y<=0))
%     max(max(point1.z<=0))
%     max(max(point2.x<=0))
%     max(max(point2.y<=0))
%     max(max(point2.z<=0))
% 
%     error()
     numcompartments = length(point1.x(:,1));
    if strcmp(func,'mirror')
        [l,d] = getDimensionsInCentimetres(NeuronParams(iGroup));
        d = d*10^5;
        g =  NeuronParams(iGroup).g_l /10^9; %from picoSeimens to Seimens
 
        for iC = 1:numcompartments
            a = squeeze(midpoint(:,iC,:));
            if isa(TP.StimulationField, 'pde.TimeDependentResults')
                v_ext{iGroup}(:,:,iC) = interpolateSolution(F,a,t);
            elseif isa(TP.StimulationField, 'pde.StationaryResults')
                v_ext{iGroup}(:,iC) = interpolateSolution(F,a);
            else
                v_ext{iGroup}(:,iC) = pointstim(a,F,TP.stimstrength);
            end
            if sum(isnan(v_ext{iGroup}(:,iC)))>0
                disp('Warning: Found nans in the extracellular field. Setting them to zero.')
                v_ext{iGroup}(isnan(v_ext{iGroup}(:,iC)), iC) = 0; 
            end
        end
        for iN = 1:length(midpoint(1,1,:))
            if isa(TP.StimulationField, 'pde.TimeDependentResults')
                for ii = 1:size(v_ext{iGroup},2) % step through time dimension
                    neuronmean(iN,ii) = sum((g .* d .* mean(v_ext{iGroup}(iN,ii,:),3)))./sum(g .* d);
                end
            else
                bottom = sum(g .* d)
                mean(d)
                top = sum((g .* d .* mean(v_ext{iGroup}(iN,:))))
                neuronmean(iN) = sum((g .* d .* mean(v_ext{iGroup}(iN,:))))./sum(g .* d);
            end
        end
        neuronmean = neuronmean';
        neuronmean
    end
    for iComp = 1:numcompartments
        if strcmp(func,'activation')
        v_m{iGroup}(iComp,:) = activationfunction([point1.x(iComp,:);point1.z(iComp,:);point1.y(iComp,:)] ,...
            [point2.x(iComp,:); point2.z(iComp,:);point2.y(iComp,:)],...
           F,t);
        elseif strcmp(func,'mirror')
            if isa(TP.StimulationField, 'pde.TimeDependentResults')
               for ii = 1:size(v_ext,2) % step through time
                   v_m{iGroup}(iComp,:,ii) = - v_ext{iGroup}(:,ii,iComp) + neuronmean(ii);
               end
            else
                v_m{iGroup}(iComp,:) = (- v_ext{iGroup}(:, iComp) + neuronmean);
            end
        end
    end
    clear neuronmean;
end
 
end
 
% convert user provided lengths and diameters from microns to cm
 
function [l, d] = getDimensionsInCentimetres(NP)
l = NP.compartmentLengthArr .* 10^-4;
d = NP.compartmentDiameterArr .* 10^-4;
end