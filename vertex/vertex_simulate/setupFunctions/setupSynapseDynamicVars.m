function [SynapseModelArr, synMapCell] = setupSynapseDynamicVars(TP, NP, CP, SS)

paramsMapCell = cell(TP.numGroups,1);
synMapCell = cell(TP.numGroups,1);
numSynTypes = 0;
for iPost = 1:TP.numGroups
  postSynDetails = cell(TP.numGroups,1);
  for iPre = 1:TP.numGroups
    model = lower(CP(iPre).synapseType{iPost});
    if ~isempty(model)
      params = eval(['SynapseModel_' model '.getRequiredParams();']);
      for iP = 1:length(params)
          if iscell(CP(iPre).(params{iP}))
              model = [model, num2str(CP(iPre).(params{iP}){iPost})];
          else
              CP(iPre).(params{iP}) = num2cell(CP(iPre).(params{iP}));
              model = [model, num2str(CP(iPre).(params{iP}){iPost})];
          end
      end
      postSynDetails{iPre} = model;
   else
      postSynDetails{iPre} = '';
    end
  end
  %length(postSynDetails)
 % [~, paramsMap, synMap] = unique(postSynDetails);
 [~, paramsMap, synMap] = unique(postSynDetails);
  paramsMapCell{iPost, 1} = paramsMap;
  synMapCell{iPost} = synMap;
  if length(paramsMap) > numSynTypes
    numSynTypes = length(paramsMap);
  end
end

constructorCell = cell(TP.numGroups, numSynTypes);
for iPost = 1:TP.numGroups
  % List of synapse model function handles
  if ~isempty(paramsMapCell{iPost})
    for iSynType = 1:numSynTypes
      if iSynType <= length(paramsMapCell{iPost})
        preID = paramsMapCell{iPost}(iSynType);
        modelName = lower(CP(preID).synapseType{iPost});
        funString = ['SynapseModel_' modelName];
        
        if ~strcmp(funString(end), '_')
          constructor = str2func(funString);
          constructorCell{iPost, iSynType} = constructor;
        %else
        %  constructorCell{iPost, iSynType} = [];
        end
      %else
      %  constructorCell{iPost, iSynType} = [];
      end
    end
  end
end

if SS.parallelSim
  spmd
    SynapseModelArr = cell(TP.numGroups, numSynTypes);
    numInGroup = diff(TP.groupBoundaryIDArr);
    for iPost = 1:TP.numGroups
      for iSynType = 1:numSynTypes
        if ~isempty(constructorCell{iPost, iSynType})
          preID = paramsMapCell{iPost}(iSynType);
          constructor = constructorCell{iPost, iSynType};
          disp(['creating synapse from group: ' num2str(preID) ' to ' num2str(iPost)]);
        disp(['with ' num2str(numInGroup(preID)) ' presynaptic neurons']);
          SynapseModelArr{iPost, iSynType} = ...
            constructor(NP(iPost),CP(preID), ...
            SS,iPost, TP.numInGroupInLab(iPost, labindex()),numInGroup(preID));
        else
          SynapseModelArr{iPost, iSynType} = [];
        end
      end
    end
  end
else
  numInGroup = diff(TP.groupBoundaryIDArr);
  SynapseModelArr = cell(TP.numGroups, numSynTypes);
  for iPost = 1:TP.numGroups
    for iSynType = 1:numSynTypes
      if ~isempty(constructorCell{iPost, iSynType})
        preID = paramsMapCell{iPost}(iSynType);
        constructor = constructorCell{iPost, iSynType};
        disp(['creating synapse from group: ' num2str(preID) ' to ' num2str(iPost)]);
        disp(['with ' num2str(numInGroup(preID)) ' presynaptic neurons']);
        disp(['iSynType: ' num2str(iSynType)]);
        SynapseModelArr{iPost, iSynType} = ...  
          constructor(NP(iPost),CP(preID),SS,iPost,numInGroup(iPost),numInGroup(preID));
      
      else
        SynapseModelArr{iPost, iSynType} = [];
      end
    end
  end
end