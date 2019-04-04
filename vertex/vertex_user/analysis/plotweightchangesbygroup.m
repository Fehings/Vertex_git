
ConnectivityNamesnounderscore = {'L23PC','L23NBC','L23LBC','L23SBC','L23MC',...
    'L4SS','L4SP','L4PC','L4NBC','L4LBC','L4SBC','L4MC',...
    'L5TTPC2','L5TTPC1','L5UTPC','L5STPC','L5NBC','L5LBC','L5SBC','L5MC'...
    'L6TPCL1', 'L6TPCL4', 'L6UTPC','L6IPC','L6BPC', 'L6NBC','L6LBC', 'L6SBC', 'L6MC'};

w2 = getSparseConnectivityWeights(Results.weights_arr{1}, Results.syn_arr, Results.params.TissueParams.N);
w3 = getSparseConnectivityWeights(Results.weights_arr{4}, Results.syn_arr, Results.params.TissueParams.N);
wd = w3-w2;
%%
wchange = sum(wd);
groupwd = getGroupWeights(Results.params, wd);
groupwd(end+1,:) = 0;
groupwd(:,end+1) = 0;
%%
pcolor(groupwd)
set(gca,'YTickLabel',ConnectivityNamesnounderscore)
set(gca,'YTick',[1:30]+0.5)
set(gca,'YTickLabel',ConnectivityNamesnounderscore)
set(gca,'XTick',[1:30]+0.5)
set(gca,'XTickLabel',ConnectivityNamesnounderscore)
set(gca,'XAxisLocation','Top')
%%
xtickangle(45)
xlabel('Presynaptic Group','FontSize', 18)
ylabel('Postsynaptic Group','FontSize', 18)
 c = colorbar;
 colormap(mycmap)
 lims = [min(min(groupwd)), max(max(groupwd))];
 set(gca,'clim',lims);
ylabel(c, 'Change in Synaptic Weight After TBS (nS)','FontSize', 18)
axis image
axis ij