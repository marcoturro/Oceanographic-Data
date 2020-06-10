%% This script is a tool to compare the data from GSR and MASEAS

clear
close all

addpath('./toolboxes')
%load GSR data
GSR_ADCP

u_z_GSR = ve;
v_z_GSR = vn;
elevation_GSR = elevation;
time_GSR = (time-time(1))*86400;
dt_GSR = dt;
angle_GSR = angle;
v_GSR = v;
mes_GSR = mes;

clearvars -except u_z_GSR v_z_GSR elevation_GSR time_GSR  dt_GSR angle_GSR  v_GSR mes_GSR 

%load MSEAS data
MSEAS_ADCP

u_z_MSEAS = u_z;
angle_MSEAS = angle;
v_MSEAS = v;
v_z_MSEAS = u_z;
elevation_MSEAS = elevation;
time_MSEAS = totTime;
dt_MSEAS = dt;
mes_MSEAS = mes;

clearvars -except u_z_MSEAS v_z_MSEAS elevation_MSEAS time_MSEAS dt_MSEAS angle_MSEAS v_MSEAS mes_MSEAS u_z_GSR v_z_GSR elevation_GSR time_GSR  dt_GSR angle_GSR  v_GSR mes_GSR 


%%

if max(time_GSR)>max(time_MSEAS)
    [~, id] = min(abs(time_GSR-max(time_MSEAS)));
    val = time_GSR(id)/3600;

else   
    [~, id] = min(abs(time_MSEAS-max(time_GSR)));
    val = time_MSEAS(id)/3600;
    
end
%%

% u_z_GSR = 
% corrcoef(A,B)
%% vel Mag

sens = [ 1 7 8 14]; % [gsr1 gsr2 mseas1 mseas2]
subplot(2,2,1)
ts = v_GSR(:,sens(1));
mm = movmean(ts,30);
plot(time_GSR/3600,ts,'LineWidth',2)
hold on
plot(time_GSR/3600,mm,'LineWidth',2)
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
title('30 m off the sea bed')
xlim([0 val])

subplot(2,2,3)
ts = v_MSEAS(:,sens(3));
mm = movmean(ts,30);
plot(time_MSEAS/3600,ts,'LineWidth',2)
hold on
plot(time_MSEAS/3600,mm,'LineWidth',2)
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
xlim([0 val])

subplot(2,2,2)
ts = v_GSR(:,sens(2));
mm = movmean(ts,30);
plot(time_GSR/3600,ts,'LineWidth',2)
hold on
plot(time_GSR/3600,mm,'LineWidth',2)
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
title('70 m off the sea bed')
xlim([0 val])

subplot(2,2,4)
ts = v_MSEAS(:,sens(4));
mm = movmean(ts,30);
plot(time_MSEAS/3600,ts,'LineWidth',2)
hold on
plot(time_MSEAS/3600,mm,'LineWidth',2)
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
xlim([0 val])

%%%%%%% quivers %%%%%%%

figure

subplot(2,2,1)
quiver(time_GSR/3600,zeros(mes_GSR,1)',u_z_GSR(sens(1),:),v_z_GSR(sens(1),:),'k');
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
title('30 m off the sea bed')
xlim([0 val])

subplot(2,2,3)
quiver(time_MSEAS/3600,zeros(mes_MSEAS,1)',u_z_MSEAS(sens(3),:),v_z_MSEAS(sens(3),:),'k');
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
xlim([0 val])

subplot(2,2,2)
quiver(time_GSR/3600,zeros(mes_GSR,1)',u_z_GSR(sens(2),:),v_z_GSR(sens(2),:),'k');
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
title('70 m off the sea bed')
xlim([0 val])

subplot(2,2,4)
quiver(time_MSEAS/3600,zeros(mes_MSEAS,1)',u_z_MSEAS(sens(4),:),v_z_MSEAS(sens(4),:),'k');
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
xlim([0 val])


