function [SynapseModelArr, synMapCell] = setupSynapseDynamicVars(TP, NP, CP, SS, RS)

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
          
          if isfield(CP(iPre), params{iP}) && length(CP(iPre).(params{iP})) >= iPost ...
                  && ~isempty(CP(iPre).(params{iP}))
              model = [model, num2str(CP(iPre).(params{iP}){iPost})];
          elseif isfield(CP(iPre), [params{iP} '_distribution'])
              dist = CP(iPre).([params{iP} '_distribution']){iPost};
              model = [model, dist];
              try
                tempdist = makedist(dist);
              catch
                  errMsg = ['The distribution ' CP(iPre).weights_distribution{iPost}...
                ' does not exist.'];

                    error('vertex:checkConnectivityStruct:weightDistNonExistant',errMsg);
              end
              distparams = tempdist.ParameterNames;
              for p = distparams
                  model = [model, num2str(CP(iPre).([params{iP} '_' p{1}]){iPost})];
              end
              clear tempdist;
          end
          
          if isfield(RS, 'I_syn_preGroups') && ismember(iPre,RS.I_syn_preGroups)
              model = [model num2str(iPre) num2str(iPost)];
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
disp('Generating synaptic parameters..')
if SS.parallelSim
  spmd
    SynapseModelArr = cell(TP.numGroups, numSynTypes);
    numInGroup = diff(TP.groupBoundaryIDArr);

    for iPost = 1:TP.numGroups
      for iSynType = 1:numSynTypes
        if ~isempty(constructorCell{iPost, iSynType})
          preID = paramsMapCell{iPost}(iSynType);
          constructor = constructorCell{iPost, iSynType};
          preID_N = find(synMapCell{iPost}==iSynType);
              SynapseModelArr{iPost, iSynType} = ...
            constructor(NP(iPost),CP(preID), ...
            SS,iPost, TP.numInGroupInLab(iPost, labindex()),numInGroup(preID_N), preID_N, TP.groupBoundaryIDArr);
        else
          SynapseModelArr{iPost, iSynType} = [];
        end
      end
      if labindex() ==1
        disp([num2str(iPost) '/' num2str(TP.numGroups)  ' groups generated'])
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
        preID_N = find(synMapCell{iPost}==iSynType);
        constructor = constructorCell{iPost, iSynType};

        SynapseModelArr{iPost, iSynType} = ...  
          constructor(NP(iPost),CP(preID),SS,iPost,numInGroup(iPost),numInGroup(preID_N),preID_N,TP.groupBoundaryIDArr);
      
      else
        SynapseModelArr{iPost, iSynType} = [];
      end
    end
    disp([num2str(iPost) '/' num2str(TP.numGroups) 'groups generated'])
  end
end