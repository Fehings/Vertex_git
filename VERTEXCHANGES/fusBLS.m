function [C,P_in,n_a,v,z,dCmVm]=fusBLS(Pa,Vm,params,t)
% FUS membrane capacitance equations, BLS equations

% NB: Need to check units in this script, that they match the units used in
% Vertex (mV, nS, picoAmps, S/m, Ohm/cm, microF/cm^2, Ohm/cm^2, ms.


% Vm will likely be a matrix, no. of neurons by no. of compartments
% Cm will also be a matrix of the same dimensions, this means that z and v
% will need to be too.

dt=params.tstep; %time step?
%Pa=500; % acoustic pressure of ultrasound (kPa)
w=2*pi*0.35e6; % angular frequency of ultrasound, radians, found by 2*pi*frequency(Hz)
% t and Vm come as inputs

% input and outputs: z,v,n_a,p_in

%% initial values - these will need to be inputs to the function.

Pa=abs(Pa(:))*100000; %the abs()*1000 are a temporary fix for me using electric field values rather than a proper acoustic FEM.
P_in=params.P_in;
P_in=P_in(:);
z=params.z;
z=z(:);
v=params.v;
v=v(:);
n_a=params.n_a;
Vm=Vm(:);
Cm=params.C;
s=size(Cm);
Cm=Cm(:);
%% constants
delta = 1.26;
delta_s=1.4;
a = 32; % radius of the leaflet's boundary, nm
sigma = 0.5; % boundary layer length between the surrounding medium and the leaflets
P0 = 10^5;
e0 = 8.854187817*10^-12; % vacuum permittivity constant
er = 1; % relative permittivity of the intramembrane cavity
mu=0.7*10^-3; % dynamic viscosity of the surrounding medium
D_a=3*10^-9; % Diffusion coefficient for air in the surrounding medium
rho=1028; % density of the surrounding medium
c=1515; % speed of sound in the surrounding medium
C_a=0.62; % initial air molar concentration in the surrounding medium
K_a=1.63*10^5; % Henry's constant for dissolved air in the surrounding medium
K_s=0.24; % the areal modulus of the bilayer membrane, Nm^-1 NB: varied in the Krasovitski paper
Tem=309.15; % temperature of the surrounding medium, K.
x=5;
y=3.3;
Cm0=2.95;  % cell membrane capacity at rest
Vm0=-71.9; % rest potential of the cell membrane
A_r=10^5; % attraction/repulsion pressure coefficient
R_g=8.314459848; % gas constant

%% equations

% Bubble dynamics BLS equation
%Z''+3/2*R*Z^2 = 1/(rho*mod(Rz))*(P_in+P_M+P_ec-P0+P_A*sin(wt)-P_s(Z)--4/mod(Rz)*z'(3d0mus/mod(Rz)+mu1)); 
% splitting into 2 first order odes, call Z''=v' and Z'=z' 

% radius of curvature:
R=(a^2+z.^2)./2.*z; 
% electric equivalent pressure term:
P_ec=-a^2./(z.^2+a.^2).*((Cm.*Vm).^2./(2*e0*er)); 
% z(r), the local deflection at each radial coordinate
%z_r=sign(R)*sqrt(R^2-r^2)-R+z; 
% molecular forces between the lipid bilayer:
%fr=@(r) A_r.*((delta_s./(2.*(sign(R).*sqrt(R.^2-r.^2)-R+z)+delta)).^x-(delta_s./(2.*(sign(R).*sqrt(R.^2-r.^2)-R+z)+delta)).^y);

fr=@(r) (A_r.*((delta_s./(2.*(sign(R).* sqrt(abs(R.^2-r.^2)) -R+z)+delta) ).^x ...
    - sign(delta_s./(2.*(sign(R).*sqrt(abs(R.^2-r.^2)) ...
    -R+z)+delta).*(abs(delta_s./(2.*(sign(R).*sqrt(abs(R.^2-r.^2)) -R+z)+delta)).^y)))).*r;

% catch any potential singularities in the integration formula:
singularity=sqrt(R.^2-((R-z-delta).^2)/4); % solving for 2*(signR*sqrt(R^2-r^2))-R+r)+delta=0
%check if there are any singularities in the integration range:
check=singularity(singularity>=0 & singularity<=a);


unique(z)
unique(singularity)

if ~isempty(check)%(0 <= singularity) && (singularity <= a) % if the singularity falls within the integration bounds 0 to a
    if length(unique(check))>1
        ME = MException('Too many singularities, Matlab cannot deal. Goodnight.',str);
        error(ME)
    else
    alert_message='Integrating around a singularity, just so you know.'    
    epsilon = 0.01; % this will be how close we allow ourselves to get to the singularity
    % split the integration into two parts to avoid the singularity
    
    int1=integral(fr,0,unique(singularity)-epsilon,'ArrayValued',true); %integrate from 0 to right by the singularity
    int2=integral(fr,unique(singularity)+epsilon,a,'ArrayValued',true); %integrate from just after the singularity to a
    intfr=int1+int2; % add the two parts together. This will be a litte imprecise, but will avoid horrible pain to Matlab trying to divide by zero.
    end
else
    % find the integral for fr from 0 to a:
    intfr=integral(fr,0,a,'ArrayValued',true,'AbsTol',1e-3,'RelTol',1e-2 );
end
   % NB: this may produce complex numbers, if it trys to take negative
   % numbers to the power of 3.3, a non-integer. Taking the abs of what is
   % raised to 3.3 to avoid this. Is that ok...?
   
   
% find the integral for fr from 0 to a:
intfr=integral(fr,0,a,'ArrayValued',true);
% molecular pressure:
P_M=2./(z.^2 + a^2).*intfr;
% intramembrane cavity volume:
V_a=pi.*(a^2).*delta.*(1+z./3.*delta.*(z.^2./a^2+3));
% intramembrane gas pressure:
P_in=(n_a*R_g*Tem)./V_a;
% gas balance equation:
n_a=n_a+(((2*pi.*(a^2+z.^2).*D_a)./sigma).*(C_a-P_in./K_a)).*dt; % added multiplication by timestep as no explicit solver is used?
% membrane surface
P_s=(2.*K_s.*z.^3)./(a^2.*(a^2+z.^2)); %check this, taken from the K paper supplementary stuff.
% all of the p terms collected for neatness

%P=P_in+P_M+P_ec-P0+Pa*sin(w*t)-P_s; % check where the value for t is stored

%% Gas bubble equations

zmin=0.5; %when it gets close to zero, 

if z>zmin % should this be zero, or just above?
    P=P_in+P_M+P_ec-P0+Pa*sin(w*count)-P_s;
    dv=((1./(rho.*(abs(R)))).*(P-((4./abs(R)).*abs(z).*((0.21./abs(R))+mu))))-(3./(2.*R)).*abs(z).^2;
    dz=v;
elseif z<-zmin
    P=-P_in-P_M-P_ec+P0-Pa*sin(w*count)-P_s;
    dv=((1./(rho.*(abs(R)))).*(P-((4./abs(R)).*abs(z).*((0.21./abs(R))+mu))))-(3./(2.*R)).*abs(z).^2;
    dz=v;
else
    dv=Pa; % problem is, this gets stuck at a fixed point.
    dz=v;
end
%z=z+v; % because not using a solver, this needs to be manually updated by z+... and below, v+..., right? And the timestep multiplication.
%v=v+((1./(rho.*(abs(R)).*(P-(4./abs(R).*z.*(0.21./abs(R)+mu)))))-(3./(2.*R)).*z.^2).*dt;

%% membrane capacitance:
Cm_new = Cm0*delta/a^2.*(z+(((a^2)-(z.^2)-(z*delta))./(2*z)).*log((2*abs(z)+delta)./delta));


%% reset parameters



P_in=reshape(P_in,[s]);
z=reshape(z,[s]);
v=reshape(v,[s]);

dCmVm=Vm.*(Cm_new-Cm); % find the capacitive displacement current
%Vm_print=Vm
dCmVm=(reshape(dCmVm,s));
%dCmVm_print=unique(dCmVm(:))

C=(reshape(Cm_new,s)); % reassign C to the newly calculated C value.
%C_print=unique(C)


end
