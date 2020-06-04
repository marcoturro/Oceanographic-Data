clear 
close all
tic

data ='MSEAS';

switch data
    case 'BGR'
        run ./ToolBoxes/BGR_ADCP
    case 'GSR'
        run ./ToolBoxes/GSR_ADCP
    case 'MSEAS'
        run ./ToolBoxes/MSEAS_ADCP
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
tmp = unwrap(tmp,[pi]);
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
