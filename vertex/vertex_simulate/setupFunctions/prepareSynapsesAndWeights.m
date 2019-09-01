function [synapseArrMod, weightArr] = ...
  prepareSynapsesAndWeights(TP, CP, SS, synapseArr)

neuronInGroup = createGroupsFromBoundaries(TP.groupBoundaryIDArr);

if SS.parallelSim
  spmd
    [synapseArrMod, weightArr] = prep(CP, SS, synapseArr, neuronInGroup);
  end
else
  [synapseArrMod, weightArr] = prep(CP, SS, synapseArr, neuronInGroup);
end


function [synapseArrMod,weightArr] = prep(CP, SS, synapseArr, neuronInGroup)
weightArr = cell(size(synapseArr, 1), 1);
%weightMat = sparse(length(synapseArr), length(synapseArr));
synapseArrMod = synapseArr;
CParr = CP.synapseType;
numSynapseModels = length(CParr);
weight_distributions = cell(length(CP), numSynapseModels);
if SS.parallelSim
    if labindex() == 1
        disp('Generating network weights:');
    end
else
    disp('Generating network weights:');
end

for iNGroup = 1:length(CP)
    if ~isfield(CP(iNGroup), 'weights') || isempty(CP(iNGroup).weights)
        for iW = 1:length(CP(iNGroup).synapseType)
            CP(iNGroup).weights{iW} = 0;
        end
    end
    if isfield(CP(iNGroup), 'weights_distribution')
        for iP = 1:length(CP(iNGroup).synapseType)
            if length(CP(iNGroup).('weights_distribution')) >= iP && ~isempty(CP(iNGroup).('weights_distribution'){iP})
                dist_name = CP(iNGroup).('weights_distribution'){iP};
                weight_distributions{iNGroup,iP} = makedist(dist_name);
                attribute = 'weights';
                fields = fieldnames(CP(iNGroup));
                for i = 1:length(fields)
                    if startsWith(fields{i}, attribute)
                        if ~strcmp(fields{i}(length(attribute)+2:end) , 'distribution') 
                            parameter = fields{i}(length(attribute)+2:end);
                            if  length(parameter)>0
                                 weight_distributions{iNGroup,iP}.(parameter) = CP(iNGroup).(fields{i}){iP};
                            end

                        end
                    end
                end
                if isfield(CP(iNGroup), 'weights_mu') && CP(iNGroup).weights_mu{iP} > 0
                    weight_distributions{iNGroup,iP} = truncate(weight_distributions{iNGroup,iP},0.001,inf);
                elseif isfield(CP(iNGroup), 'weights_mu') && CP(iNGroup).weights_mu{iP} < 0
                    weight_distributions{iNGroup,iP} = truncate(weight_distributions{iNGroup,iP},-inf,-0.001);
                end
            end
        end

    end
    

end
if SS.parallelSim
    if labindex() == 1
        PR = ProgressReporter(size(synapseArrMod, 1), 5, 'weights generated ...');
    end
else
    PR = ProgressReporter(size(synapseArrMod, 1), 5, 'weights generated ...');
end
for iN = 1:size(synapseArrMod, 1)
  if ~isempty(synapseArrMod{iN, 1})
    iNeuronGroup = neuronInGroup(iN);
    postGroups = neuronInGroup(synapseArrMod{iN, 1});
    % fill empty weights entries with zeros
    

    for iW = 1:length(CP(iNeuronGroup).weights)
        if isempty(CP(iNeuronGroup).weights{iW})
            CP(iNeuronGroup).weights{iW} = 0;
        end
    end
    weights = zeros(length(postGroups),1);
    if isfield(CP(iNeuronGroup), 'weights_distribution')
        for iP = 1:length(CP(iNeuronGroup).synapseType)
            number = sum(postGroups==iP);
            if length(CP(iNeuronGroup).('weights_distribution')) >= iP && ~isempty(CP(iNeuronGroup).('weights_distribution'){iP})
                weights(postGroups==iP) =  weight_distributions{iNeuronGroup,iP}.random(number,1)';
            else
                weights(postGroups==iP) = CP(iNeuronGroup).weights{iP};
            end
        end
    else
        w = cell2mat(CP(iNeuronGroup).weights);
        weights = w(postGroups);
    end

    % if weights are to be randomised, do this here...
    % TO IMPLEMENT
    if SS.multiSyn
      weightArr{iN, 1} = multiSynapse(double(synapseArrMod{iN, 1}), ...
                                      double(synapseArrMod{iN, 2}), weights);
      
    else
      weightArr{iN, 1} = weights(:)';
    end

%    weightMat(iN,synapseArrMod{iN, 1}) = weightArr{iN,1};
    toDelete = weightArr{iN, 1} == 0;
    synapseArrMod{iN, 1}(toDelete) = [];
    synapseArrMod{iN, 2}(toDelete) = [];
    synapseArrMod{iN, 3}(toDelete) = [];
    if size(synapseArrMod,2) == 4 && ~isempty(synapseArrMod{iN, 4})
     synapseArrMod{iN, 4}(toDelete) = [];
    end
    weightArr{iN, 1}(toDelete) = [];
  end
  if SS.parallelSim
    if labindex() == 1
        printProgress(PR, iN);
    end
  else
      printProgress(PR, iN);
  end
end


