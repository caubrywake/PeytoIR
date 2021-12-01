%% Interpolating debris thcikness over study slope
% This codes interpolates the measured debris thickness over the study
% slope

%% Set-Up
clear all
close all
cd ('D:\2_IRPeyto')
figdir='D:\2_IRPeyto\e_fig\excavations\'

%% Load dataset
% TIR image 
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat', 'TIR1_time')
load('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR1rgb_reg.mat')

% Manual Excavation Depth and Location
load('D:\2_IRPeyto\b_data_process\parameter\PitLocation_TIR.mat')
D = importdata('a_data_raw\excavation\Manualexcavation_Peyto_20190806_short.txt'); % a version without the annotation
d =  D.data;PitDepth=d(:, 3);
clear D d
% Load study slope ROI
load('D:\2_IRPeyto\b_data_process\parameter\ROIstudyslope.mat')

%% Extrapolating depth to study slope
% test 3 options
IDX = PitLocation_TIR; % renaming variable
[X,Y] = meshgrid(1:1000, 1:351); % creating the mesh to interpolate in
% Method 1: Natural neirest neighbor
F = scatteredInterpolant(IDX(:,2),IDX(:,1),PitDepth(:, 2), 'natural');
DepthInterp = F(X,Y);
% Method 2: Linear
Flinear = scatteredInterpolant(IDX(:,2),IDX(:,1),PitDepth(:, 2), 'linear');
DepthInterpLinear = Flinear(X,Y);
% Method 3: Nearest neighbor
Fnearest = scatteredInterpolant(IDX(:,2),IDX(:,1),PitDepth(:, 2), 'nearest');
DepthInterpNearest = Fnearest(X,Y);

%% Plot the different interpolation
figure('units','normalized','position',[0 0 1 1]);
subplot(2,2,1)
image(TIR1rgb_reg); 
hold on
scatter(IDX(:, 2),IDX(:, 1), 'ok')
dx =5; dy = 5; % displacement so the text does not overlay the data points
text(IDX(:, 2)+ dy, IDX(:, 1)+ dx, num2str(PitDepth)); % add label to point
title ('Visual Image')

subplot(2,2,2)
imagesc(DepthInterp);colormap('jet');caxis([0 120]); h = colorbar; ylabel(h, 'Depth (m)', 'FontSize', 12)
hold on
scatter(IDX(:, 2),IDX(:, 1), 'ok')
dx =5; dy = 5; % displacement so the text does not overlay the data points
text(IDX(:, 2)+ dy, IDX(:, 1)+ dx, num2str(PitDepth)); % add label to point
title('Natural Nearest Neighor')

subplot(2,2,3)
imagesc(DepthInterpLinear);colormap('jet');caxis([0 120]); h = colorbar; ylabel(h, 'Depth (m)', 'FontSize', 12)
hold on
scatter(IDX(:, 2),IDX(:, 1), 'ok')
dx =5; dy = 5; % displacement so the text does not overlay the data points
text(IDX(:, 2)+ dy, IDX(:, 1)+ dx, num2str(PitDepth)); % add label to point
title('Linear')

subplot(2,2,4)
imagesc(DepthInterpNearest);colormap('jet');caxis([0 120]); h = colorbar; ylabel(h, 'Depth (m)', 'FontSize', 12)
hold on
scatter(IDX(:, 2),IDX(:, 1), 'ok')
dx =5; dy = 5; % displacement so the text does not overlay the data points
text(IDX(:, 2)+ dy, IDX(:, 1)+ dx, num2str(PitDepth)); % add label to point
title('Nearest Neighbour')

 figname = 'ManualExcavation_InterpolatedToStudySlope_ThreeMethods';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))

%% Plot just the visual and interpolated
cmap = colormap('gray');
figure('units','inches','position',[0 0 7 8]);
subplot(2,1,1)
image(TIR1rgb_reg); 
hold on
plot(ROIx, ROIy, ':k', 'linewidth', 2)
scatter(IDX(:, 2),IDX(:, 1),20, '^b', 'filled')
dx =5; dy = -5; % displacement so the text does not overlay the data points
text(IDX(:, 2)+ dy, IDX(:, 1)+ dx, num2str(PitDepth(:, 2)))% add label to point
colorbar
xticklabels ([]); yticklabels([])
subplot(2,1,2)
image(TIR1rgb_reg); hold on
imagesc(DepthInterp.^ROI);colormap(cmap);caxis([0 120]); h = colorbar; ylabel(h, 'Depth (cm)', 'FontSize', 12)
hold on
scatter(IDX(:, 2),IDX(:, 1),20, [0 128 255]/255,'^',  'filled')
plot(ROIx, ROIy, ':k', 'linewidth', 2)
dx =-5; dy = 5; % displacement so the text does not overlay the data points
text(IDX(:, 2)+ dy, IDX(:, 1)+ dx, num2str(PitDepth(:, 2))); % add label to point
xticklabels ([]); yticklabels([])

 figname = 'InterpolatedDebrisThickness';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))

%%  Plot distribution of depth
D = DepthInterp;
D(D<0)=0;
D = D.^ROI; D(D==1) = nan;
di = [0:10:140]
clear a
for i = 1:length(di)-1
    a(i) = numel(find(D>=di(i) & D<di(i+1))); 
end 
clear b
for i = 1:length(di)-1
    b(i) = numel(find(PitDepth(:, 2)>=di(i) & PitDepth<di(i+1))); 
end 
figure('units','inches','position',[0 0 5 5]);
subplot(2,1,1)
bar(b) % x acis = 1:45, y axis- number of time
xticklabels ({'0-10', '10-20', '20-30', '30-40', '40-50', '50-60', '60-70', '70-80', '80-90', '90-100', '100-110', '110-120'})
xtickangle (45)
xlim ([.5 12.5]) 
title ('Pits Depth Distribution')
ylabel ('Number of Pits')
subplot(2,1,2); bar(a)
xticklabels ({'0-10', '10-20', '20-30', '30-40', '40-50', '50-60', '60-70', '70-80', '80-90', '90-100', '100-110', '110-120'})
xtickangle (45); xlim ([.5 12.5]) 
title ('Extrapolated Depth Distributon')
ylabel('Number of Pixels')
xlabel ('Depth (cm)')
 figname = 'PitDepth_ExtrapolatedHistoGram';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))

%% Plot the three together
% change the bckground color
ROI =double(ROI);
ROI(ROI==0)=nan;
DepthInterpROI = DepthInterp.*ROI;
DepthInterpROI(DepthInterpROI<0) = nan;
DepthInterpROI_reshape = reshape(DepthInterpROI, 1, 351:100);
DepthInterpROI_reshape(DepthInterpROI_reshape<=0)=nan;
Depth_meanmeas = nanmean(DepthInterpROI_reshape); % eamean depth measured

IDX(:, 17) = nan; % remove the pit that falls out of the image
cmap = colormap('gray');
cmap(1, :) = 1;

figure('units','inches','position',[0 0 7 8]);
subplot(2,2,1:2)

imagesc(DepthInterp.^ROI);colormap(cmap);caxis([0 120]); h = colorbar; ylabel(h, 'Depth (cm)', 'FontSize', 12)
hold on
scatter(IDX(:, 2),IDX(:, 1),20, [0 128 255]/255,'^',  'filled')
dx =-5; dy = 5; % displacement so the text does not overlay the data points
text(IDX(:, 2)+ dy, IDX(:, 1)+ dx, num2str(PitDepth(:,2))); % add label to point
xticklabels ([]); yticklabels([])

subplot(2,2,3)
bins = [0:5:120]; % bin edges
histogram(PitDepth(:, 2), bins, 'Facecolor', [0.5 .5 .5]); % x acis = 1:45, y axis- number of time
xlim ([0 120]) ; ylim ([0 7])
xlabel('Depth (cm)')
ylabel ('Number of Manual Excavation')

subplot(2,2,4)
bins = [0:5:120]; % bin edges
histogram(DepthInterpROI_reshape,bins, 'Facecolor', [0.5 .5 .5])
xlim ([0 120]) 
xlabel('Depth (cm)')
ylabel ('Number of Pixel')

 figname = 'PitDepth_ExtrapolatedHistoGram_together';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))

%% Save interpolated debris thickness
save('D:\2_IRPeyto\b_data_process\parameter\DebrisThickness_interpolated_studyslope.mat', 'DepthInterp')

