clear 
close all

[file,path] = uigetfile;
selectedfile = fullfile(path,file);
load(selectedfile)

%% this first section aims at obtaining the time step of the recordings

altitude = 1-(Data.depth-Data.depth(1));
mes = length(Data.dat(:,1));
nb_of_sensors = length(altitude);

dt = [diff(Data.dat(:,6)) , diff(Data.dat(:,5)) , diff(Data.dat(:,4)) ...
            , diff(Data.dat(:,3)) , diff(Data.dat(:,2))];

dt(dt<=0) = nan;

for i = 1:5
    try
           ts(i) = dt(find(~isnan(dt(:,i)), 1),i);
    catch
           ts(i) = 0;
    end
end

id = find(ts,1);
t(1) = 0;
stp = [1 60 60^2 60^2*24];
clear dt
dt = ts(id)*stp(id);

for i=2:mes
    t(i) = t(i-1) + dt;
end

for i=1:nb_of_sensors
v(:,i) = Data.dat(:,6+i)/1000;
end

for i=1:nb_of_sensors
thetha(:,i) = Data.dat(:,6+nb_of_sensors+i);
end

v(isnan(v))=0; thetha(isnan(thetha))=0;

%% Here we set the parameters for advection and advect the tracers

day_r = 4; % on how many days are the particles advected

days = round(dt*mes/60/60/24);
nb_of_realeases = floor(days/day_r); 
stp = 1+fix(1800/dt);          %set the time step to a minimum of 30mins
partition = day_r/dt*60*60*24; % subdivide the time 
n = floor(sqrt(nb_of_sensors));

disp(['nb sensors: ' num2str(nb_of_sensors) ', release every ' ...
    num2str(day_r) ' days, measurement time [days]: ' num2str(days)])

figure('Renderer', 'painters', 'Position', [500 500 500 400])

for j = 2:nb_of_sensors
cnt = 1;
subplot(n,n+1,j-1)
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
        Y(j,cnt) = y(j);% the condition of 1km
        
        scatter(1000*cos(th),1000*sin(th))
        xlim([-1200 1200])
        ylim([-1200 1200])
        hold on
        cnt = cnt+1;
    end
end
end
end