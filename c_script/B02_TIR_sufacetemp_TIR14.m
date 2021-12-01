%% Extracting TIR surface temperature at pit location
%  this script produces a time series plot of the temperatures selected region of nterest (ROI) 
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
load('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR1rgb_reg.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat', 'TIR1_time')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop.mat')

L1 = TIR1_crop(:,:,2:1078)-273.15;
L1t = TIR1_time(2:1078);
clear TIR1_crop TIR1_time
% L1 image 1 and 1079 arent good (angle is wrong), so they are removed from
% the set

%% LOC 2 (Moraine - USask Camera)
VIS2= imread('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR2rgb_reg.jpg');
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR2_registered.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR2time.mat')
L2 = TIR2_registered;
L2t = TIR2_time;
clear TIR2_registered 

%% LOC 3 (Glacier view USask)
VIS3= imread('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR3rgb_reg.jpg');
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR3_registered.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR3time.mat')
L3 = TIR3_registered;
L3t = TIR3_time;

%% LOC 4- Close Up USask
VIS3= imread('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR4rgb_reg.jpg');
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR4_registered.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR4time.mat')
L4 = TIR4_registered;
L4t = TIR4_time;

%% Select the ROI
% imagesc(L1(:,:,275));caxis([5 25]); R1 = roipoly; % moraine ROI
% imagesc(L2(:,:,20));R2= roipoly;
% imagesc(L3(:,:,5)); R3 = roipoly; 
% imagesc(L4(:,:,1)); R4 = roipoly; 
%   save('D:\2_IRPeyto\b_data_process\TIR_process\ROI_Loc1_4.mat', 'R1','R2','R3','R4');
% or laod preprocessed ROI
 load('D:\2_IRPeyto\b_data_process\parameter\ROI1_4_surfacetaverage.mat')
 
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

