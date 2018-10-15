function [ neuron ] = readNeuronML_parentids( filename )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
DOMnode = xmlread(filename);

    
disp(['Reading NeuroML file: ' filename]);



segments = DOMnode.getElementsByTagName('segment');
disp([num2str(segments.getLength) ' segments...']);


for s = 0:segments.getLength-1
    seg = segments.item(s);
    if (length(seg.getElementsByTagName('parent').item(0)) > 0)
     segment.parent = str2num(seg.getElementsByTagName('parent').item(0).getAttribute('segment'));
    elseif length(seg.getAttribute('parent'))>0
            segment.parent = str2num(seg.getAttribute('parent'));    
    end
    segment.id = str2num(seg.getAttribute('id'));
    segment.name = char(seg.getAttribute('name'));
    % If element has proximal dendrite information
    if ~isfield(segment, 'parent') && length(seg.getElementsByTagName('proximal').item(0)) == 1
        segment.proximal.x = str2num(seg.getElementsByTagName('proximal').item(0).getAttribute('x'));
        segment.proximal.y = str2num(seg.getElementsByTagName('proximal').item(0).getAttribute('y'));
        segment.proximal.z = str2num(seg.getElementsByTagName('proximal').item(0).getAttribute('z'));
        segment.proximal.diameter = str2num(seg.getElementsByTagName('proximal').item(0).getAttribute('diameter'));
    elseif ~isempty(segment.parent) %otherwise get it from parent if it has one

       for i = 1:length(neuron.segments)
        ids(i)= neuron.segments{i}.id;
       end
       
        %disp(['No proximal attribute found, getting info from parent ' neuron.segments{(ids==segment.parent)}.name ' distal instead.'])
        segment.proximal.x = neuron.segments{(ids==segment.parent)}.distal.x;
        segment.proximal.y = neuron.segments{(ids==segment.parent)}.distal.y;
        segment.proximal.z = neuron.segments{(ids==segment.parent)}.distal.z;
        
        
        segment.proximal.diameter = neuron.segments{(ids==segment.parent)}.distal.diameter;
    end % Soma elements without proximal or distal attributes will not be stored
    
    if length(seg.getElementsByTagName('distal')) == 1
        segment.distal.x = str2num(seg.getElementsByTagName('distal').item(0).getAttribute('x'));
        segment.distal.y = str2num(seg.getElementsByTagName('distal').item(0).getAttribute('y'));
        segment.distal.z = str2num(seg.getElementsByTagName('distal').item(0).getAttribute('z'));
        segment.distal.diameter = str2num(seg.getElementsByTagName('distal').item(0).getAttribute('diameter'));
    elseif ~isempty(segment.parent)
        disp('Getting distal from parents proximal, not sure if this should happen....');
        segment.distal.x = neuron.segments{segment.parent}.proximal.x;
        segment.distal.y = neuron.segments{segment.parent}.proximal.y;
        segment.distal.z = neuron.segments{segment.parent}.proximal.z;
        segment.proximal.diameter = neuron.cables{c+1}.segments{segment.parent}.distal.diameter;
    end
    neuron.segments{s+1} = segment;
    %disp(['Added segment ' neuron.segments{s+1}.name]);
end

segmentgroup = DOMnode.getElementsByTagName('segmentGroup');
groups = {};
for i = 0:segmentgroup.getLength-1
    seggroup = segmentgroup.item(i);
    group.id = char(seggroup.getAttribute('id'));
    members = seggroup.getElementsByTagName('member');
   if ~strcmp(seggroup.getAttribute('neuroLexId'), 'sao864921383')
       continue;
   else
        segmentnumbers = zeros(members.getLength,1);
        for j = 0:members.getLength-1
            segmentnumbers(j+1) = str2num(members.item(j).getAttribute('segment'));
        end
        if length(segmentnumbers) < 1
            members = seggroup.getElementsByTagName('include');
            segmentnumbers = [];
            for j = 0:members.getLength-1
                groupid = char(members.item(j).getAttribute('segmentGroup'));
                for e = 1:length(groups)
                    if strcmp(groups{e}.id,groupid)
                        segmentnumbers= [segmentnumbers; groups{e}.segnumbers];
                        break;
                    end
                end
            end
        end
        disp(['Added group ' group.id ' with ' num2str(length(segmentnumbers)) ' members.']);

        group.segnumbers = segmentnumbers;
        groups{i+1} = group;
   end
end
neuron.groups = groups;

end
