    function dist = getAttributeDist(CP, attribute, number, postID)
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
            
            dist = dist.random(number,1);
        else 
            dist = CP.(attribute){postID};
        end
        
    end