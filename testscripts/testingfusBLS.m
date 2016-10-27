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

Vm=-0.070; % Volts *ones(num_neurons,num_comparts);
%tstep=(0.025/0.35)*0.1; %/f
tstep=1e-8;

% set the number of timesteps:
%tspan=0:tstep:10;
tend=1e-3;%6e-6;%0.04



 % radius of the leaflet's boundary
z=0.1e-9; % m
Cm0=0.01;  % cell membrane capacity at rest in F/m^2 , (1 microF/cm^2)
delta = 1.26e-9; % m
a = 32e-9; % radius of the leaflet's boundary 32nm, converted to metres.

Cm =((Cm0*delta)/a^2).*(z+(((a^2)-(z.^2)-(z*delta))./(2*z)).*log((2*z+delta)./delta));



%y=cell(5,time);
%y(1)=0; %dCmVm placeholder
y(1)=Cm;%2.96; % Capacitance
y(2)=0; % params.v;
y(3)=z; % params.z;
y(4)= 1.5769e-22; %params.n_a (P0*pi*a^2*delta)/(Rg*Tem) in metres.
y(5)=Vm; % volts
y(6)=0; %hh.n;
y(7)=0; %hh.m;
y(8)=1; %hh.h;
y(9)=0; %hh.p;
y(10)=0; %1000000; %Pa; 100kPa



%y=y';
%size(y)

%% solver time
% tic
% [t,y]=ode113(@fusBLS_hh,tspan,y);
% toc

tic 
[t,y]=solvefusBLS(tstep,tend,y);
toc

%% 

figure
plot(t,y(5,1:length(t))) % plot Vm
legend('Vm/volts')
figure
plot(t,y(1,1:length(t)),'r') % plot capacitance
legend('Cm/F m^2')
figure
plot(t,y(2,1:length(t)),'k')
legend('v')
figure
plot(t,y(3,1:length(t)),'m')
legend('z')
figure
w=2*pi*0.5e6;
plot(t,y(10).*sin(w*t),'g')
legend('Ultrasound pressure')

% figure
% plot(t,y(4,1:length(t)),'c')
% legend('n_a')
% figure
% plot(t,y(6,1:length(t)),'r')
% hold on
% plot(t,y(7,1:length(t)),'b')
% plot(t,y(8,1:length(t)),'m')
% plot(t,y(9,1:length(t)),'k')
% 
% legend('n','m','h','p')

%figure
%for i=1:13
%    plot(t,y(:,i),'color',rand(1,3));
%    hold on
%end
%legend('dVmCm','C','v','z','P_in'
