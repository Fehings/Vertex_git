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
            if length(CP(iNeuronGroup).('weights_distribution')) >= iP && ~isempty(CP(iNeuronGroup).('weights_distribution'){iP})
                dist_name = CP(iNeuronGroup).('weights_distribution'){iP};
                dist = makedist(dist_name);
                attribute = 'weights';
                fields = fieldnames(CP(iNeuronGroup));
                for i = 1:length(fields)
                    if startsWith(fields{i}, attribute)
                        if ~strcmp(fields{i}(length(attribute)+2:end) , 'distribution') 
                            parameter = fields{i}(length(attribute)+2:end);
                            if  length(parameter)>0
                                dist.(parameter) = CP(iNeuronGroup).(fields{i}){iP};
                            end

                        end
                    end
                end
                number = sum(postGroups==iP);
                weights(postGroups==iP) =  dist.random(number,1)';
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
    weightArr{iN, 1}(toDelete) = [];
  end
end

