clear 
close all

TeleDynADCP

%% Here we set the parameters for advection and advect the tracers
% and plot it
day_r = 4; % on how many days are the particles advected

days = round(dt*mes/60/60/24);
nb_of_realeases = floor(days/day_r); 
stp = 1+fix(1800/dt);          %set the time step to a minimum of 30mins
partition = day_r/dt*60*60*24; % subdivide the time 
n = floor(sqrt(nb_of_sensors));
r = 1000;

disp(['nb sensors: ' num2str(nb_of_sensors) ', release every ' ...
    num2str(day_r) ' days, measurement time [days]: ' num2str(days)])

figure('units', 'normalized', 'outerposition', [0 0 1 1])

for j = 1:nb_of_sensors
cnt = 1;
s = subplot(n,n,j);
hold on
plot(r*cos(0:0.1:2*pi),r*sin(0:0.1:2*pi))
txt = '0';
text(r*cos(pi/2),r*sin(pi/2),txt)
txt = '90';
text(r*cos(0),r*sin(0),txt)
txt = '180';
text(r*cos(3/2*pi),r*sin(3/2*pi),txt)
txt = '270';
text(r*cos(pi),r*sin(pi),txt)

for k = 1:nb_of_realeases
k = k-1;
x = zeros(nb_of_sensors,1) ; y = zeros(nb_of_sensors,1);

for i = 2:stp:partition
    angle = (360-thetha(i,j)+90)/360*(2*pi);
    try
        x(j) = x(j) + v((i+partition*k),j)*cos(angle)*dt*stp;
        y(j) = y(j) + v((i+partition*k),j)*sin(angle)*dt*stp;
    catch
        disp('there was an error, moving on')
    end
    
    th = atan(y(j)/x(j));
    dist = sqrt(x(j)^2+y(j)^2);
    if 900 < dist && 1100>dist
        
        X(j,cnt) = x(j); % cnt is to save the values which hit
        Y(j,cnt) = y(j); % the condition of 1km
        
        scatter(r*cos(th),r*sin(th))
        xlabel('W - E [m]'); ylabel('S - N [m]');
        title(['sensor n ' num2str(j) ' , ' num2str(altitude(j)) ' [m]'])
        xlim([-1200 1200])
        ylim([-1200 1200])
        
        cnt = cnt+1;
    end
end
end
if cnt == 1
    delete(s)
end
    
end