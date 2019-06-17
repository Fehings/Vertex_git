    function dist = getAttributeDist(CP, attribute, number, postID,SS, isTimeConstant)
        fields = fieldnames(CP);
        attribute = attribute{1};
        if isfield(CP, [attribute '_distribution']) && ...
                length(CP.([attribute '_distribution']))>= postID ...
                &&~isempty(CP.([attribute '_distribution']){postID})
            dist_name = CP.([attribute '_distribution']){postID};
            dist = makedist(dist_name);
            for i = 1:length(fields)
                if startsWith(fields{i}, attribute)
                    if ~strcmp(fields{i}(length(attribute)+2:end) , 'distribution') 
                        parameter = fields{i}(length(attribute)+2:end);
                        if  length(parameter)>0
                            dist.(parameter) = CP.(fields{i}){postID};
                        end

                    end
                end
            end
            if isTimeConstant
                if strcmp(attribute,'U')
                    dist = truncate(dist,0,inf);
                else
                    if dist.mean < SS.timeStep
                        errmsg = ['The mean of this time constant distribution ' ...
                        'is less than the timestep.'];
                        error('vertex:vertexsimulate:models;synapses:getattributedistribution',errmsg);
                    end
                    dist = truncate(dist,SS.timeStep,inf); 
                end
            end
            
            
            dist = dist.random(number,1);
            resetRandomSeed()

        else 
            try
                dist = CP.(attribute){postID};
            catch
                error(['error accessing synaptic attribute: ' attribute ' for post synaptic group: ' num2str(postID)]);
            end
        end
        
    end