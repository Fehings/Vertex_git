

vals = [1:28];
%vals(29) = [];
vals(17) =[];
vals(1:5) = [];

%%
for i = 1:length(vals)

v=vals(i)
    
mainfreqA(i) = freqestLFP(anodal_noise_ordered(v));
mainfreqC(i) = freqestLFP(cathodal_noise_ordered(v));
mainfreqN(i) = freqestLFP(nostim_noise_ordered(v));

end

%%

for i = 1:length(vals)

v=vals(i)

[ampA(i),layerCorrA(i,:,:,:), magsqCohereA(i,:,:,:)] = analyseLFP(anodal_noise_ordered(v));
[ampC(i),layerCorrC(i,:,:,:), magsqCohereC(i,:,:,:)] = analyseLFP(cathodal_noise_ordered(v));
[ampN(i),layerCorrN(i,:,:,:), magsqCohereN(i,:,:,:)] = analyseLFP(nostim_noise_ordered(v));
[ampS(i),layerCorrS(i,:,:,:), magsqCohereS(i,:,:,:)] = analyseLFP(sideside_noise_ordered(v));

% 
 [pshiftA(i)] = phaseShiftLFPcompare(anodal_noise_ordered(v),nostim_noise_ordered(v),5000,20000)
 [pshiftC(i)] = phaseShiftLFPcompare(cathodal_noise_ordered(v),nostim_noise_ordered(v),5000,20000)
 [pshiftS(i)] = phaseShiftLFPcompare(sideside_noise_ordered(v),nostim_noise_ordered(v),5000,20000)


end

%%

for i = 1:length(vals)
    
    v=vals(i)

    
%     p2pMeanS(i) = ampS(i).p2pMean;
%     peakMeanS(i) = ampS(i).peakMean;
%     RMSMeanS(i) = ampS(i).RMSMean;
%     p2pLayersS(i,:) = ampS(i).p2pLayers;
%     peakLayersS(i,:) = ampS(i).peakLayers;
%     RMSlayersS(i,:)= ampS(i).RMSlayers;
    
    
     p2pMeanN(i) = ampN(i).p2pMean;
    peakMeanN(i) = ampN(i).peakMean;
    RMSMeanN(i) = ampN(i).RMSMean;
    p2pLayersN(i,:) = ampN(i).p2pLayers;
    peakLayersN(i,:) = ampN(i).peakLayers;
    RMSlayersN(i,:)= ampN(i).RMSlayers;
    
    
end


%% 

for i = 1:length(vals)

    v=vals(i)

    pShiftAvAN(i) = pshiftA(i).pShiftAv;
    pShiftAllfreqsAN(i,:) = pshiftA(i).pShiftAllfreqs;
    pShiftApproxAN(i,:) = pshiftA(i).pShiftApprox;
    xcorlagAN(i) = pshiftA(i).xcorlag;
    phaselagAN(i,:) = pshiftA(i).phaselag;
    pShiftLayersAN(i,:) = pshiftA(i).pShiftLayers;
    pShiftLayers2AN(i,:) = pshiftA(i).pShiftLayers2;
       
    
    pShiftAvS(i) = pshiftS(i).pShiftAv;
    pShiftAllfreqsS(i,:) = pshiftS(i).pShiftAllfreqs;
    pShiftApproxS(i,:) = pshiftS(i).pShiftApprox;
    xcorlagS(i) = pshiftS(i).xcorlag;
    phaselagS(i,:) = pshiftS(i).phaselag;
    pShiftLayersS(i,:) = pshiftS(i).pShiftLayers;
    pShiftLayers2S(i,:) = pshiftS(i).pShiftLayers2;
  
    pShiftAvCTH(i) = pshiftC(i).pShiftAv;
    pShiftAllfreqCTH(i,:) = pshiftC(i).pShiftAllfreqs;
    pShiftApproxCTH(i,:) = pshiftC(i).pShiftApprox;
    xcorlagCTH(i) = pshiftC(i).xcorlag;
    phaselagCTH(i,:) = pshiftC(i).phaselag;
    pShiftLayersCTH(i,:) = pshiftC(i).pShiftLayers;
    pShiftLayers2CTH(i,:) = pshiftC(i).pShiftLayers2;
    
   
    p2pMeanA(i) = ampA(i).p2pMean;
    peakMeanA(i) = ampA(i).peakMean;
    RMSMeanA(i) = ampA(i).RMSMean;
    p2pLayersA(i,:) = ampA(i).p2pLayers;
    peakLayersA(i,:) = ampA(i).peakLayers;
    RMSlayersA(i,:)= ampA(i).RMSlayers;
    

    p2pMeanC(i) = ampC(i).p2pMean;
    peakMeanC(i) = ampC(i).peakMean;
    RMSMeanC(i) = ampC(i).RMSMean;
    p2pLayersC(i,:) = ampC(i).p2pLayers;
    peakLayersC(i,:) = ampC(i).peakLayers;
    RMSlayersC(i,:)= ampC(i).RMSlayers;
    
    p2pMeanN(i) = ampN(i).p2pMean;
    peakMeanN(i) = ampN(i).peakMean;
    RMSMeanN(i) = ampN(i).RMSMean;
    p2pLayersN(i,:) = ampN(i).p2pLayers;
    peakLayersN(i,:) = ampN(i).peakLayers;
    RMSlayersN(i,:)= ampN(i).RMSlayers;
    
end
    
%%  Plotting


% layerwise phase shift hists:
subplot(5,1,1)
hist(pShiftLayersCTH(:,1))
xlim([-6 6]);ylim([0 10]);
title('phase shift by layer, cathodal stim')
subplot(5,1,2)
hist(pShiftLayersCTH(:,2))
xlim([-6 6]);ylim([0 10]);
subplot(5,1,3)
hist(pShiftLayersCTH(:,3))
xlim([-6 6]);ylim([0 10]);
ylabel('counts')
subplot(5,1,4)
hist(pShiftLayersCTH(:,4))
xlim([-6 6]);ylim([0 10]);
subplot(5,1,5)
hist(pShiftLayersCTH(:,5))
xlim([-6 6]);ylim([0 10]);
xlabel('phase shift')



figure
subplot(5,1,1)
hist(pShiftLayersAN(:,1))
xlim([-6 6]);ylim([0 10]);
title('phase shift by layer, anodal stim')
subplot(5,1,2)
hist(pShiftLayersAN(:,2))
xlim([-6 6]);ylim([0 10]);
subplot(5,1,3)
hist(pShiftLayersAN(:,3))
xlim([-6 6]);ylim([0 10]);
ylabel('counts')
subplot(5,1,4)
hist(pShiftLayersAN(:,4))
xlim([-6 6]);ylim([0 10]);
subplot(5,1,5)
hist(pShiftLayersAN(:,5))
xlim([-6 6]);ylim([0 10]);
xlabel('phase shift')


figure
subplot(5,1,1)
hist(pShiftLayersS(:,1))
xlim([-6 6]);ylim([0 10]);
title('phase shift by layer, tangental stim')
subplot(5,1,2)
hist(pShiftLayersS(:,2))
xlim([-6 6]);ylim([0 10]);
subplot(5,1,3)
hist(pShiftLayersS(:,3))
xlim([-6 6]);ylim([0 10]);
ylabel('counts')
subplot(5,1,4)
hist(pShiftLayersS(:,4))
xlim([-6 6]);ylim([0 10]);
subplot(5,1,5)
hist(pShiftLayersS(:,5))
xlim([-6 6]);ylim([0 10]);
xlabel('phase shift')


figure
subplot(5,1,1)
hist(pShiftLayersS(:,1))
xlim([-6 6]);ylim([0 10]);
title('phase shift by layer, tangental stim')
subplot(5,1,2)
hist(pShiftLayersS(:,2))
xlim([-6 6]);ylim([0 10]);
subplot(5,1,3)
hist(pShiftLayersS(:,3))
xlim([-6 6]);ylim([0 10]);
ylabel('counts')
subplot(5,1,4)
hist(pShiftLayersS(:,4))
xlim([-6 6]);ylim([0 10]);
subplot(5,1,5)
hist(pShiftLayersS(:,5))
xlim([-6 6]);ylim([0 10]);
xlabel('phase shift')


% av phase hists

figure
hist(pShiftAvAN)
xlim([-6 6]);ylim([0 8]);
xlabel('phase shift'); ylabel('counts');
title('phase shift, anodal stim')

figure
hist(pShiftAvCTH)
xlim([-6 6]);ylim([0 8]);
xlabel('phase shift'); ylabel('counts');
title('phase shift, cathodal stim')

figure
hist(pShiftAvS)
xlim([-6 6]);ylim([0 8]);
xlabel('phase shift'); ylabel('counts');
title('phase shift, side side stim')




%% root mean squared mean amplitude diffs
RMSMeanDiffA = (RMSMeanA - RMSMeanN);
RMSMeanDiffC = (RMSMeanC - RMSMeanN);
RMSMeanDiffS = (RMSMeanS - RMSMeanN);


figure
hist(RMSMeanDiffA)
xlim([-10e-4 10e-4]);ylim([0 9]);
xlabel('RMS amplitude shift'); ylabel('counts');
title('RMS amplitude shift, anodal stim')
figure
hist(RMSMeanDiffC)
xlim([-10e-4 10e-4]);ylim([0 9]);
xlabel('RMS amplitude shift'); ylabel('counts');
title('RMS amplitude shift, cathodal stim')

figure
hist(RMSMeanDiffS)
%xlim([-10e-4 10e-4]);ylim([0 9]);
xlabel('RMS amplitude shift'); ylabel('counts');
title('RMS amplitude shift, cathodal stim')

%%

figure
subplot(5,1,1)
hist(RMSlayersA(:,1))
xlim([0.01 0.05])
ylim([0 10])
title('RMS amplitude by layer, anodal stim')
subplot(5,1,2)
hist(RMSlayersA(:,2))
xlim([0.01 0.05])
ylim([0 10])
subplot(5,1,3)
hist(RMSlayersA(:,3))
xlim([0.01 0.05])
ylim([0 10])
ylabel('counts');
subplot(5,1,4)
hist(RMSlayersA(:,4))
xlim([0.01 0.05])
ylim([0 10])
subplot(5,1,5)
hist(RMSlayersA(:,5))
xlim([0.01 0.05])
ylim([0 10])
xlabel('RMS amplitude');



figure
subplot(5,1,1)
hist(RMSlayersN(:,1))
xlim([0.01 0.05])
ylim([0 10])
title('RMS amplitude by layer, no stim')
subplot(5,1,2)
hist(RMSlayersN(:,2))
xlim([0.01 0.05])
ylim([0 10])
subplot(5,1,3)
hist(RMSlayersN(:,3))
xlim([0.01 0.05])
ylim([0 10])
ylabel('counts');
subplot(5,1,4)
hist(RMSlayersN(:,4))
xlim([0.01 0.05])
ylim([0 10])
subplot(5,1,5)
hist(RMSlayersN(:,5))
xlim([0.01 0.05])
ylim([0 10])
xlabel('RMS amplitude');

figure
subplot(5,1,1)
hist(RMSlayersC(:,1))
xlim([0.01 0.05])
ylim([0 10])
title('RMS amplitude by layer, cathodal stim')
subplot(5,1,2)
hist(RMSlayersC(:,2))
xlim([0.01 0.05])
ylim([0 10])
subplot(5,1,3)
hist(RMSlayersC(:,3))
xlim([0.01 0.05])
ylim([0 10])
ylabel('counts');
subplot(5,1,4)
hist(RMSlayersC(:,4))
xlim([0.01 0.05])
ylim([0 10])
subplot(5,1,5)
hist(RMSlayersC(:,5))
xlim([0.01 0.05])
ylim([0 10])
xlabel('RMS amplitude');



RMSLayer_diffsA = RMSlayersA - RMSlayersN;
RMSLayer_diffsC = RMSlayersC - RMSlayersN;
RMSLayer_diffsS = RMSlayersS - RMSlayersN;

figure
subplot(5,1,1)
hist(RMSLayer_diffsA(:,1))
xlim([-0.0025 0.0025])
ylim([0 10])
title('RMS amplitude differences by layer, anodal - no stim')
subplot(5,1,2)
hist(RMSLayer_diffsA(:,2))
xlim([-0.0025 0.0025])
ylim([0 10])
subplot(5,1,3)
hist(RMSLayer_diffsA(:,3))
xlim([-0.0025 0.0025])
ylim([0 10])
ylabel('counts');
subplot(5,1,4)
hist(RMSLayer_diffsA(:,4))
xlim([-0.0025 0.0025])
ylim([0 10])
subplot(5,1,5)
hist(RMSLayer_diffsA(:,5))
xlim([-0.0025 0.0025])
ylim([0 10])
xlabel('RMS amplitude shift');


figure
subplot(5,1,1)
hist(RMSLayer_diffsC(:,1))
xlim([-0.0025 0.0025])
ylim([0 10])
title('RMS amplitude differences by layer, cathodal - no stim')
subplot(5,1,2)
hist(RMSLayer_diffsC(:,2))
xlim([-0.0025 0.0025])
ylim([0 10])
subplot(5,1,3)
hist(RMSLayer_diffsC(:,3))
xlim([-0.0025 0.0025])
ylim([0 10])
ylabel('counts');
subplot(5,1,4)
hist(RMSLayer_diffsC(:,4))
xlim([-0.0025 0.0025])
ylim([0 10])
subplot(5,1,5)
hist(RMSLayer_diffsC(:,5))
xlim([-0.0025 0.0025])
ylim([0 10])
xlabel('RMS amplitude shift');



figure
subplot(5,1,1)
hist(RMSLayer_diffsS(:,1))
xlim([-0.005 0.005])
ylim([0 10])
title('RMS amplitude differences by layer, tangental - no stim')
subplot(5,1,2)
hist(RMSLayer_diffsS(:,2))
xlim([-0.005 0.005])
ylim([0 10])
subplot(5,1,3)
hist(RMSLayer_diffsS(:,3))
xlim([-0.005 0.005])
ylim([0 10])
ylabel('counts');
subplot(5,1,4)
hist(RMSLayer_diffsS(:,4))
xlim([-0.005 0.005])
ylim([0 10])
subplot(5,1,5)
hist(RMSLayer_diffsS(:,5))
xlim([-0.005 0.005])
ylim([0 10])
xlabel('RMS amplitude shift');


% 
% fx=FilterEEG(LFP, 0.1, 1/p.h, 'High', 3);
% window=1500;noverlap=500;f=0.5:1:10;
% [s,f,t,ps] = spectrogram(single(fx),window,noverlap,f,1/p.h);
% helperCWTTimeFreqPlot(s,t,f,'surf','Spectrogram','Seconds','Hz')   
% caxis([0 5000])

%%
% get spike counts

for i = 1:length(vals)

    v=vals(i)
    
    sumSpksA(i)=length(anodal_noise_ordered(v).spikes);
    sumSpksC(i)=length(cathodal_noise_ordered(v).spikes);
    sumSpksN(i)=length(nostim_noise_ordered(v).spikes);

    
    %[~,SpkDiffsA{i},~]=plotSpikeCountsDiff(anodal_noise_ordered(v),nostim_noise_ordered(v));
    %[~,SpksDiffC{i},~]=plotSpikeCountsDiff(cathodal_noise_ordered(v),nostim_noise_ordered(v));

end


%%
load('/Users/a6028564/Documents/MATLAB/Vertex_Results/VERTEX_cvc_results/workspace_nonoise_vertex_anglevsintensitiescvc.mat')

lfpdiv_a0i05=mean(ang0int05.LFP./nostim.LFP);
lfpdiv_a0i1=mean(ang0int1.LFP./nostim.LFP);
lfpdiv_a0i2=mean(ang0int2.LFP./nostim.LFP);
lfpdiv_a0i3=mean(ang0int3.LFP./nostim.LFP);
lfpdiv_a0i4=mean(ang0int4.LFP./nostim.LFP);

lfpdiv_a0_7i4=mean(ang0_7int4.LFP./nostim.LFP);
lfpdiv_a0_7i3=mean(ang0_7int3.LFP./nostim.LFP);
lfpdiv_a0_7i2=mean(ang0_7int2.LFP./nostim.LFP);
lfpdiv_a0_7i1=mean(ang0_7int1.LFP./nostim.LFP);
lfpdiv_a0_7i05=mean(ang0_7int0_5.LFP./nostim.LFP);

lfpdiv_a1_5i05=mean(ang1_5int05.LFP./nostim.LFP);
lfpdiv_a1_5i1=mean(ang1_5int1.LFP./nostim.LFP);
lfpdiv_a1_5i2=mean(ang1_5int2.LFP./nostim.LFP);
lfpdiv_a1_5i3=mean(ang1_5int3.LFP./nostim.LFP);
lfpdiv_a1_5i4=mean(ang1_5int4.LFP./nostim.LFP);

lfpdiv_a2_3i4=mean(ang2_3int4.LFP./nostim.LFP);
lfpdiv_a2_3i3=mean(ang2_3int3.LFP./nostim.LFP);
lfpdiv_a2_3i2=mean(ang2_3int2.LFP./nostim.LFP);
lfpdiv_a2_3i1=mean(ang2_3int1.LFP./nostim.LFP);
lfpdiv_a2_3i05=mean(ang2_3int05.LFP./nostim.LFP);

lfpdiv_a3_1i05=mean(ang3_1int05.LFP./nostim.LFP);
lfpdiv_a3_1i1=mean(ang3_1int1.LFP./nostim.LFP);
lfpdiv_a3_1i2=mean(ang3_1int2.LFP./nostim.LFP);
lfpdiv_a3_1i3=mean(ang3_1int3.LFP./nostim.LFP);
lfpdiv_a3_1i4=mean(ang3_1int4.LFP./nostim.LFP);

%%

lfpmeandiv = [mean(lfpdiv_a0i05(200:1000)),mean(lfpdiv_a0i1(200:1000)),mean(lfpdiv_a0i2(200:1000)),mean(lfpdiv_a0i3(200:1000)),mean(lfpdiv_a0i4(200:1000))];
lfpmeandiv =[lfpmeandiv;mean(lfpdiv_a0_7i05(200:1000)),mean(lfpdiv_a0_7i1(200:1000)),mean(lfpdiv_a0_7i2(200:1000)),mean(lfpdiv_a0_7i3(200:1000)),mean(lfpdiv_a0_7i4(200:1000))];
lfpmeandiv =[lfpmeandiv;mean(lfpdiv_a1_5i05(200:1000)),mean(lfpdiv_a1_5i1(200:1000)),mean(lfpdiv_a1_5i2(200:1000)),mean(lfpdiv_a1_5i3(200:1000)),mean(lfpdiv_a1_5i4(200:1000))];
lfpmeandiv =[lfpmeandiv;mean(lfpdiv_a2_3i05(200:1000)),mean(lfpdiv_a2_3i1(200:1000)),mean(lfpdiv_a2_3i2(200:1000)),mean(lfpdiv_a2_3i3(200:1000)),mean(lfpdiv_a2_3i4(200:1000))];
lfpmeandiv =[lfpmeandiv;mean(lfpdiv_a3_1i05(200:1000)),mean(lfpdiv_a3_1i1(200:1000)),mean(lfpdiv_a3_1i2(200:1000)),mean(lfpdiv_a3_1i3(200:1000)),mean(lfpdiv_a3_1i4(200:1000))];

%%

lfpmod_a0i1=mean(ang0int1.LFP-nostim.LFP);
lfpmod_a0i2=mean(ang0int2.LFP-nostim.LFP);
lfpmod_a0i3=mean(ang0int3.LFP-nostim.LFP);
lfpmod_a0i4=mean(ang0int4.LFP-nostim.LFP);lfpmod_a0_7i4=mean(ang0_7int4.LFP-nostim.LFP);
lfpmod_a0_7i3=mean(ang0_7int3.LFP-nostim.LFP);
lfpmod_a0_7i2=mean(ang0_7int2.LFP-nostim.LFP);lfpmod_a1_5i05=mean(ang1_5int05.LFP-nostim.LFP);
lfpmod_a1_5i1=mean(ang1_5int1.LFP-nostim.LFP);
lfpmod_a1_5i2=mean(ang1_5int2.LFP-nostim.LFP);
lfpmod_a1_5i3=mean(ang1_5int3.LFP-nostim.LFP);
lfpmod_a1_5i4=mean(ang1_5int4.LFP-nostim.LFP);
lfpmod_a2_3i4=mean(ang2_3int4.LFP-nostim.LFP);
lfpmod_a2_3i3=mean(ang2_3int3.LFP-nostim.LFP);
lfpmod_a2_3i2=mean(ang2_3int2.LFP-nostim.LFP);
lfpmod_a2_3i1=mean(ang2_3int1.LFP-nostim.LFP);
lfpmod_a2_3i05=mean(ang2_3int05.LFP-nostim.LFP);
lfpmod_a3_1i05=mean(ang3_1int05.LFP-nostim.LFP);
lfpmod_a3_1i1=mean(ang3_1int1.LFP-nostim.LFP);
lfpmod_a3_1i2=mean(ang3_1int2.LFP-nostim.LFP);
lfpmod_a3_1i3=mean(ang3_1int3.LFP-nostim.LFP);
lfpmod_a3_1i4=mean(ang3_1int4.LFP-nostim.LFP);
lfpmeanmod=[mean(lfpmod_a0i05),mean(lfpmod_a0i1),mean(lfpmod_a0i2),mean(lfpmod_a0i3),mean(lfpmod_a0i4),mean(lfpmod_a0_7i05),mean(lfpmod_a0_7i1),mean(lfpmod_a0_7i2),mean(lfpmod_a0_7i3),mean(lfpmod_a0_7i4),mean(lfpmod_a1_5i05),mean(lfpmod_a1_5i1),mean(lfpmod_a1_5i2),mean(lfpmod_a1_5i3),mean(lfpmod_a1_5i4),mean(lfpmod_a2_3i05),mean(lfpmod_a2_3i1),mean(lfpmod_a2_3i2),mean(lfpmod_a2_3i3),mean(lfpmod_a2_3i4),mean(lfpmod_a3_1i05),mean(lfpmod_a3_1i1),mean(lfpmod_a3_1i2),mean(lfpmod_a3_1i3),mean(lfpmod_a3_1i4)]
lfpmod_a0_7i1=mean(ang0_7int1.LFP-nostim.LFP);lfpmod_a0_7i05=mean(ang0_7int0_5.LFP-nostim.LFP);

%%

for i = 1:length(vals)

    v=vals(i)
lfpdiffAn(i,:,:)=anodal_noise_ordered(v).LFP-nostim_noise_ordered(v).LFP;
lfpdiffCath(i,:,:)=cathodal_noise_ordered(v).LFP-nostim_noise_ordered(v).LFP;

end

%%
colmax = max(abs(lfpmeandiv(:)));
anglesDeg = [0 45 90 135 180];
figure
imagesc(intensities,angles,lfpmeandiv)
caxis([-colmax colmax])

%lfpmeanmod=[mean(lfpmod_a0i05),mean(lfpmod_a0i1),mean(lfpmod_a0i2),mean(lfpmod_a0i3),mean(lfpmod_a0i4),mean(lfpmod_a0_7i05),mean(lfpmod_a0_7i1),mean(lfpmod_a0_7i2),mean(lfpmod_a0_7i3),mean(lfpmod_a0_7i4),mean(lfpmod_a1_5i05),mean(lfpmod_a1_5i1),mean(lfpmod_a1_5i2),mean(lfpmod_a1_5i3),mean(lfpmod_a1_5i4),mean(lfpmod_a2_3i05),mean(lfpmod_a2_3i1),mean(lfpmod_a2_3i2),mean(lfpmod_a2_3i3),mean(lfpmod_a2_3i4),mean(lfpmod_a3_1i05),mean(lfpmod_a3_1i1),mean(lfpmod_a3_1i2),mean(lfpmod_a3_1i3),mean(lfpmod_a3_1i4)]

%% plots for the cathodal figure, replication of the anodal validation


% kruskal wallis spike diffs by layer

%need to first find the spikes by layer...
bounds = [7187 15102 16810 21824] % none in L1

for i = 1:length(vals)

    v=vals(i)
    
    % need to find for each result what the spike count is for each layer
    anSpk = anodal_noise_ordered(v).spikes(:,1);
    cathSpk = cathodal_noise_ordered(v).spikes(:,1);
    nsSpk = nostim_noise_ordered(v).spikes(:,1);
    
    SpkLayAn(i,1) = sum(anSpk<=bounds(1));
    anSpk(anSpk<=bounds(1))=[];
    SpkLayAn(i,2) = sum(anSpk<=bounds(2));
    anSpk(anSpk<=bounds(2))=[];
    SpkLayAn(i,3) = sum(anSpk<=bounds(3));
    anSpk(anSpk<=bounds(3))=[];
    SpkLayAn(i,4) = sum(anSpk<=bounds(4));
        
    SpkLayCth(i,1) = sum(cathSpk<=bounds(1));
    cathSpk(cathSpk<=bounds(1))=[];
    SpkLayCth(i,2) = sum(cathSpk<=bounds(2));
    cathSpk(cathSpk<=bounds(2))=[];
    SpkLayCth(i,3) = sum(cathSpk<=bounds(3));
    cathSpk(cathSpk<=bounds(3))=[];
    SpkLayCth(i,4) = sum(cathSpk<=bounds(4));
    
    SpkLayNS(i,1) = sum(nsSpk<=bounds(1));
    nsSpk(nsSpk<=bounds(1))=[];
    SpkLayNS(i,2) = sum(nsSpk<=bounds(2));
    nsSpk(nsSpk<=bounds(2))=[];
    SpkLayNS(i,3) = sum(nsSpk<=bounds(3));
    nsSpk(nsSpk<=bounds(3))=[];
    SpkLayNS(i,4) = sum(nsSpk<=bounds(4));
    
end

%% combine the matricies for plotting 

anVsNostim = zeros(length(vals),8);

anVsNostim(:,1) = SpkLayAn(:,1);
anVsNostim(:,2) = SpkLayNS(:,1);
anVsNostim(:,3) = SpkLayAn(:,2);
anVsNostim(:,4) = SpkLayNS(:,2);
anVsNostim(:,5) = SpkLayAn(:,3);
anVsNostim(:,6) = SpkLayNS(:,3);
anVsNostim(:,7) = SpkLayAn(:,4);
anVsNostim(:,8) = SpkLayNS(:,4);

% get it in the form of seed x layer, with the layer order being anodal
% 2/3, no stim 2/3, anodal 4, no stim 4, anodal 5...etc.
figure
kruskalwallis(anVsNostim)

cthVsNostim = zeros(length(vals),8);

cthVsNostim(:,1) = SpkLayCth(:,1);
cthVsNostim(:,2) = SpkLayNS(:,1);
cthVsNostim(:,3) = SpkLayCth(:,2);
cthVsNostim(:,4) = SpkLayNS(:,2);
cthVsNostim(:,5) = SpkLayCth(:,3);
cthVsNostim(:,6) = SpkLayNS(:,3);
cthVsNostim(:,7) = SpkLayCth(:,4);
cthVsNostim(:,8) = SpkLayNS(:,4);

figure
kruskalwallis(cthVsNostim)


%% subplot version


subplot(4,1,1)
boxplot([anVsNostim(:,1),anVsNostim(:,2)])
subplot(4,1,2)
boxplot([anVsNostim(:,3),anVsNostim(:,4)])
subplot(4,1,3)
boxplot([anVsNostim(:,5),anVsNostim(:,6)])
subplot(4,1,4)
boxplot([anVsNostim(:,7),anVsNostim(:,8)])
%% hists of spike changes

spkDiffsAn = sum(SpkLayAn,2) - sum(SpkLayNS,2);

spkDiffsCth = sum(SpkLayCth,2) - sum(SpkLayNS,2);
    
figure
hist(spkDiffsAn)
figure
hist(spkDiffsCth)
% frequency/amplitude plot


% single seed plots:
%% layer-wise LFP

for i=1:length(vals)
        sd=vals(i)

%compareLFPbyLayer([cathodal_noise_ordered(sd),nostim_noise_ordered(sd)])

compareLFPbyLayer([anodal_noise_ordered(sd),nostim_noise_ordered(sd)])

%compareLFPbyLayer([sideside_noise_ordered(sd),nostim_noise_ordered(sd)])

end

%% freq/amp plots



%spike counts
figure
subplot(2,1,1)
plotSpikeCounts(nostim_noise_ordered(6))
subplot(2,1,2)
plotSpikeCounts(cathodal_noise_ordered(6))


%%

for i=1:length(vals)
        v=vals(i)

     [PopSpksAn(i,:)] = findSpikesByPopAndLayer(anodal_noise_ordered(v));
     [PopSpksCath(i,:)] = findSpikesByPopAndLayer(cathodal_noise_ordered(v));
     [PopSpksNS(i,:)] = findSpikesByPopAndLayer(nostim_noise_ordered(v));
     
end

PopSpkDiffAn = PopSpksAn - PopSpksNS;

PopSpkDiffCth = PopSpksCath - PopSpksNS;

inh = [2 3 7 8 11 12 15]+1;
exc = [1 4 5 6 9 10 13 14]+1;

%%
InhibSpksDiffAn = PopSpkDiffAn(:,inh);
InhibSpksDiffCth = PopSpkDiffCth(:,inh);

InhibSpksAn = PopSpksAn(:,inh);
InhibSpksCath= PopSpksCath(:,inh);
InhibSpksNS= PopSpksNS(:,inh);

ExcSpksDiffAn = PopSpkDiffAn(:,exc);
ExcSpksDiffCth = PopSpkDiffCth(:,exc);

ExcSpksAn = PopSpksAn(:,exc);
ExcSpksCath= PopSpksCath(:,exc);
ExcSpksNS= PopSpksNS(:,exc);
%%

fsamp = nostim_noise_ordered(6).params.RecordingSettings.sampleRate;
psamp = 1/fsamp;
L = length(nostim_noise_ordered(6).LFP);
t = (0:L-1)*psamp;


for i = 1:length(vals)
    v=vals(i)

    xns(i,:)= mean(nostim_noise_ordered(v).LFP(:,500:end));
    xan(i,:)= mean(anodal_noise_ordered(v).LFP(:,500:end)); 
    xcth(i,:)= mean(cathodal_noise_ordered(v).LFP(:,500:end));

    Yns(i,:) = fft(xns(i,:));
    Yan(i,:) = fft(xan(i,:));
    Ycth(i,:)= fft(xcth(i,:));
    
    P2ns(i,:) = abs(Yns(i,:)/L); % two sided spectrum
    P2an(i,:) = abs(Yan(i,:)/L); % two sided spectrum
    P2cth(i,:) = abs(Ycth(i,:)/L); % two sided spectrum
    P1ns(i,:) = P2ns(1:L/2+1); % single sided spectrum
    P1ns(i,2:end-1) = 2*P1ns(i,2:end-1);
    P1an(i,:) = P2an(i,1:L/2+1); % single sided spectrum
    P1an(i,2:end-1) = 2*P1an(i,2:end-1);
    P1cth(i,:) = P2cth(i,1:L/2+1); % single sided spectrum
    P1cth(i,2:end-1) = 2*P1cth(i,2:end-1);
    
    
end
%%

meanxns = mean(xns);
meanxan = mean(xan);
meanxcth = mean(xcth);


Ynsm = fft(meanxns);
Yanm = fft(meanxan);
Ycthm = fft(meanxcth);


P2nsm = abs(Ynsm/L); % two sided spectrum
P1nsm = P2nsm(1:L/2+1); % single sided spectrum
P1nsm(2:end-1) = 2*P1nsm(2:end-1);


P2anm = abs(Yanm/L); % two sided spectrum
P1anm = P2anm(1:L/2+1); % single sided spectrum
P1anm(2:end-1) = 2*P1anm(2:end-1);


P2cthm = abs(Ycthm/L); % two sided spectrum
P1cthm = P2cthm(1:L/2+1); % single sided spectrum
P1cthm(2:end-1) = 2*P1cthm(2:end-1);


ff = fsamp*(0:(L/2))/L;
figure
plot(ff,P1nsm)
hold on
plot(ff,P1cthm)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
xlim([0.2 10])

%%

figure
plot(ff,P1ns(1,:))
hold on
plot(ff,P1ns(2,:))
plot(ff,P1ns(3,:))
plot(ff,P1ns(4,:))
plot(ff,P1ns(5,:))
plot(ff,P1ns(6,:))
plot(ff,P1ns(7,:))
plot(ff,P1ns(8,:))
plot(ff,P1ns(9,:))
plot(ff,P1ns(10,:))
plot(ff,P1ns(11,:))
plot(ff,P1ns(12,:))
plot(ff,P1ns(13,:))
plot(ff,P1ns(14,:))
plot(ff,P1ns(15,:))
plot(ff,P1ns(16,:))
plot(ff,P1ns(17,:))
plot(ff,P1ns(18,:))
plot(ff,P1ns(19,:))
plot(ff,P1ns(20,:))
plot(ff,P1ns(21,:))
plot(ff,P1ns(22,:))

%%
for i = 1:length(vals)
    v=vals(i)

    figure
    imagesc(nostim_noise_ordered(v).LFP)
    
    
end

%%

kruskalwallis(PopSpkDiffAn)

kruskalwallis(PopSpkDiffCth)

%%

for i = 1:length(vals)
    v=vals(i)

    figure
    plot(mean(anodal_noise_ordered(v).LFP))
    hold on
    plot(mean(nostim_noise_ordered(v).LFP))
    xlim([10000 20000])
    
    
end


%%

% find the soma vm for different populations


PopBounds = results_nostim_nonoise.params.TissueParams.groupBoundaryIDArr;

PopBounds = PopBounds(2:end);

vms = results_nostim_nonoise.params.RecordingSettings.v_m;

% ok, I want to have a vector which represents which vm is in which pop.
% like, 11112222333444...
Popvm = [];

for i = 1:length(PopBounds)
    Popvm = [Popvm,ones(1,sum(vms<=PopBounds(i)))*i];
    vms(vms<=PopBounds(i))=[];
   
end

inhib_vminds = ismember(Popvm,inh);
excit_vminds = ismember(Popvm,exc);




