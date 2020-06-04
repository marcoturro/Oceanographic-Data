MSEAS_ADCP

thetha = angle
clear angle

%%

% Frequency analysis
fs = 1/dt;
y = v(:,1);
NFFT = length(y);
Y = fft(y,NFFT);
F = ((0:1/NFFT:1-1/NFFT)*fs).';
magnitudeY = abs(Y);        % Magnitude of the FFT
phaseY = unwrap(angle(Y));  % Phase of the FFT

dB_mag=mag2db(magnitudeY);
subplot(2,1,1);plot(F(1:NFFT/2),dB_mag(1:NFFT/2));title('Magnitude response of signal');
ylabel('Magnitude(dB)');
subplot(2,1,2);plot(F(1:NFFT/2),phaseY(1:NFFT/2));title('Phase response of signal');
xlabel('Frequency in kHz')
ylabel('radians');

%lp stands for low pass filter
Ylp = Y;
Ylp(F>=1000 & F<=fs-1000) = 0;


%%

[p,f] = pspectrum(y,fs,'spectrogram');
plot(log([0 1./f(2:end)'/3600]),log(p))
set(gca, 'XDir','reverse')
set(gca,'FontSize',18)
xlabel('Periods [h]')


%% -- autocorrelation

t = (0:length(y) - 1)/fs;
days = 20;
norm = y - mean(y);
[autocor,lags] = xcorr(norm,ceil(3600*24/dt*days*fs),'coeff');

plot(lags/fs,autocor)
xlabel('Lag (days)')
ylabel('Autocorrelation')
axis([-21 21 -0.4 1.1])
