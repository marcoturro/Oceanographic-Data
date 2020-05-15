clear 
close all
tic

data ='BGR';

switch data
    case 'BGR'
        BGR_ADCP
    case 'GSR'
        GSR_ADCP
    case 'some'
end
         
%%
% Here we set the parameters for advection and advect the tracers
% and plot it
plr = 1;

day_r = 1; % on how many days are the particles advected
i_adv = floor(day_r*24*60*60/dt);
days = round(dt*mes/60/60/24);
nb_of_realeases = days*24; %every 1h
stp = 1+fix(1800/dt); %set the time step to a minimum of 30mins
% stp = 1;
seg = floor(mes/nb_of_realeases);
time = dt*stp;

nb_of_sensors = 10
thethaM = movmean(thetha,5,1);
%thetha = thethaM
r = 1000;
x = zeros(nb_of_sensors,i_adv) ; y = zeros(nb_of_sensors,i_adv);
angle = - thetha/180*pi + pi/2;

disp(['nb sensors: ' num2str(nb_of_sensors) ', release every ' ...
    num2str(day_r) ' days, measurement time [days]: ' num2str(days)])

if plr == 1
figure('units', 'normalized', 'outerposition', [0 0 1 1])
hold on
end


for j = 1:nb_of_sensors %sensor

    for i = 2:stp:i_adv

        x(j,cnt) = x(j,i-1) + v((i),j)*cos(angle((i),j))*time;
        y(j,cnt) = y(j,i-1) + v((i),j)*sin(angle((i),j))*time;

    end
 
    plot(x(j,:),y(j,:),'LineWidth',3)
    legendCell = cellstr(num2str(elevation(1:j)', 'N=%.1f'));
    legend(legendCell)
    set(gca,'FontSize',18)
end

title(file,'Interpreter','None')

%%          
toc

