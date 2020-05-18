clear 
close all
tic

data ='MSEAS';

switch data
    case 'BGR'
        BGR_ADCP
    case 'GSR'
        GSR_ADCP
    case 'MSEAS'
        MSEAS_ADCP
end
         
%%
% Here we set the parameters for advection and advect the tracers
% and plot it

plt = 1;

day_r = 2; % on how many days are the particles advected
i_adv = floor(day_r*86400/dt);
days = floor(dt*mes/86400);
i_seg = 1+fix(3600/dt);
nb_of_realeases = (mes-i_adv)/i_seg;

stp = 1;

n = ceil(sqrt(nb_of_sensors));
seg = floor((mes-i_adv)/nb_of_realeases);
time = dt*stp;

r = 1000;
x = zeros(nb_of_sensors,1) ; y = zeros(nb_of_sensors,1);

disp(['nb sensors: ' num2str(nb_of_sensors) ', release every ' ...
    num2str(day_r) ' days, measurement time [days]: ' num2str(days)])

if plt == 1
figure('units', 'normalized', 'outerposition', [0 0 1 1])
end
jj = 0;

for j = 1:nb_of_sensors
cnt = 1;

% % % % % % % % % % % PLOT % % % % % % % % % % %

disp([num2str(j) ' sensor out of ' num2str(nb_of_sensors)])

if plt == 1
s = subplot(n,n,j);
xlabel('W - E [m]'); ylabel('S - N [m]');
title(['sensor n ' num2str(j) ' , ' num2str(elevation(j)) ' [m]'])
xlim([-1200 1200])
ylim([-1200 1200])

hold on
plot(r*cos(0:0.1:2*pi),r*sin(0:0.1:2*pi),'--')
txt = '0';
text(r*cos(pi/2),r*sin(pi/2),txt)
txt = '90';
text(r*cos(0),r*sin(0),txt)
txt = '180';
text(r*cos(3/2*pi),r*sin(3/2*pi),txt)
txt = '270';
text(r*cos(pi),r*sin(pi),txt)
end

% % % % % % % % % % % PLOT % % % % % % % % % % %

for k = 0:nb_of_realeases-1

x(j) = 0; y(j) = 0;
N = seg*k;

for i = 2:stp:i_adv
    jj = jj+1;
    
    try
        
        x(j) = x(j) + v((i+N),j)*cos(angle((i+N),j))*time;
        y(j) = y(j) + v((i+N),j)*sin(angle((i+N),j))*time;
        
    catch
        
        disp('there was an error, moving on')
        disp([num2str(k) ' ' num2str(j) ' ' num2str(i)])
        
    end
    
    dist = sqrt(x(j)^2+y(j)^2);
    
    if 1000 < dist
        
        % aa(k+1,cnt) = wrapTo2Pi(angle((i+N),j));
        aa(k+1,cnt) = angle((i+N),j);
        V(j,cnt) = v((i+N),j);
        X(j,cnt) = x(j); % cnt is to save the values which hit
        Y(j,cnt) = y(j); % the condition of 1km
        ii(k+1,cnt) = i+N;
        tmpx(jj) = i;
        
        if plt == 1
            scatter(x(j),y(j))
        end
        
        cnt = cnt+1;
        
        break
    end
end
           
end

if cnt == 1 && plt ==1
    delete(s)
end

I(j).id = ii;

tmp = diag(aa);
% tmp = unwrap(tmp,[pi]);
aa = diag(tmp);

A(j).id = aa;
end
toc



%% create an histogram of the particles reaching 1km
%figure
%hold on

mx = max(tmpx);
x = []; y = [];
dt = dt/60/60;

for j=1:nb_of_sensors
    for i = 1:nb_of_realeases
        try
        x(j,i) = dt*(I(j).id(i,i)-i*seg);
        y(j,i) = -A(j).id(i,i)/pi*180+90;
        catch
        end
    end
%     c = (1 + 5*j)*ones(length(x),1);
%     scatter(x(j,:),y(j,:),[],c)
end


% 
% ylim([-400 400])
% xlim([0 mx*dt])



figure
 
g = [];
for i = 1:nb_of_sensors
    g = [g i*ones(length(x),1)];
end
        
gscatter(reshape(x.',1,[]),reshape(y.',1,[]),reshape(g'.',1,[]),[],[],10)
ylim([- 400 400])
xlim([0 mx*dt])
xlabel('time [h]'); ylabel('angle [deg], North = 0')

set(gca,'FontSize',14)


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
