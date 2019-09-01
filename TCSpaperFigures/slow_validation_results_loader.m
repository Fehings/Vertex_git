% script for loading the slow oscillation results from the backup drive.

%Folder = '/Volumes/Seagate Expansion Drive/Uni_Work/Vertex_Results/cvc_slow_validationruns_spring2018/cvc_zerofield'
Folder = '/Users/a6028564/Documents/MATLAB/Vertex_Results/PaperResults_Multiregion';


addpath(genpath(Folder))


fileNames = dir(Folder); % saves it as a struct, wiht fileNames(k).name

%%
names_combined = [];
for i=1:length(fileNames)
        
   names_combined =  [names_combined,fileNames(:).name];

   
end

%nostim = regexp(names_combined,'cvc_slow_20sec_nostim_noiseseed\d*','match');
nostim = regexp(names_combined,'L23_3reg_1-3zero_2-3zero_noiseseed\d*','match');

nostim = unique(nostim);

%%
 
for k=1:length(nostim)%1:length(nostim)
    
    try
        nostim_noise1to30(k,:) = loadResultsMultiregions(nostim{k});
    catch
        nostim{k}
        disp('\n failed, need to check data')
       % nostim_noise1to30(k) = [];
    end
    k
end

%%
FolderA = '/Volumes/Seagate Expansion Drive/Uni_Work/Vertex_Results/cvc_slow_validationruns_spring2018/cvc_anodal';

addpath(genpath(FolderA))

fileStructAnodal = dir(FolderA); % saves it as a struct, wiht fileNames(k).name

names_combined_anodal = [];

for i=1:length(fileStructAnodal)
        
   names_combined_anodal =  [names_combined_anodal,fileStructAnodal(:).name];
   
end
%%


%anodal = regexp(names_combined_anodal,'cvc_slow_20sec_4mvmmAnodalStim_noiseseed\d*','match');
anodal = regexp(names_combined,'L23_3reg_1-3anodal4mv_2-3anodal4mv_noiseseed\d*','match');



anodal = unique(anodal);

for kk=1:length(anodal)
    try
        anodal_noise1to30(kk,:) = loadResultsMultiregions(anodal{kk});
    catch
        anodal{kk}
        disp('\n failed, need to check data')
    end
    kk
end


%%

anodalzero = regexp(names_combined,'L23_3reg_1-3anodal4mv_2-3zero_noiseseed\d*','match');



anodalzero = unique(anodalzero);

for kk=1:length(anodalzero)
    try
        anodalzero_noise1to30(kk,:) = loadResultsMultiregions(anodalzero{kk});
    catch
        anodalzero{kk}
        disp('\n failed, need to check data')
    end
    kk
end

%%


%anodal = regexp(names_combined_anodal,'cvc_slow_20sec_4mvmmAnodalStim_noiseseed\d*','match');
cathodal = regexp(names_combined,'L23_3reg_1-3cathodal4mv_2-3cathodal4mv_noiseseed\d*','match');



cathodal = unique(cathodal);

for kk=1:length(cathodal)
    try
        cathodal_noise1to30(kk,:) = loadResultsMultiregions(cathodal{kk});
    catch
        cathodal{kk}
        disp('\n failed, need to check data')
    end
    kk
end


%%

cathodalzero = regexp(names_combined,'L23_3reg_1-3cathodal4mv_2-3zero_noiseseed\d*','match');



cathodalzero = unique(anodalzero);

for kk=1:length(anodalzero)
    try
        cathodalzero_noise1to30(kk,:) = loadResultsMultiregions(cathodalzero{kk});
    catch
        cathodalzero{kk}
        disp('\n failed, need to check data')
    end
    kk
end



%%

Folder2 = '/Volumes/Seagate Expansion Drive/Uni_Work/Vertex_Results/cvc_slow_validationruns_spring2018/cvc_cathodal';

addpath(genpath(Folder2))

fileStructCath = dir(Folder2); % saves it as a struct, wiht fileNames(k).name

names_combined_cath = [];

for i=1:length(fileStructCath)
        
   names_combined_cath =  [names_combined_cath,fileStructCath(:).name];
   
end

cathodal = regexp(names_combined_cath,'cvc_slow_20sec_4mvmmCathodalStim_noiseseed\d*','match');

cathodal = unique(cathodal);

%%

for kc=1:length(cathodal)
    
    try
        cathodal_noise1to30(kc) = loadResults(cathodal{kc});
    catch
        cathodal{kc}
        disp('\n failed, need to check data')
    end
    kc

end

%%

Folder3 = '/Volumes/Seagate Expansion Drive/Uni_Work/Vertex_Results/cvc_slow_validationruns_spring2018/cvc_sideside';

fileStructSS = dir(Folder3); % saves it as a struct, wiht fileNames(k).name

addpath(genpath(Folder3))

names_combined_ss = [];

for i=1:length(fileStructSS)
        
   names_combined_ss =  [names_combined_ss,fileStructSS(:).name];
   
end

sideside = regexp(names_combined_ss,'cvc_slow_20sec_sidesidestim_noiseseed\d*','match');

sideside = unique(sideside);


for ks=1:length(sideside)
    
sideside_noise1to30(ks) = loadResults(sideside{ks});
disp(ks)

end


%%

% reordering

ordering = [1 10 11 12 13 14 15 16 17 18 19 2 20 21 22 23 24 25 26 27 28 29 3 30 4 5 6 7 8 9];

for i = 1:length(ordering)
    i
    position = find(ordering==i)
    reg3_allzero_noiseOrdered(i,:) = nostim_noise1to30(position,:);
    reg3_allanodal_noiseOrdered(i,:) = anodal_noise1to30(position,:);
    reg3_allcathodal_noiseOrdered(i,:) = cathodal_noise1to30(position,:);
    reg3_anodalzero_noiseOrdered(i,:) = anodalzero_noise1to30(position,:);
    reg3_cathodalzero_noiseOrdered(i,:) = cathodalzero_noise1to30(position,:);

    %sideside_noiseOrdered(i) = sideside_noise1to30(position);
    
    
    
end
    

% sideside_noise_ordered(6) = sideside_noise6to30(22);
% sideside_noise_ordered(7) = sideside_noise6to30(23);
% sideside_noise_ordered(8) = sideside_noise6to30(24);
% sideside_noise_ordered(9) = sideside_noise6to30(25);
% sideside_noise_ordered(10) = sideside_noise6to30(1);
% sideside_noise_ordered(11) = sideside_noise6to30(2);
% sideside_noise_ordered(12) = sideside_noise6to30(3);
% sideside_noise_ordered(13) = sideside_noise6to30(4);
% sideside_noise_ordered(14) = sideside_noise6to30(5);
% sideside_noise_ordered(15) = sideside_noise6to30(6);
% sideside_noise_ordered(16) = sideside_noise6to30(7);
% sideside_noise_ordered(17) = sideside_noise6to30(8);
% sideside_noise_ordered(18) = sideside_noise6to30(9);
% sideside_noise_ordered(19) = sideside_noise6to30(10);
% sideside_noise_ordered(20) = sideside_noise6to30(11);
% sideside_noise_ordered(21) = sideside_noise6to30(12);
% sideside_noise_ordered(22) = sideside_noise6to30(13);
% sideside_noise_ordered(23) = sideside_noise6to30(14);
% sideside_noise_ordered(24) = sideside_noise6to30(15);
% sideside_noise_ordered(25) = sideside_noise6to30(16);
% sideside_noise_ordered(26) = sideside_noise6to30(17);
% sideside_noise_ordered(27) = sideside_noise6to30(18);
% sideside_noise_ordered(28) = sideside_noise6to30(19);
% sideside_noise_ordered(29) = sideside_noise6to30(20);
% sideside_noise_ordered(30) = sideside_noise6to30(21);
% 
%      