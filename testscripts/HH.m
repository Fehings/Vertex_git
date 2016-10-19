

function y = HH(t,y)
% Hodgekin Huxley code for replication of the fusBLS study findings

dCmVm=y(1); %dCmVm placeholder
Cm=y(2);
params.v=y(3);
params.z=y(4);
params.P_in=y(5);
params.n_a=y(6);
Vm=y(7);
hh.n=y(8);
hh.m=y(9);
hh.h=y(10);
hh.p=y(11);
Pa=y(12);

s=size(Vm);
Vm=Vm(:);

dCmVm=dCmVm(:);

% parameter values taken from Plaskin supplementary material
G_leak=0.0205;
G_na_bar=56; % 50 in pospischil
V_na=50;
G_k_bar=6; %5 in pospischil
V_k=-90;
G_m_bar=0.075; % 0.004 in pospischil 
V_leak=-70.3;
Vt=-56.2;
Tmax=608; %4 in pospischil

n=hh.n;
m=hh.m;
h=hh.h;
p=hh.p;

p_inf=1./(1+exp(-(Vm+35)./10));
tau_p=Tmax./(3.3*exp((Vm+35)./20)+exp(-(Vm+35)./20));
a_n=-0.032*(Vm-Vt-15)./(exp(-(Vm-Vt-15)/5)-1); % NB: Vt controls spike threshold
a_m=-0.32*(Vm-Vt-13)./(exp(-(Vm-Vt-13)/4)-1);
a_h=0.128*exp(-(Vm-Vt-17)/18);
beta_n=0.5*exp(-(Vm-Vt-10)/40);
beta_m=0.28*(Vm-Vt-40)./(exp(-(Vm-Vt-40)/5)-1);
beta_h=4./(1+exp(-(Vm-Vt-40)/5));
n=a_n.*(1-n)-beta_n.*n;
m=a_m.*(1-m)-beta_m.*m;
h=a_h.*(1-h)-beta_h.*h;

p=(p_inf-p)./tau_p;
G_na=G_na_bar.*m.^3.*h;
G_k=G_k_bar.*n.^4;
G_m=G_m_bar.*p;


dVm=-(1./Cm).*(Vm*dCmVm+G_na.*(Vm-V_na)+G_k.*(Vm-V_k)+G_m.*(Vm-V_k)+G_leak.*(Vm-V_leak));

dVm=reshape(dVm,[s]);

hh.n=n;
hh.m=m;
hh.h=h;
hh.p=p;

y(1)=0; %dCmVm placeholder
y(2)=0;
y(3)=0;
y(4)=0;
y(5)=0;
y(6)=0;
y(7)=dVm;
y(8)=hh.n;
y(9)=hh.m;
y(10)=hh.h;
y(11)=hh.p;
y(12)=0;

%size(y)

end