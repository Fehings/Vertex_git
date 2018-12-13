load MayColourMap.mat
w2 = getSparseConnectivityWeights(Results.weights_arr{1}, Results.syn_arr, Results.params.TissueParams.N);
w3 = getSparseConnectivityWeights(Results.weights_arr{4}, Results.syn_arr, Results.params.TissueParams.N);

wd = w3-w2;

total = getGroupWeights(Results.params, wd);
%%
gnames = {'L23PC', 'L23NBC', 'L23LBC', 'L23SBC', 'L23MC', 'L4SS', 'L4SPC', 'L4PC', 'L4NBC', 'L4LBC', 'L4SBC', 'L4MC', 'L5TTPC2', 'L5TTPC1', 'L5UTPC', 'L5STPC', 'L5NBC', 'L5LBC', 'L5SBC', 'L5MC', 'L6TPCL1', 'L6TPCL4', 'L6UPTC', 'L6IPC', 'L6BPC', 'L6NBC', 'L6LBC', 'L6SBC', 'L6MC'};

imagesc(total);
xticks(1:1:29);
yticks(1:1:29);
xticklabels(gnames)
yticklabels(gnames)
xtickangle(90)
set(gca, 'Ydir', 'reverse');
set(gca,'xgrid', 'on','ygrid', 'on');