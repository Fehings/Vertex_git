function [amp,layerCorr, magsqCohere] = analyseLFP(Results,time,slide)
% a function to analyse the LFP results, uses findElectrodeLayers,
% outputting different amplitude measurements in a structure as well as
% between layer correlations, using the correlation formula as described in
% Ribeiro et al. 2009, 'Parallel calculation of multi-electrode array
% correlation networks'. This script doesn't calculate for each electrode
% pair correlation, but averages accross layers and calculated the
% correlation between the mean LFP for a given layer with another layer.
% This is done using time windows which default to 1000 time steps if not
% specified, with a sliding window of change 'slide', which defaults to a
% quater of the time window if not otherwise specified.

if exist('time','var')
    t=time;
else
    t=1000;
    if t>length(Results.LFP)
        t=length(Results.LFP);
    end
end
if exist('slide','var')
    k=slide;
else
    k=floor(t/4);
end

grossLFP=mean(Results.LFP);

amp.p2pMean = max(grossLFP)-min(grossLFP);
amp.peakMean = max(abs(grossLFP)); %NB: this is assuming a reference of zero.

RMS = @(x) sqrt(mean(x.^2));



amp.RMSMean = RMS(grossLFP);
% NB: RMS (rootmeansquare amplitude) is probably the best measure to look
% at because it is often used when noise is involved, which in VERTEX it generally is.

elecLay = findElectrodeLayers(Results);

numL=max(elecLay);

for i=1:numL
   
    amp.p2pLayers(:,i) = max(mean(Results.LFP(elecLay==i,:)))-min(mean(Results.LFP(elecLay==i,:)));
    amp.peakLayers(:,i) = max(abs(mean(Results.LFP(elecLay==i,:))));
    amp.RMSlayers(:,i) = RMS(mean(Results.LFP(elecLay==i,:)));

    for ii=1:numL
        magsqCohere(i,ii,:) = mscohere(mean(Results.LFP(elecLay==i,:)),mean(Results.LFP(elecLay==ii,:)));
        % From MATLAB documentation: The magnitude-squared coherence enables you to identify significant frequency-domain correlation between the two time series
    end
    
end

tmin=1;
numWindows=floor((length(Results.LFP)-t)/k);

layerCorr=zeros(numWindows,numL,numL);


for nW = 1:numWindows
    tmax=tmin+t;
    for l=1:numL
        avX=mean(mean(Results.LFP(elecLay==l,:)));
        currX=mean(Results.LFP(elecLay==l,tmin:tmax));
        
        for ll=1:numL
           
            currY=mean(Results.LFP(elecLay==ll,tmin:tmax));
            avY=mean(mean(Results.LFP(elecLay==ll,:)));
            layerCorr(nW,l,ll) = sum((currX-avX).*(currY-avY)) / ...
                sqrt(sum((currX-avX).^2)).*sqrt(sum((currY-avY).^2));
            
            %layerCoherence(nW,l,ll) = 
            %layerPhaseCoherence(nW,l,ll) = 
            %layerAmpCoherence(nW,l,ll) =
        end
        
        %randomPhaseCoherence(nW,l) =
    end
    tmin=tmin+k;
end




end


