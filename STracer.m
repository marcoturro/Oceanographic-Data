clear 
% close all
tic
addpath('./Toolboxes')
data ='MSEAS';
day_r = 9; % on how many days are the particles advected
day_s = 1; % which day to start on

switch data
    
    case 'BGR'
        BGR_ADCP
    case 'GSR'
        GSR_ADCP
    case 'MSEAS'
        MSEAS_ADCP
end
         
%%
% Here we set the parameters for advection and advect the tracers
% and plot it
plr = 1;
start = floor(day_s*24*60*60/dt);
i_adv = floor(day_r*24*60*60/dt);
stp = 1;

r = 1000;
x = zeros(nb_of_sensors,i_adv) ; y = zeros(nb_of_sensors,i_adv);

disp(['nb sensors: ' num2str(nb_of_sensors) ', advection time ' ...
    num2str(day_r) ' days, measurement time [days]: ' num2str(days)])

if plr == 1
figure('units', 'normalized', 'outerposition', [0 0 1 1])
hold on
end


for j = 1:nb_of_sensors %sensor

    for i = 2:stp:i_adv
        dif = i + start;
        x(j,i) = x(j,i-1) + v(dif,j)*cos(angle(dif,j))*time;
        y(j,i) = y(j,i-1) + v(dif,j)*sin(angle(dif,j))*time;

    end
 
    plot(x(j,:),y(j,:),'LineWidth',3)
    legendCell = cellstr(num2str(elevation(1:j)', 'N=%.1f'));
    legend(legendCell)
    set(gca,'FontSize',18)
end

xlabel('[m]'); ylabel('[m]')
title([data ' ' sensor ' from :' datestr(D.first) ' to: ' datestr(D.last)],'Interpreter','None')
       
toc