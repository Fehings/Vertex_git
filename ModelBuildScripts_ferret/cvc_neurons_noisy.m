NP(1).modelProportion = 0.2741;
NP(1).neuronModel = 'adex';
NP(1).C = 1.0*2.96;
NP(1).R_M = 20000/2.96;
NP(1).R_A = 1000;%150;
NP(1).E_leak = -70;
NP(1).V_t = -50;
NP(1).delta_t = 2;
NP(1).a = 2.6;
NP(1).tau_w = 65;
NP(1).b = 220;
NP(1).v_reset = -60;
NP(1).v_cutoff = -45;
NP(1).somaLayer = 2;
NP(1).numCompartments = 8;
NP(1).compartmentLengthArr = [13 48 124 145 137 40 143 143];
NP(1).compartmentDiameterArr = [29.8 3.75 1.91 2.81 2.69 2.62 1.69 1.69];
NP(1).compartmentParentArr = [0 1 2 2 4 1 6 6];
NP(1).compartmentXPositionMat = [0 0; 0 0; 0 124; 0 0; 0 0; ...
                                 0 0; 0 -139; 0 139];
NP(1).compartmentYPositionMat = [0 0; 0 0; 0 0; 0 0; 0 0; ...
                                 0 0; 0 0; 0 0];
NP(1).compartmentZPositionMat = [-13 0; 0 48; 48 48; 48 193; ...
                                 193 330; -13 -53; -53 -139; ...
                                 -53 -139];
NP(1).somaID = 1;
NP(1).basalID = [6 7 8];
NP(1).proximalID = [2 6];
NP(1).distalID = [7 8];
NP(1).obliqueID = 3;
NP(1).apicalID = 4;
NP(1).trunkID = 2;
NP(1).tuftID = 5;
NP(1).labelNames = {'somaID', 'basalID','proximalID','distalID','obliqueID','apicalID','trunkID','tuftID'};
NP(1).minCompartmentSize = 4;
NP(1).axisAligned = 'z';
NP(1).Input(1).inputType = 'i_ou';
NP(1).Input(1).meanInput = 400;
NP(1).Input(1).tau = 2;
NP(1).Input(1).stdInput = 210;

NP(2).modelProportion = 0.0327;
NP(2).neuronModel = 'adex';
NP(2).C = 1*2.93;
NP(2).R_M = 15000/2.93;
NP(2).R_A = 1000;%150;
NP(2).E_leak = -70;
NP(2).V_t = -50;
NP(2).v_cutoff = -45;
NP(2).delta_t = 2;
NP(2).a = 0.04;
NP(2).tau_w = 10;
NP(2).b = 40;
NP(2).v_reset = -65;
NP(2).somaLayer = 2;
NP(2).numCompartments = 7;
NP(2).compartmentLengthArr = [10 56 151 151 56 151 151];
NP(2).compartmentDiameterArr = [24 1.93 1.95 1.95 1.93 1.95 1.95];
NP(2).compartmentParentArr = [0 1 2 2 1 5 5];
NP(2).compartmentXPositionMat = [0 0; 0 0; 0 107; 0 -107; ...
                                 0 0; 0 -107; 0 107];
NP(2).compartmentYPositionMat = [0 0; 0 0; 0 0; 0 0; 0 0; ...
                                 0 0; 0 0];
NP(2).compartmentZPositionMat = [-10 0; 0 56; 56 163; ...
                                  56 163; -10 -66; -66 -173; ...
                                 -66 -173];
NP(2).somaID = 1;
NP(2).basalID = [3 4 5 6 7];
NP(2).proximalID = [2 5];
NP(2).distalID = [3 4 6 7];
NP(2).labelNames = {'somaID', 'basalID','proximalID','distalID'};
%NP(2).minCompartmentSize = 4;
NP(2).axisAligned = '';
NP(2).Input(1).inputType = 'i_ou';
NP(2).Input(1).meanInput = 200;
NP(2).Input(1).tau = .8;
NP(2).Input(1).stdInput = 160;

NP(3) = NP(2);
NP(3).modelProportion = 0.0225;
NP(3).V_t = -55;
NP(3).v_cutoff = -50;
NP(3).delta_t = 2.2;
NP(3).a = .04;
NP(3).tau_w = 75;
NP(3).b = 75;
NP(3).v_reset = -62;
NP(3).Input(1).inputType = 'i_ou';
NP(3).Input(1).meanInput = 160;
NP(3).Input(1).tau = .8;
NP(3).Input(1).stdInput = 140;

NP(4) = NP(2);
NP(4).modelProportion = 0.0967;
NP(4).V_t = -50;
NP(4).v_cutoff = -45;
NP(4).delta_t = 2.2;
NP(4).a = .35;
NP(4).tau_w = 150;
NP(4).b = 40;
NP(4).v_reset = -70;
NP(4).somaLayer = 3;
NP(4).Input(1).inputType = 'i_ou';
NP(4).Input(1).meanInput = 205;
NP(4).Input(1).tau = 2;
NP(4).Input(1).stdInput = 150;

NP(5) = NP(4);

NP(6) = NP(1);
NP(6).modelProportion = 0.0967;
NP(6).somaLayer = 3;
NP(6).Input(1).inputType = 'i_ou';
NP(6).Input(1).meanInput = 250;
NP(6).Input(1).tau = 2;
NP(6).Input(1).stdInput = 170;

NP(7) = NP(2);
NP(7).modelProportion = 0.0568;
NP(7).somaLayer = 3;

NP(8) = NP(3);
NP(8).modelProportion = 0.0158;
NP(8).somaLayer = 3;

NP(9).modelProportion = 0.05;
NP(9).neuronModel = 'adex';
NP(9).C = 1.0*2.95;
NP(9).R_M = 20000/2.95;
NP(9).R_A = 1000;%150;
NP(9).E_leak = -70;
NP(9).V_t = -52;
NP(9).v_cutoff = -47;
NP(9).delta_t = 2;
NP(9).a = 10;
NP(9).tau_w = 75;
NP(9).b = 345;
NP(9).v_reset = -60;
NP(9).somaLayer = 4;
NP(9).numCompartments = 9;
NP(9).compartmentLengthArr = [35 65 152 398 402 252 52 186 186];
NP(9).compartmentDiameterArr = [25 4.36 2.65 4.10 2.25 2.4 5.94 3.45 3.45];
NP(9).compartmentParentArr = [0 1 2 2 4 5 1 7 7];
NP(9).compartmentXPositionMat = [0 0; 0 0; 0 152; 0 0; 0 0; ...
                                 0 0; 0 0; 0 -193; 0 193];
NP(9).compartmentYPositionMat = [0 0; 0 0; 0 0; 0 0; 0 0; ...
                                 0 0; 0 0; 0 0; 0 0];
NP(9).compartmentZPositionMat = [-35 0; 0 65; 65 65; ...
                                  65 463; 463 865; 865 1117; ...
                                 -35 -87; -87 -193; -87 -193];
NP(9).somaID = 1;
NP(9).basalID = [7 8 9];
NP(9).proximalID = [2 7];
NP(9).distalID = [8 9];
NP(9).obliqueID = 3;
NP(9).apicalID = [4 5];
NP(9).trunkID = 2;
NP(9).tuftID = 6;
NP(9).labelNames = {'somaID', 'basalID','proximalID','distalID','obliqueID','apicalID','trunkID','tuftID'};
%NP(9).minCompartmentSize = 4;
NP(9).axisAligned = 'z';
NP(9).Input(1).inputType = 'i_ou';
NP(9).Input(1).meanInput = 860;
NP(9).Input(1).tau = 2;
NP(9).Input(1).stdInput = 660;

NP(10) = NP(9);
NP(10).modelProportion = 0.0136;

NP(11) = NP(2);
NP(11).modelProportion = 0.0063;
NP(11).somaLayer = 4;

NP(12) = NP(3);
NP(12).modelProportion = 0.0084;
NP(12).somaLayer = 4;

NP(13) = NP(9);
NP(13).modelProportion = 0.1413;
NP(13).V_t = -50;
NP(13).v_cutoff = -45;
NP(13).delta_t = 2;
NP(13).a = 0.35;
NP(13).tau_w = 160;
NP(13).b = 60;
NP(13).v_reset = -65;
NP(13).somaLayer = 5;
NP(13).Input(1).inputType = 'i_ou';
NP(13).Input(1).meanInput = 660;
NP(13).Input(1).tau = 2;
NP(13).Input(1).stdInput = 470;

NP(14) = NP(13);
NP(14).modelProportion = 0.0468;

NP(15) = NP(2);
NP(15).modelProportion = 0.0416;
NP(15).somaLayer = 5;
NP(15).Input.tau = 2;

