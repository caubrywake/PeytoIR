%% Pit location 
% This script maps the pit information on the study slope. 
% a local reference frame is build using the target and boulder control
% points, and after that, the debris thickness point measurement are located on the
% slope, and the debris thickness is interpolated to the entire study
% slope. 

%% Set-up
clear all
close all
cd ('D:\2_IRPeyto')
figdir ='D:\2_IRPeyto\e_fig\excavations\'; % directory for figures

%% Load TIR1 data
load('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR1_RGBreg.mat') % regietered TIR1rgb image
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat', 'TIR1_time') %% time steamp of the TIR1 images
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop.mat') % the TIR1 image

%% Load Pit depth data
D = importdata('D:\2_IRPeyto\a_data_raw\excavation\Manualexcavation_Peyto_20190806_short.txt');
d = D.data; PitDepth = d(:, 3);
clear D d

%% Quick check at pit depth distribution
figure
edges = [0:5:110];
histogram(PitDepth, edges, 'Facecolor', [0.5 0.5 0.5])
title('Pit depth distribution');
ylim ([0 7])
ylabel('Number of Excavation')
xlabel('Measured Thickness (cm)');

%% Select the study slope
% imagesc(VISreg);
% ROIslope = roipoly;
% ROIslope = double(ROIslope);
% ROIslope(ROIslope == 0)=nan;
% save ('D:\2_IRPeyto\b_data_process\Pit_process\ROIstudyslope.mat', 'ROIslope')

% Or can be loaded direclty here
load('D:\2_IRPeyto\b_data_process\parameter\ROIstudyslope.mat')
%% Build geospatial reference frame
% Select the visible targets and boulders from the VIS RGB image
%  figure
%  imagesc(TIR1_RGBreg)
%  [CP_IR(:,1), CP_IR(:, 2)]=ginput;
% save('D:\2_IRPeyto\b_data_process\Pit_process\ControlPoint_TIR_TargetLocation.mat', 'CP_IR') 

% or load the control points already pickout 
load('D:\2_IRPeyto\b_data_process\parameter\ControlPoints_studyslope_TIR.mat')

% Load the UTM coordinates of the boulder, and target
D = importdata('D:\2_IRPeyto\a_data_raw\DGPS\DGPS_LocationBoulder.csv')
BoulderLocation_utm  = D.data;
BoulderLabel_utm = string(D.textdata(2:7, 1));
D = importdata('D:\2_IRPeyto\a_data_raw\DGPS\DGPS_LocationTarget.csv')
TargetLocation_utm  = D.data;
TargetLabel_utm = string(D.textdata(2:12, 1));
% remove the double target (keep only initial value, as they moved during
% the TIR survey)
TargetLocation_utm  = TargetLocation_utm([2, 4:11], :) ;
TargetLabel_utm = TargetLabel_utm([2,4:11], :) ;
% Group UTM control points together
CP_utm = [TargetLocation_utm; BoulderLocation_utm];
CP_utm_names = [TargetLabel_utm; BoulderLabel_utm];

% Create the interpolated grid
[X,Y] = meshgrid(1:1000, 1:351);
F = scatteredInterpolant(CP_IR(:,1), CP_IR(:,2),CP_utm(:, 1));
X_IR = F(X,Y);
F = scatteredInterpolant(CP_IR(:,1), CP_IR(:,2),CP_utm(:, 2));
Y_IR = F(X, Y);


%% Plots results with label for control points
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,2,1)
imagesc(TIR1_RGBreg);
hold on
scatter(CP_IR(:, 1), CP_IR(:, 2), 'ok')
c = cellstr(CP_utm_names);
dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points
text((CP_IR(:, 1)+ dx), (CP_IR(:, 2)+ dy), c);
title ('VIS')

subplot(2,2,2);
imagesc(TIR1_crop(:,:,400)); caxis([270 280]); colormap('jet'); hold on;colorbar
hold on
scatter(CP_IR(:, 1), CP_IR(:, 2), 'ok')
c = cellstr(CP_utm_names);
dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points
text((CP_IR(:, 1)+ dx), (CP_IR(:, 2)+ dy), c);
title ('IR')

subplot(2,2,3)
imagesc(X_IR);colorbar
hold on
scatter(CP_IR(:, 1), CP_IR(:, 2), 'ok')
c = cellstr(CP_utm_names);
dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points
text((CP_IR(:, 1)+ dx), (CP_IR(:, 2)+ dy), c);
title ('Easting')

subplot(2,2,4)
imagesc(Y_IR);
colorbar
hold on
scatter(CP_IR(:, 1), CP_IR(:, 2), 'ok')
c = cellstr(CP_utm_names);
dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points
text((CP_IR(:, 1)+ dx), (CP_IR(:, 2)+ dy), c);
title ('Northing')
 figname = 'MoraineSpatialFrame_NorthingEastingMap';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))

%% Find the location of the pits on the interpolated grid
% load pit location
D = importdata('D:\2_IRPeyto\a_data_raw\DGPS\DGPS_LocationExcavation.csv')
ExcavationLocation_utm  = D.data;
ExcavationLabel_utm = string(D.textdata(2:46, 1));

figure;
imagesc(TIR1_crop(:,:,400)); caxis([270 280]); colormap('jet'); hold on;colorbar
% Find pixel in X_IR that is closest to Pit location 1
clear X Y C cx cy y x row col 
for i = 1:45
X = find(X_IR >= ExcavationLocation_utm(i, 1)-0.5 & X_IR <= ExcavationLocation_utm(i, 1)+0.5); % find the values close to the pit location
Y = find(Y_IR >= ExcavationLocation_utm(i, 2)-0.5 & Y_IR <= ExcavationLocation_utm(i, 2)+0.5);
[C, cx, cy] = intersect(X, Y); % find values both in the X_IR and Y_IR
if isempty(C)
    C = 1;
    cx = 1;
    cy = 1;
end
if numel(C)>1
    C= C(1);% select the first location that matches
    cx=cx(1);
    cy=cy(1);
end 
[col, row] = ind2sub([351, 1000], X(cx));% find the correspoding row and column in the image

IDX(i, 1)= col;
IDX(i, 2)= row;
scatter(row,col,   'ok');% add that point to the image
dx =5; dy = 5; % displacement so the text does not overlay the data points
text(row+ dy, col+ dx, num2str(i), 'Fontsize', 12); % add label to point
end 

title ('Excavation Location')
 figname = 'ExcavationLocation_IR';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))

PitLocation_TIR = IDX;
save('D:\2_IRPeyto\b_data_process\parameter\PitLocation_TIR.mat', 'PitLocation_TIR')

figure;
imagesc(TIR1_RGBreg); hold on
% Find pixel in X_IR that is closest to Pit location 1
clear X Y C cx cy y x row col 
for i = 1:45
X = find(X_IR >= ExcavationLocation_utm(i, 1)-0.2 & X_IR <= ExcavationLocation_utm(i, 1)+0.2); % find the values close to the pit location
Y = find(Y_IR >= ExcavationLocation_utm(i, 2)-0.2 & Y_IR <= ExcavationLocation_utm(i, 2)+0.2);
[C, cx, cy] = intersect(X, Y); % find values both in the X_IR and Y_IR
if isempty(C)
    C = 1
    cx = 1
    cy = 1
end
if numel(C)>1
    C= C(1);% select the first location that matches
    cx=cx(1);
    cy=cy(1);
end 
[col, row] = ind2sub([351, 1000], X(cx))% find the correspoding row and column in the image

IDX(i, 1)= col;
IDX(i, 2)= row;
scatter(row,col,   'ok');% add that point to the image
dx =5; dy = 5; % displacement so the text does not overlay the data points
text(row+ dy, col+ dx, num2str(i), 'Fontsize', 12); % add label to point
end 

title ('Excavation Location')
 figname = 'ExcavationLocation_VIS';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))

%% Figure of pit and target together
figure;
imshow(TIR1_RGBreg); hold on
scatter(CP_IR(1:9, 1), CP_IR(1:9, 2), 30, 'or', 'filled'); 
scatter(ExcavationLocation_TIR(:, 2), ExcavationLocation_TIR(:, 1), 16, '^', 'filled', 'MarkerFaceColor', [0 112 255]/255); 
legend ('Target', 'Excavation')
figname = 'VIS_Pit_TargetLoc';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))

