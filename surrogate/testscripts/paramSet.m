function Data= paramSet()
dim=6;
Data.xlow=zeros(1,dim); %variable lower bounds
Data.xup=dim*ones(1,dim); %variable upper bounds
Data.dim=dim; %problem dimension
Data.integer=(1:dim); %indices of integer variables
Data.continuous = []; %indices of continuous variables
%define objective function
Data.objfunction=@evalfun;
end %function