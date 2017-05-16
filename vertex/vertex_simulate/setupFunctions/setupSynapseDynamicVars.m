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
      numdoubles = 0;
    SynapseModelArr = cell(TP.numGroups, numSynTypes);
    numInGroup = diff(TP.groupBoundaryIDArr);
    for iPost = 1:TP.numGroups
      for iSynType = 1:numSynTypes
        if ~isempty(constructorCell{iPost, iSynType})
          preID = paramsMapCell{iPost}(iSynType);
          constructor = constructorCell{iPost, iSynType};
          preID_N = find(synMapCell{iPost}==iSynType);
%           disp(['creating syn from ' num2str(preID) ' to ' num2str(iPost) ' with ' ...
%                 num2str(numInGroup(preID)) ' presynaptic variables and ' ...
%                 num2str(TP.numInGroupInLab(iPost, labindex())) ' postsynaptic variables.']);
%             numdoubles = numdoubles+TP.numInGroupInLab(iPost, labindex()) + numInGroup(preID);
              SynapseModelArr{iPost, iSynType} = ...
            constructor(NP(iPost),CP(preID), ...
            SS,iPost, TP.numInGroupInLab(iPost, labindex()),numInGroup(preID_N), preID_N);
        else
          SynapseModelArr{iPost, iSynType} = [];
        end
      end
    end
    
    disp(['number of doubles: ' num2str(numdoubles)]);
  end
else
  numInGroup = diff(TP.groupBoundaryIDArr);
  SynapseModelArr = cell(TP.numGroups, numSynTypes);
  for iPost = 1:TP.numGroups
    for iSynType = 1:numSynTypes
      if ~isempty(constructorCell{iPost, iSynType})
        preID = paramsMapCell{iPost}(iSynType);
        preID_N = find(synMapCell{iPost}==iSynType);
        constructor = constructorCell{iPost, iSynType};
        
        SynapseModelArr{iPost, iSynType} = ...  
          constructor(NP(iPost),CP(preID),SS,iPost,numInGroup(iPost),numInGroup(preID_N),preID_N);
      
      else
        SynapseModelArr{iPost, iSynType} = [];
      end
    end
  end
end