%frequency estimate plot

function mainfreq = freqestLFP(Results)

fsamp = Results.params.RecordingSettings.sampleRate;
x= mean(Results.LFP(:,500:end));
Nfft = 1024;
if size(Results.LFP,2)<Nfft
    Nfft = floor(size(Results.LFP,2)/4);
end
[Pxx,f] = pwelch(x,gausswin(Nfft),Nfft/2,Nfft,fsamp);
plot(f(5:end),Pxx(5:end));
ylabel('PSD'); xlabel('Frequency (Hz)');
grid on
[~,loc] = max(Pxx(5:end));
ftrim=f(5:end);
ftrim(loc)

mainfreq = ftrim(loc);
title(['Frequency estimate = ',num2str(mainfreq),' Hz']);

end