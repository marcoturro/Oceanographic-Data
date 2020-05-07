close all
clear
Mset = 'BGR'
mooringnb = '17177_2019'
if Mset == 'GSR'
    load(['./DATA/GSR/MOR00' mooringnb '_merged_adcps_QA.mat'])
else
    load(['./DATA/BGR/ADCP' mooringnb '.mat'])
end
Nd = 1;
time = (time - time(1));
dayI = find(ceil(time)==Nd,1,'last');
ve = ve/100; vn = vn/100;
[ve, CV ]= rmmissing(ve) ; vn = rmmissing(vn);
el = elevation(~CV);
el(end+1) = 0;
theta = atan(vn/ve);

for i  = 1:length(el)-1
    ve(i,:) = wdenoise(ve(i,:),8);
    vn(i,:) = wdenoise(vn(i,:),8);
end

[~, brk] = max(diff(el));
brk = brk - 1;
v = abs(ve) + abs(vn);
v(end+1,:) = zeros(1,length(time));

v_d_avg = sum((v),1) / length(el) ;
vH = sum(v(1:brk,:),1) / length(1:brk);
vL = sum(v(brk+1:end,:),1) / length(brk+1:length(el));

%%
plot(v_d_avg)
hold on
plot(vL)
plot(vH)
legend('avg','lower ADCDPs','higher')

figure
v_prof_low = [sum(v(brk+1:end-1,:),2)/length(time);0];
plot(v_prof_low,el(brk+1:end))

figure
v_prof_high = sum(v(1:brk,:),2)/length(time);
plot(v_prof_high,el(1:brk))

%% %%%%%%%%%%%%%%%%%%%
for i = 1:length(time)
hold on
if rem(i,2) == 0
q = quiver3(zeros(length(el(1:brk)),1),zeros(length(el(1:brk)),1),el(1:brk),ve(1:brk,i),vn(1:brk,i),zeros(length(el(1:brk)),1),'LineWidth',2)
q.Color = 'red';
else
q = quiver3(zeros(length(el(1:brk)),1),zeros(length(el(1:brk)),1),el(1:brk),ve(1:brk,i),vn(1:brk,i),zeros(length(el(1:brk)),1),'LineWidth',2)
q.Color = 'blue';
end
view(-35,45);
xlim([-15 15])
ylim([-15 15])
pause(1)
items = get(gca, 'Children');
if i>1
delete(items(end));
end
end

%% %%%%%%%%%%%%%%%%%%%
for i = 1:length(time)
hold on
if rem(i,2) == 0
q = quiver3(zeros(length(el(brk+1:end-1)),1),zeros(length(el(brk+1:end-1)),1),el(brk+1:end-1),ve(brk+1:end,i),vn(brk+1:end,i),zeros(length(el(brk+1:end-1)),1),'LineWidth',2)
q.Color = 'red';
else
q = quiver3(zeros(length(el(brk+1:end-1)),1),zeros(length(el(brk+1:end-1)),1),el(brk+1:end-1),ve(brk+1:end,i),vn(brk+1:end,i),zeros(length(el(brk+1:end-1)),1),'LineWidth',2)
q.Color = 'blue';
end
view(-35,45);
xlim([-15 15])
ylim([-15 15])
pause(1)
items = get(gca, 'Children');
if i>1
delete(items(end));
end
end



%% %%%%%%%%
for i = 1:200
plot(movmean(ve(:,i),3),el)
yL = ylim;
xlim([-.1 .1])
line([0 0], yL);
pause(1)

end
for d = 0:4

x = zeros(length(ve(:,1)),dayI); y = x;
figure

for j = 1:length(ve(:,1))
for i =  1:dayI
    
    x(j,i+1) = x(j,i) + ve(j,d*dayI+i)*time(d*dayI+i);
    y(j,i+1) = y(j,i) + vn(1,d*dayI+i)*time(d*dayI+i);
    
end
end

for k = 1:12
plot(x(k,:),y(k,:))
pause(0.15)
hold on
xL = xlim;
yL = ylim;
line([0 0], yL);  %x-axis
line(xL, [0 0]);  %y-axis
end

end



