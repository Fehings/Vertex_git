disp('Start surrogate-model optimization ')
 Tutorial_optimiser_setup %setup the network for the expensive VERTEX evaluations
 addpath(genpath('/Users/a6028564/Documents/MATLAB/Vertex_git'))
 % the value of the last parameter should not exceed the maximal numer of
 % processors
[xbest,fbest, Data]=matsumoto('paramSet',100,'RBFcub','CANDglob','SLHD',20,[],2);
% second option number of evaluations. Want roughly 100- 200.
% third from last ('20' default) is the number of initial starting points 
% last arg for no. of cores for parallel
save('surmodel_results.mat','Data');
disp('surrogate-model optimization finished successfully')