


[file,path] = uigetfile;
selectedfile = fullfile(path,file);
load(selectedfile)

%% this first section aims at obtaining the time step of the recordings

D.first = datetime(datevec(dat.t(1)));
D.last = datetime(datevec(dat.t(end)));

u_z = reshape(dat.uvslice(:,dat.lon_i_id,:),[length(dat.zout),length(dat.t)]);
v_z = reshape(dat.vvslice(:,dat.lon_i_id,:),[length(dat.zout),length(dat.t)]);
% the top value is the lowest elevation

elevation = dat.z;

mes = length(u_z(1,:));
nb_of_sensors = length(elevation);

dt = ceil((dat.t(2)-dat.t(1))*24)*3600;
totTime = dt * (1:length(dat.t));

   %%%%%%% ---- %%%%%%%

[thetha,v] = cart2pol(u_z,v_z);
v = v'/100;
thetha = wrapToPi(thetha);
thetha = unwrap(thetha)';
angle = thetha;

v(isnan(v))=0; thetha(isnan(thetha))=0;
sensor = '';

days = round(dt*mes/60/60/24);

clear path selectedfile id thetha stp