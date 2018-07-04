function  NeuronParams  = Nml2Vertex( nmlmodel )

segments = nmlmodel.segments;


NeuronParams.numCompartments =length(segments);

for i = 1:NeuronParams.numCompartments
    segment = segments{i};
    if ~isfield(segment,'parent')
        NeuronParams.nmlParentArr(i) = 0;
        NeuronParams.compartmentParentArr(i) =0;
        NeuronParams.nmlid(i) = segments{i}.id+1;
    else
         NeuronParams.nmlid(i) = segments{i}.id;
        if segment.parent == 0
         NeuronParams.nmlParentArr(i) = segment.parent+1;
        else
          NeuronParams.nmlParentArr(i) = segment.parent;
        end
    end
end
for i = 2:NeuronParams.numCompartments
    [a,NeuronParams.compartmentParentArr(i)] =  max(NeuronParams.nmlid == NeuronParams.nmlParentArr(i));
end
for i = 1:NeuronParams.numCompartments
    NeuronParams.compartmentDiameterArr(i) = segments{i}.distal.diameter;
    NeuronParams.compartmentXPositionMat(i, 1) = segments{i}.distal.x;
    NeuronParams.compartmentXPositionMat(i, 2) = segments{i}.proximal.x;
    NeuronParams.compartmentYPositionMat(i, 1) = segments{i}.distal.z;
    NeuronParams.compartmentYPositionMat(i, 2) = segments{i}.proximal.z;
    NeuronParams.compartmentZPositionMat(i, 1) = segments{i}.distal.y;
    NeuronParams.compartmentZPositionMat(i, 2) = segments{i}.proximal.y ;
   NeuronParams.compartmentLengthArr(i) = sqrt((segments{i}.distal.x - segments{i}.proximal.x)^2 + ...
       (segments{i}.distal.y - segments{i}.proximal.y )^2 + ...
       (segments{i}.distal.z - segments{i}.proximal.z)^2);
   if NeuronParams.compartmentLengthArr(i) <= 0
       disp('compartment length is zero');
       NeuronParams.compartmentLengthArr(i) = 0.001;
   end
end

groups = nmlmodel.groups;
for i = 1:length(groups)
    NeuronParams.(genvarname(num2str(groups{i}.id))) = groups{i}.segnumbers;
end



end

