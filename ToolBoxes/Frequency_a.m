

%% Frequency

% for i = 1:length(A(:,1))
%     T(i,:) = wrapTo2Pi(A(i,:));
% end
% 
% T = -(unwrap(T,[],2)+abs(min(min(T))))/pi*180+90;
% 
% %%
% % tmp = T([2:10,12:end],:);
% % clear T
% % T = tmp + 360;
% % I = I{[2:10,12:end],:};
% %%
% Tm = movmean(sum(T,1)/length(T(:,1)),mes/200);
% 
% % if mean( mean(Tm) - Tm ) < 1
% %     T(T<mean(Tm)) = T(T<mean(Tm)) + mean(Tm);
% %     Tm = movmean(sum(T,1)/length(T(:,1)),mes/200);
% % end
% 
% yl = [0 450];
% figure('units','normalized','OuterPosition',[0 0 1 0.5])
% ylim(yl)
% hold on
% grid on
% xlabel('ocurrence') ; ylabel('angle [deg]')
% title(['Plume measurement at 1km - ' file(1:end-4)], 'Interpreter', 'none')
% set(gca,'FontSize',14)
% 
% for i = 1:length(T(:,1))
% y = T(i,:);
% p = plot(I(i).id,y)
% p.Color(4) = 0.5;
% end
% 
% plot(Tm,'LineWidth',2,'Color','r')
% % 
%% Frequency analysis
%fs = 1/dt;
%
% NFFT = length(y);
% Y = fft(y,NFFT);
% F = ((0:1/NFFT:1-1/NFFT)*fs).';
% magnitudeY = abs(Y);        % Magnitude of the FFT
% phaseY = unwrap(angle(Y));  % Phase of the FFT
% 
% dB_mag=mag2db(magnitudeY);
% subplot(2,1,1);plot(F(1:NFFT/2),dB_mag(1:NFFT/2));title('Magnitude response of signal');
% ylabel('Magnitude(dB)');
% subplot(2,1,2);plot(F(1:NFFT/2),phaseY(1:NFFT/2));title('Phase response of signal');
% xlabel('Frequency in kHz')
% ylabel('radians');
% 
% %lp stands for low pass filter
% Ylp = Y;
% Ylp(F>=1000 & F<=Fs-1000) = 0;
% 
% 
% %% -- autocorrelation
% 
% t = (0:length(y) - 1)/fs;
% days = 20;
% norm = y - mean(y);
% [autocor,lags] = xcorr(norm,ceil(3600*24/dt*days*fs),'coeff');
% 
% plot(lags/fs,autocor)
% xlabel('Lag (days)')
% ylabel('Autocorrelation')
% axis([-21 21 -0.4 1.1])
