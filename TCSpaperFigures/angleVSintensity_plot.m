
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
    lfpdiffAn(i,:,:)=anodal_noiseOrdered(v).LFP-nostim_noiseOrdered(v).LFP;
    lfpdiffCath(i,:,:)=cathodal_noiseOrdered(v).LFP-nostim_noiseOrdered(v).LFP;
    
end

%%
colmax = max(abs(lfpmeandiv(:)));
anglesDeg = [0 45 90 135 180];
figure
imagesc(intensities,angles,lfpmeandiv)
caxis([-colmax colmax])

%lfpmeanmod=[mean(lfpmod_a0i05),mean(lfpmod_a0i1),mean(lfpmod_a0i2),mean(lfpmod_a0i3),mean(lfpmod_a0i4),mean(lfpmod_a0_7i05),mean(lfpmod_a0_7i1),mean(lfpmod_a0_7i2),mean(lfpmod_a0_7i3),mean(lfpmod_a0_7i4),mean(lfpmod_a1_5i05),mean(lfpmod_a1_5i1),mean(lfpmod_a1_5i2),mean(lfpmod_a1_5i3),mean(lfpmod_a1_5i4),mean(lfpmod_a2_3i05),mean(lfpmod_a2_3i1),mean(lfpmod_a2_3i2),mean(lfpmod_a2_3i3),mean(lfpmod_a2_3i4),mean(lfpmod_a3_1i05),mean(lfpmod_a3_1i1),mean(lfpmod_a3_1i2),mean(lfpmod_a3_1i3),mean(lfpmod_a3_1i4)]
