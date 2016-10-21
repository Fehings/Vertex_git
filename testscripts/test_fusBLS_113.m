% Test script to call fusBLS for a number of time steps

clear all


num_neurons=1; % number of neurons
num_comparts=1; % number of compartments

% initialise the inputs and output vectors:

% for single neuron single compartment:
% Vm=ones(1,t);
% Vm(1)=-71.9;
% Cm=ones(1,t);
% load initparams.mat

Vm=-70;%*ones(num_neurons,num_comparts);
%Vm(:,:,1)=-71.9;
params.C=2.96;%*ones(num_neurons,num_comparts);
Pa=1;
params.v=0.1;%*ones(num_neurons,num_comparts);
params.z=0.1;%*ones(num_neurons,num_comparts);
params.P_in=10^5;
params.n_a=1.5071e+10;
params.tstep=0.025; %/f

% set the number of timesteps:
tspan=0:params.tstep:1;


% HH initialisation:
hh.n=0.1;
hh.m=0.1;
hh.h=0.1;
hh.p=0.1;

%y=cell(5,time);
y(1)=0; %dCmVm placeholder
y(2)=params.C;
y(3)=params.v;
y(4)=params.z;
y(5)=params.P_in;
y(6)=params.n_a;
y(7)=params.tstep;
y(8)=Vm;
y(9)=hh.n;
y(10)=hh.m;
y(11)=hh.h;
y(12)=hh.p;
y(13)=Pa;
y=y';
%size(y)

%%

[t,y]=ode113(@odefun_hhfus,tspan,y);

%% 
%size(y)
plot(t,y(:,8)) % plot Vm
hold on
plot(t,y(:,1),'b') % plot dCmVm
hold on
plot(t,y(:,2),'m') % plot Capacitance
legend('Vm','dCmVm','Capacitance')

figure
for i=1:13
    plot(t,y(:,i),'color',rand(1,3));
    hold on
end
%legend('dVmCm','C','v','z','P_in'
