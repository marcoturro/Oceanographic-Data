clear 
close all
tic

data ='BGR';

switch data
    case 'BGR'
        TeleDynADCP
    case 'GSR'
        
    case 'some'
end
         
%%
% Here we set the parameters for advection and advect the tracers
% and plot it
plr = 0;

day_r = 2; % on how many days are the particles advected
i_adv = floor(day_r*24*60*60/dt);
days = round(dt*mes/60/60/24);
nb_of_realeases = days*24; %every 1h
% stp = 1+fix(1800/dt); %set the time step to a minimum of 30mins
stp = 1;
n = ceil(sqrt(nb_of_sensors));
seg = floor(mes/nb_of_realeases);
time = dt*stp;

r = 1000;
x = zeros(nb_of_sensors,1) ; y = zeros(nb_of_sensors,1);
angle = - thetha/180*pi + pi/2;

disp(['nb sensors: ' num2str(nb_of_sensors) ', release every ' ...
    num2str(day_r) ' days, measurement time [days]: ' num2str(days)])

if plr == 0
figure('units', 'normalized', 'outerposition', [0 0 1 1])
end

for j = 1:nb_of_sensors
cnt = 1;

disp([num2str(j) ' sensor out of ' num2str(nb_of_sensors)])
s = subplot(n,n,j);

if plr == 1
xlabel('W - E [m]'); ylabel('S - N [m]');
title(['sensor n ' num2str(j) ' , ' num2str(altitude(j)) ' [m]'])
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
for k = 0:nb_of_realeases-1

x(j) = 0; y(j) = 0;
N = seg*k;

for i = 2:stp:i_adv

    try
        x(j) = x(j) + v((i+N),j)*cos(angle((i+N),j))*time;
        y(j) = y(j) + v((i+N),j)*sin(angle((i+N),j))*time;
    catch
        disp('there was an error, moving on')
        disp([num2str(k) ' ' num2str(j) ' ' num2str(i)])
    end
    
    dist = sqrt(x(j)^2+y(j)^2);
    if 1000 < dist
        
        A(j,cnt) = angle((i+N),j);
        V(j,cnt) = v((i+N),j);
        X(j,cnt) = x(j); % cnt is to save the values which hit
        Y(j,cnt) = y(j); % the condition of 1km
        
        %scatter(r*cos(th),r*sin(th))
        if plr == 1
            scatter(x(j),y(j))
        end
        cnt = cnt+1;
        break
    end
end
           
end
if cnt == 1 && plr ==1
    delete(s)
end
    
T = -(A(j,:) - pi/2)/pi*180;
hist(T,100)

end
toc
%% create an histogram of the particles reaching 1km

