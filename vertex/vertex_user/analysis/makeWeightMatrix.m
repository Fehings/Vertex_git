% weight average plot

function Wmat = makeWeightMatrix(Results)

countup=1;
count=1;


for i =1:29
countup=countup+size(Results.weights{i},2);
end

 Wmat=zeros(size(Results.weights{1},1),countup);
 
 Wmat(:,count:size(Results.weights{1},2))=Results.weights{1};
count=size(Results.weights{1},2);

for ii =2:29

Wmat(:,count+1:count+size(Results.weights{ii},2))=Results.weights{ii};
count=count+size(Results.weights{ii},2);
end

end