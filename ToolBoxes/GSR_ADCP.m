
[file,path] = uigetfile;
selectedfile = fullfile(path,file);
load(selectedfile)

%%

D.first = datetime(datevec(time(1)));
D.last = datetime(datevec(time(end)));

elevation = flip(elevation)';
ve = flip(ve,1)/100;
vn = flip(vn,1)/100;
vv = flip(vv,1)/100;
[thetha, v] = cart2pol(ve,vn);
thetha = thetha';
v = v';
v(isnan(v)) = 0;
thetha(isnan(thetha)) = 0;

mes = length(temperature);
nb_of_sensors = length(elevation);

for i = 1:nb_of_sensors
    prb = 0;
    for j = 1:mes
        if isnan(ve(i,j))
            prb = 1;
        end
    end
    if prb == 1
        sprintf(['sensor n ' num2str(i) ' has a problem'])
        problematicSens = i;
    end
end

mdt = min(diff(time*24*3600));
Mdt = max(diff(time*24*3600));

if mdt - Mdt > 10^(-3)
   error('the time step is not constant')
else
    dt = mdt;
end

angle = thetha;

sensor = file(1:6);

clear path selectedfile id thetha stp