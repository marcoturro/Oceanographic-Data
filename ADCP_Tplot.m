close all
clear
set = 'GSR'
mooringnb = '2'
load(['../' set '_Area/FieldData/Moorings/MOR00' mooringnb '/data/MOR00' mooringnb '_merged_adcps_QA.mat'])

Nd = 1;
time = (time - time(1));
dayI = find(ceil(time)==Nd,1,'last');
ve = ve/100; vn = vn/100;
ve = rmmissing(ve) ; vn = rmmissing(vn);



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



