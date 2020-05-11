clear 
close all

TeleDynADCP
%%
% Here we set the parameters for advection and advect the tracers
% and plot it
day_r = 4; % on how many days are the particles advected

days = round(dt*mes/60/60/24);
nb_of_realeases = floor(days/day_r); 
stp = 1+fix(1800/dt);          %set the time step to a minimum of 30mins
partition = floor(mes/nb_of_realeases); % subdivide the time 
n = ceil(sqrt(nb_of_sensors));

r = 1000;
x = zeros(nb_of_sensors,1) ; y = zeros(nb_of_sensors,1);
angle = thetha/360*(2*pi) + pi/2;

disp(['nb sensors: ' num2str(nb_of_sensors) ', release every ' ...
    num2str(day_r) ' days, measurement time [days]: ' num2str(days)])

figure('units', 'normalized', 'outerposition', [0 0 1 1])

for j = 1:nb_of_sensors
cnt = 1;

s = subplot(n,n,j);

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

for k = 1:nb_of_realeases
k = k-1;
x(j) = 0; y(j) = 0;
for i = 2:stp:partition

    try
        x(j) = x(j) + v((i+partition*k),j)*(-cos(angle(i,j)))*dt*stp;
        y(j) = y(j) + v((i+partition*k),j)*sin(angle(i,j))*dt*stp;
    catch
        disp('there was an error, moving on')
    end
    
    dist = sqrt(x(j)^2+y(j)^2);
    if 1000 < dist
        
        th = atan(y(j)/x(j));

        X(j,cnt) = x(j); % cnt is to save the values which hit
        Y(j,cnt) = y(j); % the condition of 1km
        
        scatter(r*cos(th),r*sin(th))
        % scatter(x(j),y(j))
        xlabel('W - E [m]'); ylabel('S - N [m]');
        title(['sensor n ' num2str(j) ' , ' num2str(altitude(j)) ' [m]'])
        xlim([-1200 1200])
        ylim([-1200 1200])
        
        cnt = cnt+1;
        break
    end
end
end
if cnt == 1
    delete(s)
end
    
end

%% create an histogram of the particles reaching 1km

figure
th = atan(Y./X);
hist(th(:),100)
xlabel('angle [rad], 0 = E')
xlim([-pi pi])
set(gca,'FontSize',18)