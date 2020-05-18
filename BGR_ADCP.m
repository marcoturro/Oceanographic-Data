

[file,path] = uigetfile;
selectedfile = fullfile(path,file);
load(selectedfile)

%% this first section aims at obtaining the time step of the recordings

elevation = 6-(Data.depth-Data.depth(1));
mes = length(Data.dat(:,1));
nb_of_sensors = length(elevation);

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
thetha(:,i) = Data.dat(:,6+nb_of_sensors+i); %5414:7366 for oct - nov
end

angle = - thetha/180*pi + pi/2;

v(isnan(v))=0; thetha(isnan(thetha))=0;
