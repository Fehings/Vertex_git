function dy=fusBLS_hh(time,tstep,y)
% FUS membrane capacitance equations, BLS equations


%% initial values - these will need to be inputs to the function.

% extract from the y0 vector/ matrix, given as an input to the function.
Cm=y(1); % capacitance, farads/m^2.
v=y(2);  % speed of the membrane change due to cavitation. m s^-1
z=y(3);  % length of the deviation of the membrane from it's norm. m  
n_a=y(4); % mole content of ideal gas Moles
Vm=y(5);  % membrane voltage potential V
n=y(6);  % gates open probability for voltage dependent potassium channels
m=y(7);  % gates open probability for voltage dependent sodium channels
h=y(8);  % gates open probability for voltage dependent sodium channels
p=y(9);   % gates open probability for voltage dependent potassium channels
Pa=y(10);% The acoustic pressure (currently static) Pa

% in case the input was a set of matrices, form them into vectors.
%  Pa=Pa(:); %temporarily muting fus stim...
%  z=z(:);
%  v=v(:);
%  Vm=Vm(:);
%  s=size(Cm); % record the original matrix size.
%  Cm=Cm(:);
 
%% constants

w=2*pi*0.5e6; % angular frequency of ultrasound (MHz)
delta = 1.26e-9; % m
delta_s=1.4e-9; % m
a = 32e-9; % radius of the leaflet's boundary 32nm, converted to metres.
squiggle = 0.5e-9; % boundary layer length between the surrounding medium and the leaflets, 0.5nm
P0 = 10^5; % rest pressure, Pa
e0 = (8.854187817*10^-12); % vacuum permittivity constant, farads/m
er = 1; % relative permittivity of the intramembrane cavity, no units
mu=0.7*10^-3; % dynamic viscosity of the surrounding medium, Pa.s
mus=0.035; % Pa.s
d0=2e-9; % thickness of leaflet m
D_a=3e-9; % 3e-9 m^2 s^-1; Diffusion coefficient for air in the surrounding medium.
rho=1028; % density of the surrounding medium, kg m^-3
c=1515; % speed of sound in the surrounding medium, m S^-1
C_a=0.62; % initial air molar concentration in the surrounding medium, mole m^-3
K_a=1.63e5; % Henry's constant for dissolved air in the surrounding medium, Pa m^3 moles^-1
K_s=0.24; % the areal modulus of the bilayer membrane, Newton m^-1 NB: varied in the Krasovitski paper
Tem=309.15; % temperature of the surrounding medium, K.
x=5;
yoy=3.3;
Cm0=0.01;  % cell membrane capacitance at rest, F m^-2 (1 microf cm^-2)
Vm0=-0.0719; % rest potential of the cell membrane, V (-71.9mV)
A_r=10^5; % attraction/repulsion pressure coefficient, Pa
R_g=8.314459848; % gas constant, in m^3 Pa K^-1 moles^-1

%% equations
% Bubble dynamics BLS equations

% radius of curvature (should come out in metres):
R=(a^2+z.^2)./(2.*z);

% electric equivalent pressure term (Pa):
P_ec=-(a^2./(z.^2+a.^2)).*((Cm.*Vm).^2./(2*e0*er));

% z(r), the local deflection at each radial coordinate
%z_r=sign(R)*sqrt(R^2-r^2)-R+z; 
% molecular forces between the lipid bilayer:

delta_s=delta; %NB this is a temporary change to replicate the Krasovitski version of these equations

fr=@(r) (A_r.*((delta_s./(2.*(sign(R).*sqrt(abs(R.^2-r.^2))-R+z)+delta)).^x...
    -sign(delta_s./(2.*(sign(R).*sqrt(abs(R.^2-r.^2)) ...
    -R+z)+delta)).*(abs(delta_s./(2.*(sign(R).*sqrt(abs(R.^2-r.^2))-R+z)+delta)).^yoy))).*r;
% catch any potential singularities in the integration formula:
singularity=sqrt(R^2-((R-z-delta)^2)/4); % solving for 2*(signR*sqrt(R^2-r^2))-R+r)+delta=0

tol=1e-7;

if (0-tol <= singularity) && (singularity <= a+tol) % if the singularity falls within the integration bounds 0 to a
    epsilon = 1e-9; % this will be how close we allow ourselves to get to the singularity
    % split the integration into two parts to avoid the singularity
    int1=integral(fr,0,singularity-epsilon,'ArrayValued',true); %integrate from 0 to right by the singularity
    int2=integral(fr,singularity+epsilon,a,'ArrayValued',true); %integrate from just after the singularity to a
    intfr=int1+int2; % add the two parts together. This will be a litte imprecise, but will avoid horrible pain to Matlab trying to divide by zero.
    
else
    % find the integral for fr from 0 to a:
    intfr=integral(fr,0,a,'ArrayValued',true);
end
   % NB: this may produce complex numbers, if it trys to take negative
   % numbers to the power of 3.3, a non-integer. Taking the abs of what is
   % raised to 3.3 to avoid this. Is that ok...?

  % intval=intfr
   
% molecular pressure Pa:
P_M=(2./(z.^2 + a^2)).*intfr;
% intramembrane cavity volume:
V_a=pi.*(a^2).*delta.*(1+(z./(3.*delta)).*((z.^2./a^2)+3));
% intramembrane gas pressure Pa:
P_in=(n_a.*R_g.*Tem)./V_a;
%P_in=P0*(1+z/(6*delta)*(3+(z^2)/(a^2)))^-1;

% gas balance equation:
%if v==0 % this is a quick fix, because without it dn_a increases stupidly when there is no change in z. Actually it still does.
    dn_a=0;
%else
%    dn_a=((2*pi.*(a^2+z.^2).*D_a)./squiggle).*(C_a-(P_in./K_a)); %dn_a represents dn_a/dt
%end
% changed P_in in the above equation to P_0, as with P_in it causes a
% feedback loop which pushes P_in and n_a to silly numbers, particularly
% when z is static. P_0 is the initial default value for P_in.
% membrane surface pressure
P_s=((2.*K_s.*z.^3)./(a^2.*(a^2+z.^2)));


%% Gas bubble equations 
% all of the p terms collected for neatness, differ if z<0, to ensure that
% P is positive.

zmin=0.1e-9; %when it gets close to zero, 

if z>zmin % should this be zero, or just above?
    
    P=P_in+P_M+P_ec-P0+Pa*sin(w*time)-P_s;
    dv=((1./(rho.*R)).*(P-(4./R).*v.*(((3*mus*d0)/R)+mu)))-(3./(2.*R)).*v.^2;
    dz=v;
    
elseif z<-zmin
    
    P=-P_in-P_M-P_ec+P0-Pa*sin(w*time)-P_s;
    dv=((1./(rho.*(R))).*(P-((4./R).*abs(v).*((3*mus*d0./R)+mu))))-(3./(2.*R)).*abs(v).^2;
    dz=v;
    
elseif abs(z)<=zmin
    P=Pa*sin(w*time);
    dv=-v*1/tstep+P*(10^(-4)); 
    % I am putting this in as a temporary fix, the change in v is -v, so 
    % that v should become zero, and then next turn dv will be zero if
    % there is no fUS.
    
% problem is, this gets stuck at a fixed point. So here taking dv as
% influenced only by the external pressure. Assuming 10^6 Pa causes 1nm
% deviation gives *10^-15 Pa^-1 m. NB: from the Krasovitski paper (bottom
% of SI pg1) it is mentioned that the pressure required to seperate the
% membrane should be approx. 1.48*10^4 Pa. Therefore instead of 10^6 we use
% 10^4, and so the constant should be 10^-13 to create a nm deflection.
    dz=v;    
else 
    msg='z has a Nan or Inf value';
    error(msg)
end


%% membrane capacitance:
Cm =((Cm0*delta)/a^2.*(z+(((a^2)-(z.^2)-(z*delta))./(2*z)).*log((2*abs(z)+delta)./delta))); % finds the current capacitance.



%Cm_print=Cm
%y1print=y(1)
dCm=Cm-y(1); % Change in capacitance, y(2) is the old Capacitance as it hasn't been updated yet.
%dCm_print=dCm


%% assign change vector y values

% reshape into matrices if they were initially:
% dz=reshape(dz,[s]);
% dv=reshape(dv,[s]);
%Cm=(reshape(Cm,s));

% change in parameters:
dy(1)=dCm;
dy(2)=dv;
dy(3)=dz;
dy(4)=dn_a;

dy(10)=0; % Pa is not changing. 


%% Hodgekin Huxley code for replication of the fusBLS study findings
%function y = HH(t,y)

% parameter values taken from Plaskin supplementary material
G_leak=0.205; % originally in mS cm^-2, converted to S m^-2 (current units) by multiplying by 10.
G_na_bar=560; % 50 in pospischil s m^-2
V_na=0.050; % volts
G_k_bar=60; %5 in pospischil s m^-2
V_k=-0.090; % volts
G_m_bar=0.75; % 0.004 in pospischil  s m^-2
V_leak=-0.0703; % volts
Vt=-0.0562; % volts
Tmax=4;%0.608; %4 s in pospischil, 0.00608 units in seconds

%% equations

p_inf=1./(1+exp(-(Vm+0.035)./0.010));
tau_p=Tmax/(3.3*exp((Vm+0.035)./0.020)+exp(-(Vm+0.035)./0.020));

a_n=-0.032*(Vm-Vt-0.015)./(exp(-(Vm-Vt-0.015)/0.005)-1);
% NB: Vt controls spike threshold
a_m=(-0.32*(Vm-Vt-0.013))./(exp(-(Vm-Vt-0.013)/0.004)-1);
a_h=0.128*exp(-(Vm-Vt-0.017)/0.018);

beta_n=0.5.*exp(-(Vm-Vt-0.010)/0.040);
beta_m=(0.28*(Vm-Vt-0.040))./(exp((Vm-Vt-0.040)/0.005)-1);
beta_h=4./(1+exp(-(Vm-Vt-0.040)/0.005));

dn=a_n.*(1-n)-beta_n.*n;
dm=a_m.*(1-m)-beta_m.*m;
dh=a_h.*(1-h)-beta_h.*h;
dp=(p_inf-p)./tau_p;

G_na=G_na_bar.*m.^3.*h;
G_k=G_k_bar.*n.^4;
G_m=G_m_bar.*p;

%% main membrane voltage equation

dVm=-(1./Cm).*(Vm*(dCm*tstep)+G_na.*(Vm-V_na)+G_k.*(Vm-V_k)+G_m.*(Vm-V_k)+G_leak.*(Vm-V_leak));
%should be /Cm

%dVm=reshape(dVm,[s]);

%% assign changes to the output vectorclose all

dy(5)=dVm;
dy(6)=dn;
dy(7)=dm;
dy(8)=dh;
dy(9)=dp;


% voltage=Vm
% capacitance=Cm
% P
% dVm

if isnan(Cm)
    msg='Nan appeared';
    error(msg)
end

dy=dy';

% scatter(time,P_M,'b')
% hold on
% scatter(time,P_s,'k')
% scatter(time,P_in,'m')
% 
% P_s
% P_M
% P_in
% hold on
% scatter(time,Pa*sin(time*w))
% drawnow
end
