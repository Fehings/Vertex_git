function [pshift] = phaseShiftLFPcompare(Results1,Results2,start,finish)
% a function to find a phase shift between two sets of results. NB: the 
% first two outputs will only be relevant if there is one major frequency
% in the signals being compared, for more complex signals with multiple 
% contributing frequencies this may not be the best function to use, as it
% will just capture the lag between the most powerful frequencies in the 
% two signals.
% The third output is the phase shift for each frequency inthe two signals.


if exist('start')
else
    start = 1;
end

if exist('finish')
else
    finish = length(Results1);
end

% if exist('minPeakDist')    
% else
     minPeakDist = 30;
%end

elecLay1 = findElectrodeLayers(Results1);
elecLay2 = findElectrodeLayers(Results2);

numL=max(elecLay1);
numL2=max(elecLay2);

if numL~=numL2
    msg='Error: the two results have a different number of layers.' ;   
    error(msg);
end


sigMean1fft = fft(mean(Results1.LFP));
sigMean2fft = fft(mean(Results2.LFP));

sigMean1fft=sigMean1fft(2:end);
sigMean2fft=sigMean2fft(2:end);



if length(sigMean1fft)>length(sigMean2fft)
    sigMean1fft = sigMean1fft(1:length(sigMean2fft));
elseif length(sigMean1fft)<length(sigMean2fft)
    sigMean2fft = sigMean2fft(1:length(sigMean1fft));
end

[~, maxpt1] = max(abs(sigMean1fft));
[~, maxpt2] = max(abs(sigMean2fft));

pshift.pShiftAv = angle(sigMean1fft(maxpt1)) - angle(sigMean2fft(maxpt2));
pshift.pShiftAllfreqs = angle(sigMean1fft) - angle(sigMean2fft);


layerMeans1=zeros(numL,length(Results1.LFP(1,start:finish)));
layerMeans2=zeros(numL,length(Results2.LFP(1,start:finish)));

time1=0:Results1.params.SimulationSettings.timeStep:Results1.params.SimulationSettings.simulationTime;
time2=0:Results2.params.SimulationSettings.timeStep:Results2.params.SimulationSettings.simulationTime;


for i=1:numL
    
   layerMeans1(i,:)=mean(Results1.LFP(elecLay1==i,start:finish));
   layerMeans2(i,:)=mean(Results2.LFP(elecLay2==i,start:finish));
   pshift.pShiftApprox(i,:)=acos(dot(layerMeans1(i,:),layerMeans2(i,:))/(norm(layerMeans1(i,:)*norm(layerMeans2(i,:))))); 
   % NB: this is based on https://dsp.stackexchange.com/questions/41291/calculating-the-phase-shift-between-two-signals-based-on-samples
   
   [crosscorr,lags] = xcorr(layerMeans1(i,:),layerMeans2(i,:));
   [~,I]=max(abs(crosscorr));
   pshift.xcorlag=lags(I);
   
   
   
   x=fft(layerMeans1(i,:));
   y=fft(layerMeans2(i,:));
   
   X(i,:) = x(2:end);
   Y(i,:) = y(2:end);
   
    twosidedX=abs(X(i,:)/length(layerMeans1));
    twosidedY=abs(Y(i,:)/length(layerMeans2));
    
   
%    
    OnesidedX = twosidedX(1:min(length(layerMeans1)/2+1));
    OnesidedY = twosidedY(1:min(length(layerMeans2)/2+1));
 %plot(OnesidedX)
 %hold on
 %plot(OnesidedY)
   % need to find the points at which the oscillations switch from
   % increasing to decreasing, using find peaks for this, but plotting them
   % first to show that the peaks are 
   % findpeaks(layerMeans1(i,:),'MinPeakDistance',minPeakDist)
   % findpeaks(layerMeans2(i,:),'MinPeakDistance',minPeakDist)
%    
    [~, pts1] = findpeaks(layerMeans1(i,:),'MinPeakDistance',minPeakDist);
    [~, pts2] = findpeaks(layerMeans2(i,:),'MinPeakDistance',minPeakDist);
    
    diffs1=diff(time1(pts1));
    diffs2=diff(time2(pts2));
    
    %std(diffs1)
    %std(diffs2)
    
    Fs1=1/mean(diffs1);
    Fs2=1/mean(diffs2);
    
    if abs(Fs1-Fs2) < 0.01 %check if the two frequencies are similar within a tolerance
        pshift.phaselag(i)= 2*pi*Fs1*(lags(I)/Fs1);
    else
        pshift.phaselag(i) = NaN;
    end
    
   [~, maxptx] = max(abs(X(i,:)));
   [~, maxpty] = max(abs(Y(i,:)));
   % X(i,maxptx)
   % Y(i,maxpty)
%    
   pshift.pShiftLayers(i) = angle(X(i,maxptx)) - angle(Y(i,maxpty)); % find the phase shift at the maximum point of one oscillation cycle for each cycle to get pshift over time

   pshift.pShiftLayers2(i) = phdiffmeasure(layerMeans1(i,:),layerMeans2(i,:));
   
end
   
%also find the phase difference over time. Find it for each oscillation? Find it for the average...


end

