%frequency estimate plot

function [mainfreq,Pxx,f,P1,ff] = freqestLFP(Results)

fsamp = Results.params.RecordingSettings.sampleRate;
psamp = 1/fsamp;
x= mean(Results.LFP(:,500:end));
L = length(x);
t = (0:L-1)*psamp;

Y = fft(x);

P2 = abs(Y/L); % two sided spectrum
P1 = P2(1:L/2+1); % single sided spectrum
P1(2:end-1) = 2*P1(2:end-1);
ff = fsamp*(0:(L/2))/L;
figure
plot(ff,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

Nfft = 1024;
if size(Results.LFP,2)<Nfft
    Nfft = floor(size(Results.LFP,2)/4);
end
[Pxx,f] = pwelch(x,gausswin(Nfft),Nfft/2,Nfft,fsamp);
figure
plot(f(2:end),Pxx(2:end));
ylabel('PSD'); xlabel('Frequency (Hz)');
grid on
[~,loc] = max(Pxx(5:end));
ftrim=f(2:end);
ftrim(loc);

mainfreq = ftrim(loc);
title(['Frequency estimate = ',num2str(mainfreq),' Hz']);


end