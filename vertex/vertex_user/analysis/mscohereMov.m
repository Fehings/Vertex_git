
figure
colorbar
caxis([0,1]);

for i=1:size(magsqCohereSlowNo,3)
    %imagesc(magsqCohereSlow4mv(:,:,i)-magsqCohereSlowNo(:,:,i))
    imagesc(magsqCohereSlowNo(:,:,i))
    colorbar
    caxis([0,1]);
    slowFno(i)=getframe;
end

close all
