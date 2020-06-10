%%
clear
close all

d = 'MSEAS'
figure
hold on

switch d 
    case 'BGR'
        BGR_ADCP
for i = 1:10:100
    plot(v(i,:),elevation,'--')
    xlabel('v [cm/s]')
    ylabel('altitude from sea bed [m]')
    set(gca,'FontSize',14)
end

plot(mean(v,1),elevation,'LineWidth',3)

ylim([0 35])

    case 'MSEAS'
        
        MSEAS_ADCP
for i = 1:2:24
    plot(v(i,:),elevation,'--')
    xlabel('v [cm/s]')
    ylabel('altitude from sea bed [m]')
    set(gca,'FontSize',14)
end

plot(mean(v,1),elevation,'LineWidth',3)

ylim([0 200])


case 'GSR'
            GSR_ADCP
c = problematicSens

for i = 1:10:100
    plot(v(i,[1:c-1]),elevation([1:c-1]),'--')
    xlabel('v [cm/s]')
    ylabel('altitude from sea bed [m]')
    set(gca,'FontSize',14)
end

plot(mean(v(:,[1:c-1]),1),elevation([1:c-1]),'LineWidth',3)


for i = 1:10:100
    plot(v(i,[c+1:end]),elevation([c+1:end]),'--')
    xlabel('v [cm/s]')
    ylabel('altitude from sea bed [m]')
    set(gca,'FontSize',14)
end

plot(mean(v(:,[c+1:end]),1),elevation([c+1:end]),'LineWidth',3)

ylim([0 90])
end
