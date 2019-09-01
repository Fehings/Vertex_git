%Results = loadResults('~/VERTEX_results_tutorial_2/');
%%
c=[0.000000000000001 0.00000000000001 0.0000000000001 0.000000000001 0.00000000001 0.0000000001 0.000000001 0.00000001 0.0000001 0.000001 0.00001 0.0001 0.001 0.01 0.1 1 10 100 1000 10000 100000 1000000 10000000]./1000000000;
%pars.caxis = [1e-25];
pars.figureID =1;
k = 1;
az = 61.8550;
el = 12.1840;
d = log(Results.DV);
load('cmap.mat')
figure('units','normalized','outerposition',[0 0 1 1], 'visible', 'off')
fg = plotSomaPositionsMembranePotential(Results.params.TissueParams, d(:,1), pars);
colormap(cmap);  
caxis(log([c(1) c(length(c))]));
cm = colorbar('FontSize',11,'YTick',log(c),'YTickLabel',c);
cm.Label.String = 'Protein Concentration';
%%
view(az,el);
an = annotation('textbox', [0.8, 0.45, 0, 0], 'string', ['Time: 1ms']);
for i = 1:5:size(Results.DV,2)
    fg = updateScatterPlot(fg,d(:,i));
    an.String = ['Time: ' num2str(i./Results.params.RecordingSettings.sampleRate) 's'] ;
    %print(fg.Parent.Parent, ['/home/campus.ncl.ac.uk/b3046588/VERTEX_Videos/still' num2str(k) '.png'], '-dpng', '-r150', '-painters');
    k=k+1;
end