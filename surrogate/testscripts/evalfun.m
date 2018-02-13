function y=evalfun(x)
% x is a vector of values chosen from 1 to 6
xlength=size(x,2);
posFaces=x(1:xlength/2);
negFaces=x(length(x)/2+1:end);
result=brainslice3D(posFaces,negFaces);
%cvc_model_run();
LFP = Tutorial_optimiser(result);
addpath(genpath('~/Documents/MATLAB/Vertex_Results/VERTEX_results_surrogate'))
%result1= loadResults(RS.saveDir);
y=mean(LFP);
y=bandpower(y(100:end)); % miss out the first 100 time points as these will have an initial burst as the model stabilises.
end