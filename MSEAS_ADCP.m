

[file,path] = uigetfile;
selectedfile = fullfile(path,file);
load(selectedfile)

%% this first section aims at obtaining the time step of the recordings

D.first = datetime(datevec(dat.time(1)));
D.last = datetime(datevec(dat.time(end)));

elevation = dat.z;
mes = length(dat.u(1,:));
nb_of_sensors = length(elevation);

dt = 2*3600;

[v, thetha] = cart2pol(dat.u,dat.v);
v = v'/100;
thetha = wrapToPi(thetha);
thetha = unwrap(thetha);
thetha = thetha';
angle = thetha;

v(isnan(v))=0; thetha(isnan(thetha))=0;
sensor = '';

clear path selectedfile id thetha stp