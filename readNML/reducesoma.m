function [ nmlmodel ] = reducesoma( nmlmodel )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
for groupind = 1:length(nmlmodel.groups)
    members = nmlmodel.groups{groupind}.segnumbers;
    if length(members) < 1
        continue;
    end
    startid = members(1);
    finishid = members(end);
    for i = 1:length(nmlmodel.segments)
        if nmlmodel.segments{i}.id == startid
            startseg = nmlmodel.segments{i};
            break;
        end
    end

    for i = 1:length(nmlmodel.segments)
        if nmlmodel.segments{i}.id == finishid
            finishseg = nmlmodel.segments{i};
            break;
        end
    end
    memberspositions = [];
    for i = 1:length(members)
        for s = 1:length(nmlmodel.segments)
            if nmlmodel.segments{s}.id == members(i)
                memberspositions = [memberspositions s];
            end
        end
    end
    diameters = [];

    for i = memberspositions
        diameters = [diameters nmlmodel.segments{i}.distal.diameter];
    end

    for i = 2:length(memberspositions)

       nmlmodel.segments{memberspositions(i)} = [];
    end
    nmlmodel.segments =  nmlmodel.segments(~cellfun('isempty',nmlmodel.segments));

    diameter = mean(diameters);
    segment = startseg;
    segment.distal = finishseg.distal;
    segment.distal.diameter = diameter;

            
    nmlmodel.segments{memberspositions(1)} = segment;
    n
    for i = 1:length(nmlmodel.segments)
        if isfield(nmlmodel.segments{i}, 'parent')
            if ismember(nmlmodel.segments{i}.parent, members)
                nmlmodel.segments{i}.parent = segment.id;
            end
        end
    end
    
end


end

