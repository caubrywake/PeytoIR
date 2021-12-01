%% Extracting TIR surface temperature at pit location
% By Caroline Aubry-Wake
% edited 2021-06-07
% this script only plot for continuous debris! 

%  this script produces a trime series plot of th e temperature s selected region of nterest (ROI) 
%  for the 4 sets of images of the debris-covered moraine.

%  The script first loads the infrared images (all registered). 
%  LOC1 is the main time series, of the MMcGill camera facing the moraine. 
%  LOC2 is the side view of the moraine with the USask camera. 
%  Loc3 is a widere angle including the glacier,
%  for a short duration, and LOC4 is a zoom of the ice cliff wall with the usask canera. 
%  
% After the TIR images are loaded, the ROI are selected for each image,
% Then the surface temperature of the area of interest is extracted 
% (average + standard deviation) and finally the time series is plotted.

%% Set-up 
% set-up
close all
clear all
cd ('D:\2_IRPeyto')

figdir ='D:\2_IRPeyto\e_fig\tir_surfacet\'

%% LOC1  (McGill Camera)
load('D:\2_IRPeyto\b_data_process\TIR_process\RGBregistered\TIR1_RGBreg.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat', 'TIR1_time')
TIR1_time =TIR1_time -hours(8);
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop.mat')


L1 = TIR1_crop(:,:,2:1078)-273.15;
L1t = TIR1_time(2:1078);
clear Rcrop DTst VISreg TIRtime
% L1 image 1 and 1079 arent good (angle is wrong), so they are removed from
% the set

%% LOC 2 (Moraine - USask Camera)
VIS2= imread('D:\2_IRPeyto\b_data_process\TIR_process\RGBregistered\RGBregistered_L2_moraine.jpg');
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR2_registered.mat')
L2 = TIR2_registered;
clear TIR2_registered

% time of images
dirinfo = dir('a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190805AA\*.irb'); L2_1t = datetime(extractfield(dirinfo, 'date'))
dirinfo = dir('a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190805AB\*.irb'); L2_2t = datetime(extractfield(dirinfo, 'date'))
dirinfo = dir('a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190807AB\*.bmp'); L2_3t = datetime(extractfield(dirinfo, 'date'))
dirinfo = dir('a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190807AC\*.bmp'); L2_4t = datetime(extractfield(dirinfo, 'date'))
dirinfo = dir('a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190807AD\*.irb'); L2_5t = datetime(extractfield(dirinfo, 'date'))
dirinfo = dir('a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190808AA\*.irb'); L2_6t = datetime(extractfield(dirinfo, 'date'))
dirinfo = dir('a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190808AB\*.irb'); L2_7t = datetime(extractfield(dirinfo, 'date'))
dirinfo = dir('a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190808AC\*.bmp'); L2_8t = datetime(extractfield(dirinfo, 'date'))
L2t = [L2_1t, L2_2t, L2_3t, L2_4t, L2_5t, L2_6t, L2_7t, L2_8t];
clear L2_1t L2_2t L2_3t L2_4t L2_5t L2_6t L2_7t L2_8t L2r
TIR2_time = table(L2t);
writetable(TIR2_time, 'D:\2_IRPeyto\b_data_process\TIR_process\TIR2time.txt')
save('D:\2_IRPeyto\b_data_process\TIR_process\TIR2time.mat','TIR2_time')

%% LOC 3 (Glacier view USask)
VIS3= imread('D:\2_IRPeyto\b_data_process\TIR_process\RGBregistered\RGBregistered_L3_glacier.jpg');
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR3_registered.mat')

dirinfo = dir('a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190806AA\*.bmp'); L3t = datetime(extractfield(dirinfo, 'date'))
L3 = TIR3_registered(:,:,2:41);
L3t = L3t(2:41);
clear TIR3_registered

TIR3_time = table(L3t);
writetable(TIR3_time, 'D:\2_IRPeyto\b_data_process\TIR_process\TIR3time.txt')
save('D:\2_IRPeyto\b_data_process\TIR_process\TIR3time.mat','TIR3_time')

%% Loc 4 - Close Up USask
VIS3= imread('D:\2_IRPeyto\b_data_process\TIR_process\RGBregistered\RGBregistered_L4_zoom.jpg');
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR4_registered.mat')
dirinfo = dir('D:\2_IRPeyto\a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\190809AA\*.irb'); L4t = datetime(extractfield(dirinfo, 'date'))
clear dirinfo
TIR4_time = table(L4t);
writetable(TIR4_time, 'D:\2_IRPeyto\b_data_process\TIR_process\TIR4time.txt')
save('D:\2_IRPeyto\b_data_process\TIR_process\TIR4time.mat','TIR4_time')

%% Select the ROI
% imagesc(L1(:,:,275));caxis([5 25]); R1 = roipoly; % moraine ROI
% imagesc(L2(:,:,20));R2= roipoly;
% imagesc(L3(:,:,5)); R3 = roipoly; 
% imagesc(L4(:,:,1)); R4 = roipoly; 
%   save('D:\2_IRPeyto\b_data_process\TIR_process\ROI_Loc1_4.mat', 'R1','R2','R3','R4');
 load('b_data_process\TIR_process\ROI_Loc1_4.mat')
%% Extract temperature for the ROI
for i = 1:1077
    I = L1(:,:,i);
    I(I==0)=nan; % change the 0 for nan to not affect result
    T1(i) =  nanmean(I(R1));
    T1std(i) =  std(I(R1), 'omitnan');
end 
for i = 1:339
    I = L2(:,:,i);
    I(I==0)=nan; % change the 0 for nan to not affect result
    T2(i) =  nanmean(I(R2));
    T2std(i) =  nanstd(I(R2));
end 
for i = 1:40
    I = L3(:,:,i);
    I(I==0)=nan; % change the 0 for nan to not affect result
    T3(i) =  nanmean(I(R3));
    T3std(i) =  nanstd(I(R3));
 end 
for i = 1:22
    I = L4(:,:,i);
    I(I==0)=nan; % change the 0 for nan to not affect result
    T4(i) =  nanmean(I(R4));
    T4std(i) =  nanstd(I(R4));
%          T4d(i) =  nanmean(I(R4d));
%     T4stdd(i) =  nanstd(I(R4d));
end 

%% Shaded plot
% Load air temperature
D = importdata('a_data_raw\AWS\PeytoMoraineAWS_15min.csv')
M = D.data;% moraine date: T, RH, SWin, U, LW
Mt = datetime(D.textdata(18:end, 1)); %moraine Time
clear D
% timing for L2t in into 3day
t1 = 1:106;
t2= 107:196;
t3 = 197:339;
% assemble arrays
T1s = [T1; T1+T1std; T1-T1std];
T2s1 = [T2(t1); T2(t1)+T2std(t1);T2(t1)-T2std(t1)];
T2s2 = [T2(t2); T2(t2)+T2std(t2);T2(t2)-T2std(t2)];
T2s3 = [T2(t3); T2(t3)+T2std(t3);T2(t3)-T2std(t3)];
T3s = [T3; T3+T3std; T3-T3std];
T4s = [T4; T4+T4std; T4-T4std];

fig = figure('units','inches','position',[0 0 8 3]); % aug 7, 17:45
stdshade(T1s, .2,'k', L1t, 1) ; hold on
stdshade(T2s1,.2,'r',L2t(t1), 1) ; 
stdshade(T2s2,.2,'r',L2t(t2), 1) ; 
stdshade(T2s3,.2,'r',L2t(t3), 1) ; 
stdshade(T3s, .2,'b',L3t, 1) ; 
stdshade(T4s, .2,'m',L4t, 1) ; 
ylabel('Temperature (C^{\circ})')
plot(Mt, M(:, 1), ':k', 'linewidth', 1)
% plot([time(1) time(end)], [0 0], 'k', 'linewidth', .2)
ylim ([-5 32])
lg = legend ('TIR1', 'TIR2', 'TIR3', 'TIR4', 'Air Temperature', 'Orientation', 'Horizontal', 'Location' ,'NorthWest')
pos = lg.Position
lg.Position = pos + ([-0.005 0.02 0 0])
xlim([L1t(1) L1t(end)])
xticks ([L1t(82):hours(6):L1t(end)])
grid on
xtickformat ('dd-MMM, HH:mm ')
xtickangle (30)

 figname = 'SurfaceT_TIR_Loc1_4';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))


