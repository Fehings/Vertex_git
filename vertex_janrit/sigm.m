function s=sigm(v)
%Function for the sigmoid transformation used in the Jansen-Rit model
%Equations from Jansen and Rit 1995

e0=5;%2.5;  %the maximum firing rate in s^-1
r=0.56;  %the steepness of the transformation in mV^-1
v0=6;    %the PSP for which a 50% firing rate is achieved, in mV
%the sigmoid transformation:
%s=(2*e0)./(1+exp(r.*(v0-v)));
s=e0./(1+exp(r.*(v0-v))); %no 2e0 in the Friston version, just set it to 5

end