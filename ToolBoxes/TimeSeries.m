%%

subplot(3,1,1)
ts = v(:,1)*100;
mm = movmean(ts,30);
plot(ts,'LineWidth',2)
hold on
plot(mm,'LineWidth',2)
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
title('Magnitude of current, 4500m depth - Normal Conditions')

subplot(3,1,2)
ts = v(:,2)*100;
mm = movmean(ts,30);
plot(ts,'LineWidth',2)
hold on
plot(mm,'LineWidth',2)
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
title('Magnitude of current, 3500m depth - Normal Conditions')
ylabel('v [mm/s]')

subplot(3,1,3)
ts = v(:,3)*100;
mm = movmean(ts,30);
plot(ts,'LineWidth',2)
hold on
plot(mm,'LineWidth',2)
set(gca,'FontSize',18)
xlabel('time [h]')
ylabel('v [cm/s]')
title('Magnitude of current, 1000m depth - Normal Conditions')

figure

subplot(3,1,1)
q=quiver(1:length(dat.t),zeros(length(dat.t),1)',u_z(1,:),v_z(1,:),'k');
set(gca,'FontSize',18)
ylabel('v [cm/s]')
xlabel('time [h]')
title('4500m depth - Normal Conditions')
xlim([-10 400])

subplot(3,1,2)
q=quiver(1:length(dat.t),zeros(length(dat.t),1)',u_z(2,:),v_z(2,:),'k');
set(gca,'FontSize',18)
ylabel('v [cm/s]')
xlabel('time [h]')
title('3500m depth - Normal Conditions')
xlim([-10 400])


subplot(3,1,3)
q=quiver(1:length(dat.t),zeros(length(dat.t),1)',u_z(3,:),v_z(3,:),'k');
set(gca,'FontSize',18)
ylabel('v [cm/s]')
xlabel('time [h]')
title('1000m depth - Normal Conditions')
xlim([-10 400])


