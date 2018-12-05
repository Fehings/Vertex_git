

%Recording settings
%These describe which variables to record, we are interested in membrane
%potentials and local field potentials. 
%We save the results of the simulation in this folder, they can be loaded
%at any time after the simulation has finished by loading into memory the
%Results file. Use Results = loadResults(RecordingSettings.saveDir); to do
%this.

RecordingSettings.LFP = true;
[meaX, meaY, meaZ] = meshgrid(1200:-100:500, 300, 1800:-100:300);
RecordingSettings.meaXpositions = meaX;
RecordingSettings.meaYpositions = meaY;
RecordingSettings.meaZpositions = meaZ;
RecordingSettings.minDistToElectrodeTip = 20;

%RecordingSettings.v_m = 1:100:33312;
%RecordingSettings.stp_syn =[77321;77750;77902;78027;78041;78047;78099;78107;78115;78138;78143;78151;78177;78202;78205;78229;78275;78278;78282;78289;78297;78298;78300;78305;78308;78321;78327;78335;78337;78339;78349;78350;78367;78368;78370;78374;78397;78410;78413;78414;78419;78425;78426;78428;78429;78447;78448;78461;78469;78491;78498;78502;78508;78510;78511;78513;78525;78528;78530;78533;78542;78548;78549;78550;78556;78558;78560;78563;78566;78576;78578;78580;78584;78585;78586;78587;78589;78592;78593;78599;78600;78606;78608;78617;78619;78622;78623;78626;78631;78637;78639;78644;78645;78653;78654;78658;78663;78668;78670;78674;78676;78683;78686;78688;78689;78692;78695;78702;78705;78710;78723;78724;78725;78728;78729;78732;78737;78738;78740;78742;78745;78747;78748;78755;78757;78759;78762;78764;78765;78770;78774;78777;78779;78780;78785;78789;78791;78794;78795;78798;78800;78803;78813;78814;78815;78823;78824;78830;78843;78851;78852;78855;78856;78858;78861;78867;78868;78870;78874;78879;78880;78881;78884;78886;78887;78888;78891;78892;78893;78898;78900;78907;78921;78923;78928;78934;78938;78943;78944;78946;78950;78957;78962;78963;78964;78965;78966;78968;78970;78973;78978;78979;78980;78986;78989;78991;78992;78997;78998;78999;79002;79007;79012;79017;79024;79025;79026;79029;79030;79032;79034;79035;79039;79040;79043;79044;79047;79048;79054;79059;79063;79070;79072;79074;79075;79078;79079;79082;79086;79087;79088;79092;79093;79095;79098;79099;79102;79104;79109;79113;79124;79127;79130;79133;79136;79137;79141;79146;79149;79150;79152;79155;79157;79158;79162;79163;79165;79166;79167;79171;79175;79176;79182;79184;79189;79197;79198;79200;79202;79204;79205;79208;79210;79217;79220;79221;79225;79226;79228;79239;79244;79248;79250;79251;79252;79254;79259;79271;79275;79276;79278;79281;79282;79284;79286;79287;79301;79302;79308;79310;79322;79331;79344;79353;79361;79401;79417;79419;79432;79433;79436;79439;79446;79454;79455;79458;79468;79471;79493;79495;79505;79508;79517;79518;79527;79528;79536;79539;79545;79546;79549;79565;79569;79584;79586;79595;79614;79617;79631;79646;79647;79649;79661;79676;79685;79695;79698;79715;79717;79728;79729;79750;79754;79764;79771;79791;79795;79802;79822;79824;79832;79838;79846;79851;79857;79858;79878;79891;79892;79904;79923;79924;79926;79927;79934;79955;79976;79982;79985;79992;80006;80024;80026;80029;80033;80063;80086;80092;80111;80123;80137;80155;80166;80171;80172;80178;80181;80182;80188;80197;80198;80201;80229;80231;80266;80293;80309;80310;80315;80326;80328;80335;80339;80346;80384;80403;80445;80446;80451;80466;80469;80476;80496;80510;80530;80562;80594;80606;80623;80627;80723;80871]';
%RecordingSettings.I_syn = 1:100:33312;
%post synaptic recruitment 1450 1200
%Record post synaptically
 RecordingSettings.I_syn_location = [[1150 1200];[1150 1200];[1150 1200]];
RecordingSettings.I_syn_number = [50, 50, 50];
RecordingSettings.I_syn_group = [13, 14, 8];
RecordingSettings.v_m_location = [[1150 1200];[1150 1200];[1150 1200]];
RecordingSettings.v_m_number = [50, 50, 50];
RecordingSettings.v_m_group = [1, 14, 8];
%Record pre synaptically
%  RecordingSettings.stp_syn_location = [[1150 1200];[1150 1200];[1150 1200]];
% RecordingSettings.stp_syn_number = [50, 50, 50];
% RecordingSettings.stp_syn_group = [13, 14, 8];
% RecordingSettings.I_syn_preGroups = [6:20];
% for iGroup = 1:29
%     RecordingSettings.I_synComp_groups(iGroup) = iGroup;
%     RecordingSettings.I_synComp_Xboundary(iGroup,:) = [1100 1200];
%     RecordingSettings.I_synComp_Yboundary(iGroup,:) = [150 200];
%     RecordingSettings.I_synComp_Zboundary(iGroup,:) = [300 1800];
% end
%  RecordingSettings.I_synComp_location = [[1150 1200];[1150 1200];[1150 1200]];
% RecordingSettings.I_synComp_number = [50, 50, 50];
% RecordingSettings.I_synComp_groups = [13, 14, 8];

RecordingSettings.maxRecTime = 5000;
RecordingSettings.sampleRate = 5000;

%Simulation settings:
%Keep max delay steps at 80, 
%Simulation time can be varied, it is in milliseconds, currently running
%for 500 ms.
%We want to run this simulation in parallel, this means that all cpu cores
%will be utilised in the simulations, with the neurons being distributed
%across them, as this simulation is large this is necessary to minimize the
%run time of the simulation. 
SimulationSettings.maxDelaySteps = 80;
SimulationSettings.simulationTime = 400;
SimulationSettings.timeStep = 0.03125;
SimulationSettings.parallelSim =true;


%%
%This initialises the network and sets up other variables. 
[params, connections, electrodes] = ...
  initNetwork(TissueParams, NeuronParams, ConnectionParams, ...
              RecordingSettings, SimulationSettings);

%%

tic;
runSimulation(params, connections, electrodes);
toc;