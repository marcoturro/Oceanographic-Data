close all
clear
set = 'GSR'
mooringnb = '1'
load(['../' set '_Area/FieldData/Moorings/MOR00' mooringnb '/data/MOR00' mooringnb '_merged_adcps_QA.mat'])

time = (time - time(1))*24*3600;

Fs = 1/max(diff(time)); %measurement frequency Hz
for k = 1:13
sig = ve(k,:);
          % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length(sig);      % Length of signal
t = (0:L-1)*T;        % Time vector

Y = fft(sig);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,wdenoise(P1))
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%%%%%%%%%%%%% Wavelet 2 %%%%%%%%%%%%%


fb = cwtfilterbank('SignalLength',length(sig),...
    'SamplingFrequency',Fs,...
    'VoicesPerOctave',12);

[cfs,frq] = wt(fb,sig);
figure;pcolor(time,frq,abs(cfs));
shading interp;axis tight;
title('Scalogram');xlabel('Time (s)');ylabel('Frequency (Hz)')

figure

coefs = cwt(sig);
wscalogram('image',coefs,'ydata',sig);
end