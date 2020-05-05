%%code for maps

clear all
close all

%Excel Opening
% path = 'F:\LN\LakeNeuchatel\Results\Results_M_1';
% fileId=('PU2018.xls');
% [ndata,texti0,alldata]=xlsread(fileId,1,'B4:B45');

%from manual file

FigName=sprintf('Lat');
Filename  = sprintf('coords_GPS.m');
infile=fopen(Filename,'r');
C=textscan(infile, '%s %f %f %f %f');
fclose(infile);

Station=C{1};
a=C{2};
b=C{3};
c=C{4};
d=C{5};

for i=1:length(a)
    Lat(i)=a(i)+b(i)/60;
    Lon(i)=c(i)+d(i)/60;
end
%%
%h = worldmap ([S N] [W E]);
h = worldmap([-5 40], [-160 -90]);
geoshow('landareas.shp', 'FaceColor', [0.6 0.6 0.6]);
gridm('on');
gridm('mlinelocation', 5, 'plinelocation',5)

%geoshow(LatH, LonH, 'r', '*'); %for polygones
LatGSR=Lat(6:8);
LonGSR=Lon(6:8);
LatBGR=Lat(1:5);
LonBGR=Lon(1:5);
scatterm(LatGSR,LonGSR,'b','o')
hold on
scatterm(LatBGR,LonBGR,'r','o')
 

%%
%h = worldmap ([S N] [W E]);
% h = worldmap([70  78], [50 70]);
% geoshow('landareas.shp', 'FaceColor', [0.6 0.6 0.6]);
% gridm('on');
% gridm('mlinelocation', 5, 'plinelocation',5)
% scatterm(Latb,Lonb,'b','.')
%  
% Latb=[]