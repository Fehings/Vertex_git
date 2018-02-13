%function [T,Y,VERTEX] = JanRitmeetsVertex()

% the idea here is to couple a VERTEX instance to multiple instances of the
% JanRit model

% gonna need a different linking than the multiregion format I think...
% instead have the output of the janrit model sent as a weighted input to
% certain neurons, using a new input model 'i_janrit' for this.

connectmat = [0,1;1,0]; % connectivity matrix, can be weighted but lets keep it binary for now.
varargin = [];
end_t = 0.5; % how long it's running 'till. This is in seconds.
distMat = [0,0;0,0]; % if delays are needed

setup_multiregion; % load VERTEX parameters

rng(1);

SimulationSettings.simulationTime = end_t*1000; %convert to ms
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim = false;
RecordingSettings.LFPoffline = true;
RecordingSettings.saveDir = '~/Documents/MATLAB/Vertex_Results/VERTEX_results_janrit/janvertex_test';
%RecordingSettings.weights_arr = 1:5000:6000;
RecordingSettings.LFP = true;
%RecordingSettings.weights_preN_IDs = 2972:3000;
%RecordingSettings.samplingSteps = 1:10:10000;
RecordingSettings.v_m = 100:600:1200;%100:1000:4000;%250:250:4750;
RecordingSettings.maxRecTime = 100;
RecordingSettings.sampleRate = 1000;
RecordingSettings.LFP_janrit = true;

for i = 1:length(NeuronParams)
    NeuronParams(i).Input(2).inputType = 'i_janrit';
    NeuronParams(i).Input(2).extIn = 0;
    NeuronParams(i).Input(2).multiplier = 0.5;
end

 NeuronParams(1).Input(2).multiplier = 5000;
 
 
 
 
 
 
 %% stimulation

% for vertex: a step current stim to test that the connectivity is working.
% NeuronParams(1).Input(3).inputType = 'i_step';
% NeuronParams(1).Input(3).timeOn = 30;
% NeuronParams(1).Input(3).timeOff = 40;
% NeuronParams(1).Input(3).amplitude = 10000; 
 
% for vertex: a DC field applied to the region
[stlresult,model] = invitroSliceStim('tutorial2_3.stl',6);
 TissueParams.StimulationField = stlresult;
 TissueParams.StimulationOn = 0;
 TissueParams.StimulationOff = SimulationSettings.simulationTime;



%for janrit: to send a step current stim
p.stepstimon = end_t; %0.5;
p.stepstimoff = end_t;%0.51;
p.stepstimstrength = 0; %-100000; % for multiple JanRit regions will need to make these all vectors for the length: regions

 
%%

[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);
          
VERTEX = setupSimulation(params, connections, electrodes);

VERTEX.region = 1; %which region the vertex model will occupy
% choose a region to be the VERTEX population


%% An adaption of the Jansen Rit model for multiple columns 
% - based on David and Friston - 
% which can be used with the Heun ODE solver so that 'p' can be stochastic.

% TO DO:

% Need to get the connection inputs, based on deviation from expectation, to
% draw the expectation from the previous time steps not just the current
% step - for both p and S_out.

% Think about how to incorporate surface area. (Could increase internal
% populations proportionally, but that would be v. computationally
% expensive)


%function [T,Y]=janrit_msdelay(end_t,connect,VERTEX,varargin)

% end_t is the final time point, an integer. connect is the connectivity
% matrix and should be square and undirected.
% Optionally add a distance matrix for delays


%% Establish parameters
% NB: 113.58-p-137.38 with standard parameters allows epileptic activity?

num_nodes=length(connectmat);
p.num_nodes = num_nodes;
% Variables
p.A=3.25;   % proportional to the amplitude of the excitatory PSP, mV
p.B=22;
% proportional to the amplitude of the inhibitory PSP, mV
C=135;    % Determinant of connectivity constants (most variable) 135 gives alpha wave activity 

% constants
p.a=100;  % excitatory delays in the dendritic network, inversley proportional to the duration of PSPs
p.b=50;   % inhibitory delays in the dendritic network, inversley proportional to the duration of PSPs
% a_d=30; %The delay in s^-1

p.noisescaler=((1-connectmat)/p.num_nodes)*0.1; % so max value multiplying the noise is 0.5. Noise not applied to connected regions
p.noisea=repmat(p.a,1,p.num_nodes);

% Connectivity constants
p.C1=C;
p.C2=0.8*C;
p.C3=0.25*C;
p.C4=0.25*C;

p.x=20; % external connection scaler. Need to increase with larger networks. But why? shouldn't need to.
%10


% External input
%extin= (2.3*(1/p.a))/(0.56*p.A);% 150; %%input from distant columns, in stochastic version vary each time step.was set to 220
p.p=150; %extin;
% u_sdev=0; % No input to the spiny stellate cells  
p.p_sdev=5; % 100/sqrt(3);%Input to the pyramidal

% p_sdev = p_sdev*sqrt(0.0012);%scale, average_timestep_used_by_jr = 0.0012;


% Time points
dt= SimulationSettings.timeStep/1000; % time step for vertex, convert to seconds for JanRit
tspan=[0:dt:end_t];

%% Delays

if isempty(varargin)
    delay=0;
    distMat=zeros(p.num_nodes);
else
    delay=1;
    distMat=cell2mat(varargin(1));
end

p.delay = delay;
propSpeed=100; % 7000; %propogation speed in mm per sec
maxLag=max(max(distMat));
delayIndeces=[maxLag:-propSpeed*dt:0]; % vector from 1 to the max distance in mm in steps of the timestep of the
% solver (i.e. the distance travelled in 1 timestep in mm)
p.max_delay=numel(delayIndeces);
% 3d matrix (nodes X nodes X distance)
m = zeros(num_nodes,num_nodes,p.max_delay);
for i=1:num_nodes
    for j=1:num_nodes
        % find the location in delayIndeces closest to the current value in
        % the connection matrix
        [~,delayLoc]=min(abs(delayIndeces-distMat(i,j)));
        % put the connection weight in that location
        m(i,j,delayLoc)=connectmat(i,j);
    end
end

delayconn=p.x*(reshape(m,p.num_nodes^2,p.max_delay));
p.delayconn=delayconn; % copy this into the VERTEX structure to enable it's use inside Heunmod_vertex
%% stimulation bit

% stimulation needs to be different for different populations, and in
% different brain regions. Predetermined, so it will need to be a large
% matrix with a value for time and for each population. 
% However the stochasitic solver means the time is unknown. Perhaps have it
% either the whole way through, or set to apply after a given t threshold?
% So E is the current/neuron orientation bit, and differs for each region in
% theory, but here lets assume that it is preset depending on the montage,
% and for simplicity have it as a matrix for each region over time with
% zeros as default, and then -1 for cathodal, 1 for anodal? Then the lmda
% can determine the intensity of the stimulation, and a separate scalar can
% reduce this down for the inhibitory pops?

E = zeros(1,p.num_nodes);
%E(1)= 1; E(3)= -1;  % ideally these numbers and locations will come from a FEM.

% For tDCS, have a flat lambda:
 lmda = 0; % the stimulation intensity parameter?

% NB: for tACS, have 
%f= 20; % frequency (Hz)
%omega = 2*pi*f;
%lmda = max_V * sin(t*omega);  % This will need to be within the equations function in order to work...
% taken from the wiki article on AC currents.

p.v_stim = E*lmda; % from the molaee paper this wants to be about 4mv for tDCS?

%% Initial conditions
 
% connect=connect/max(connect); %normalise connectivity matrix
% initial conditions
y0=abs(randn(6*num_nodes,size(m,3))); %Don't start with zeros or k_star tries to divide by zero
% 10*ones(6*num_nodes,size(m,3));


        

%% Solver

% Use ode45 for the deterministic model (when p is constant)
% tic
% [T,Y]=ode45(@jr_f,tspan,y0);
% toc


% use Heun's solver for stochastic model (p is noisy)
tic
sol=Heunmod_vertex(@jr_f, @jr_g,tspan, y0, VERTEX,p);
toc
Y=sol.y';
T=sol.x;

Y=reshape(Y',[6,length(connectmat),length(T)]); % reshape so it's subpopxregionxtime 


%% Plotting
if delay
    T_delays = T;
    T = T(max_delay:length(T_delays)-max_delay);
    Y_delay = Y;
    Y = Y(:,:,max_delay:length(T_delays)-max_delay);
end

%
if num_nodes==2
figure
subplot(2,1,1)
plot(T,(squeeze(Y(2,1,:))-squeeze(Y(3,1,:))));
subplot(2,1,2)
plot(T,(squeeze(Y(2,2,:))-squeeze(Y(3,2,:))));

% If there are more than 3 nodes:
elseif num_nodes<90
    figure
    for i=1:num_nodes
        subplot(ceil(sqrt(num_nodes)),ceil(sqrt(num_nodes)),i)
        %subplot(numnodes,1,i)
        plot(T,(squeeze(Y(2,i,:))-squeeze(Y(3,i,:))))
        ylim([0 20]); xlim([0 end_t]);
    end
else
    figure
    plot(T,(squeeze(Y(2,:,:))-squeeze(Y(3,:,:))));
end

%% Equations to solve
% Write function for janrit equations - use David and Friston's version

    function dy=jr_f(t,y,p)
              
        y=reshape(y,[6,p.num_nodes,p.max_delay]);%reshape input back into celltype x nodes
        yt=squeeze(y(:,:,p.max_delay)); %current time step y
        dy=zeros(6,p.num_nodes); %preassign, a matrix 6 x number of nodes
        outputs=sigm(squeeze(y(2,:,:)-y(3,:,:)));
        if p.delay==0
            outputs=outputs';
        end
        delayed_activity=repmat(outputs,p.num_nodes,1).*p.delayconn;%[vector here of times to access for each node]);
        delayed_activity=sum(delayed_activity,2);
        delayed_activity=sum(reshape(delayed_activity,p.num_nodes,p.num_nodes));
        
        dy(1,:)=yt(4,:);
        dy(4,:)=(p.A*p.a*sigm(yt(2,:)-yt(3,:)))-2*p.a*yt(4,:)-(p.a^2)*yt(1,:) + p.v_stim; % PY cells?
        dy(2,:)=yt(5,:);
        dy(5,:)=p.A*p.a*(p.p+delayed_activity+p.C2*sigm(p.C1*yt(1,:)))-2*p.a*yt(5,:)-(p.a^2)*yt(2,:) + p.v_stim*0.5;% Stim scaler assuming this is I pop, should be about 50% power of PYs 
        dy(3,:)=yt(6,:);
        dy(6,:)=p.B*p.b*(p.C4*sigm(p.C3*yt(1,:)))-2*p.b*yt(6,:)-(p.b^2)*yt(3,:) + p.v_stim*0.35; %stim scaler from taking this to be pop I' from the molaee paper

        dy=reshape(dy,6*p.num_nodes,1);
    
    end

% For using the Heun solver include an optional function for 'g' to work out/scale the noise.
% Taken from the Heun Janrit example script (check it?)

    function gfun=jr_g(t,y,p)   %Noise function - gets multiplied by a random weiner variable in Heun solver
        y=reshape(y,[6,p.num_nodes,p.max_delay]);
        yt=squeeze(y(:,:,p.max_delay)); %current time step y
        gfun = zeros(size(yt));
        %gfun(2)  = a*A*u_sdev;
        %gfun(3)  = b*B*p_sdev;
        gfun(5,:) = (p.noisea*p.A*p.p_sdev)*p.noisescaler*0.5;
        gfun=reshape(gfun,6*p.num_nodes,1);
    end

% figure
% plot(T,squeeze(Y(1,:,:)));


%end