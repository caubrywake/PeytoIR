%% Spatial aggregation impact on modelled debris thickness
% This script check how the sptial resoltuion of the TIR images affect the
% correlation between surface temperature and debirs thickness

%% Set-Up
clear all
close all
cd ('D:\2_IRPeyto')
figdir='D:\2_IRPeyto\e_fig\correlation_lesspits\'
addpath('D:\2_IRPeyto\d_function')

% color for figure
c1 = [255 127 5]./255; % orange
c2 = [100 0 205]./255; % purple
c3 = [26 164 59]./255; % green

%% Load Variables
%TIR imagery and surfce temp at pit location
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat', 'TIR1_time')

TIR = TIR1_crop-273.15;
TIRtime = TIR1_time(2:1078);
clear TIR1_crop TIR1_time

% Pit surface temperature
load('D:\2_IRPeyto\b_data_process\parameter\TIRtemperature_atpitlocation.mat')
TPit =TIRtemperature_atpitlocation-273.15; % change name
TPit=TPit(2:1078, :);% remove first and last value

 % Pit location and depth
load('D:\2_IRPeyto\b_data_process\parameter\PitLocation_TIR.mat')
D = importdata('a_data_raw\excavation\ManualExcavationDepth.csv');
d = D.data; d = PitDepth(:, 3);
clear D

% Interpolated debris thickness
load('D:\2_IRPeyto\b_data_process\parameter\DebrisThickness_interpolated_studyslope.mat')

% Study Slope
load('D:\2_IRPeyto\b_data_process\parameter\ROIstudyslope.mat')
ROI =double(ROI);
ROI(ROI==0)=nan;
TIRroi = S1.*ROI;
DepthInterpROI = DepthInterp.*ROI;
DepthInterpROI(DepthInterpROI<0) = nan;
DepthInterpROI_reshape = reshape(DepthInterpROI, 1, 351:100);
DepthInterpROI_reshape(DepthInterpROI_reshape<=0)=nan;
Depth_meanmeas = nanmean(DepthInterpROI_reshape); 

%% Change the resolution
[X, Y] = meshgrid (1:1000, 1:351); V = S1(:,:,754);
[Xq, Yq] = meshgrid(1:10:1000, 1:10:351);
Vq1 = interp2(X,Y,V,Xq,Yq);
[Xq, Yq] = meshgrid(1:20:1000, 1:20:351);
Vq2 = interp2(X,Y,V,Xq,Yq);
[Xq, Yq] = meshgrid(1:30:1000, 1:30:351);
Vq3 = interp2(X,Y,V,Xq,Yq);

%% Compare results
fig = figure('units','inches','position',[0 0 8 4]); % aug 7, 17:45
subplot(2,2,1)
imagesc(V); caxis([-3 10]); colorbar; colormap ('hot')
xticklabels ([]); yticklabels([]);
text (30, 30, '(a)')
subplot(2,2,2)
imagesc(Vq1);  caxis([-3 10]); colorbar; colormap ('hot')
text (5,5, '(b)')
xticklabels ([]); yticklabels([]);
subplot(2,2,3)
imagesc(Vq2); caxis([-3 10]); colorbar; colormap ('hot')
text (3,3, '(c)'); xticklabels ([]); yticklabels([]);
subplot(2,2,4)
imagesc(Vq3);  caxis([-3 10]); colorbar; colormap ('hot')
text (1.5, 1.5, '(d)'); xticklabels ([]); yticklabels([]);

figname = 'TIRImage_CoarserResolution';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Make the whole time series at these resolution
[X, Y] = meshgrid (1:1000, 1:351);
[X2, Y2] = meshgrid(1:10:1000, 1:10:351);
[X3, Y3] = meshgrid(1:20:1000, 1:20:351);
[X4, Y4] = meshgrid(1:30:1000, 1:30:351);
for i = 1:1077
    I = S1(:,:,i);   
S2(:,:, i) = interp2(X,Y,I,X2,Y2);
S3(:,:,i) = interp2(X,Y,I,X3,Y3);
S4(:,:,i) = interp2(X,Y,I,X4,Y4);
end 

%resample then to small scale to get the right pit coordinates
for i = 1:1077
I2 = S2(:,:,i);   
I3 = S3(:,:,i);   
I4 = S4(:,:,i);   
S22(:,:,i) = interp2(X2,Y2,I2,X,Y);
S32(:,:,i) = interp2(X3,Y3,I3,X,Y);
S42(:,:,i) = interp2(X4,Y4,I4,X,Y);
end
%% figure, resample figure, with pit
fig = figure('units','inches','position',[0 0 8 4]); % aug 7, 17:45
subplot(2,2,1)
imagesc(S1(:,:,443)); caxis([-3 5]);cb =  colorbar; colormap ('hot'); hold on
scatter(IDX(:, 2), IDX(:, 1),10,  'ow')
xticklabels ([]); yticklabels([]);
text (30, 30, '(a)')
ylabel (cb,'Temperature (^{\circ}C)')

subplot(2,2,2)
imagesc(S22(:,:,443)); caxis([-3 5]); cb = colorbar; colormap ('hot'); hold on
text (30, 30, '(b)')
scatter(IDX(:, 2), IDX(:, 1) ,10,  'ow')
xticklabels ([]); yticklabels([]);
ylabel (cb,'Temperature (^{\circ}C)')

subplot(2,2,3)
imagesc(S32(:,:,443)); caxis([-3 5]); cb = colorbar; colormap ('hot'); hold on
text (30,30, '(c)'); xticklabels ([]); yticklabels([]);
scatter(IDX(:, 2), IDX(:, 1),10,  'ow')
ylabel (cb,'Temperature (^{\circ}C)')

subplot(2,2,4)
imagesc(S42(:,:,443)); caxis([-3 5]); cb = colorbar; colormap ('hot'); hold on
scatter(IDX(:, 2), IDX(:, 1),10,  'ow')
text (30, 30, '(d)'); xticklabels ([]); yticklabels([]);

ylabel (cb,'Temperature (^{\circ}C)')

figname = 'CoarserResolution_withPit';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Extract temperature from the different resolution
clear IDXroi
for i = 1:45 % select the pixels for eahc pit
 M0 = zeros(351, 1000);
 M0(IDX(i, 1)-3:IDX(i, 1)+3, IDX(i,2)-3:IDX(i,2)+3) = 1;% each pit is set to be 3x3 pixel
 IDXroi(:, i) = find(M0);
end 
 

 for i = 1:1077 % extract the mean temperature of the pixels for each timestep
     for ii = 1:45  
         [row, col] = ind2sub([351, 1000],IDXroi(:, ii)); 
TPitS1(i, ii) = mean(mean((S1(row,col, i)))); % from the raw IR image
TPitS2(i, ii) = mean(mean((S22(row,col, i)))); % from the raw IR image
TPitS3(i, ii) = mean(mean((S32(row,col, i)))); % from the raw IR image
TPitS4(i, ii) = mean(mean((S42(row,col, i)))); % from the raw IR image
     end 
 end 

% remove some of the bad values
TPitS1(TPitS1<=-10)=nan; % when the pit were not in the filed of view due to shift in the camera
TPitS1(:, [17, 33, 34])=nan; % pit our of view form IR, of on the edge of the ice cliff

TPitS2(TPitS2<=-10)=nan; % when the pit were not in the filed of view due to shift in the camera
TPitS2(:, [17, 33, 34])=nan; % pit our of view form IR, of on the edge of the ice cliff

TPitS3(TPitS3<=-10)=nan; % when the pit were not in the filed of view due to shift in the camera
TPitS3(:, [17, 33, 34])=nan; % pit our of view form IR, of on the edge of the ice cliff

TPitS4(TPitS4<=-10)=nan; % when the pit were not in the filed of view due to shift in the camera
TPitS4(:, [17, 33, 34])=nan; % pit our of view form IR, of on the edge of the ice cliff

%% Correlation for each layer
 for i = 1:length(S1t)
    clear x y
y = PitDepth(:, 2);
x = TPitS1(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end
% exp fit
[fit, gof] =expfit(x, y); % y = x*x + b
adjr2_s1(i, 1)=gof.rsquare;
rmse_s1(i, 1) = gof.rmse;
% Linear fit
[fit, gof] =poly1fit(x, y); % y = x*x + b
adjr2_s1(i, 2)=gof.rsquare;
rmse_s1(i, 2) = gof.rmse;
% S2
    clear x y
y = PitDepth(:, 2);
x = TPitS2(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end
% exp fit
[fit, gof] =expfit(x, y); % y = x*x + b
adjr2_s2(i, 1)=gof.rsquare;
rmse_s2(i, 1) = gof.rmse;
% Linear fit
[fit, gof] =poly1fit(x, y); % y = x*x + b
adjr2_s2(i, 2)=gof.rsquare;
rmse_s2(i, 2) = gof.rmse;
%S3
    clear x y
y = PitDepth(:, 2);
x = TPitS3(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end
% exp fit
[fit, gof] =expfit(x, y); % y = x*x + b
adjr2_s3(i, 1)=gof.rsquare;
rmse_s3(i, 1) = gof.rmse;
% Linear fit
[fit, gof] =poly1fit(x, y); % y = x*x + b
adjr2_s3(i, 2)=gof.rsquare;
rmse_s3(i, 2) = gof.rmse;
% S4
    clear x y
y = PitDepth(:, 2);
x = TPitS4(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end
% exp fit
[fit, gof] =expfit(x, y); % y = x*x + b
adjr2_s4(i, 1)=gof.rsquare;
rmse_s4(i, 1) = gof.rmse;
% Linear fit
[fit, gof] =poly1fit(x, y); % y = x*x + b
adjr2_s4(i, 2)=gof.rsquare;
rmse_s4(i, 2) = gof.rmse;

 end 

 %% Plot
c1 = [255 127 5]./255; % orange
c2 = [100 0 205]./255; % purple
c3 = [26 164 59]./255; % green
id = find(S1t  == '8-Aug-2019 4:35:02');% exp

figure('units','inches','position',[0 0 8 5]);
sf = 12; % smooth factpr
lw = 1; % linewith
subplot(2,1,1)
p1 = plot(S1t, smooth(adjr2_s1(:, 1), sf), '-k', 'LineWidth', lw); hold on
p2 = plot(S1t, smooth(adjr2_s1(:, 2), sf), ':k', 'LineWidth', lw); hold on
p3 = plot(S1t, smooth(adjr2_s2(:, 1), sf),'-','Color', c1, 'LineWidth', lw);
p4 = plot(S1t, smooth(adjr2_s2(:, 2), sf),':','Color', c1, 'LineWidth', lw);
p5 = plot(S1t, smooth(adjr2_s3(:, 1), sf),'-','Color', c2, 'LineWidth', lw);
p6 = plot(S1t, smooth(adjr2_s3(:, 2), sf),':','Color', c2, 'LineWidth', lw);
p7 = plot(S1t, smooth(adjr2_s4(:, 1), sf),'-','Color', c3, 'LineWidth', lw);
p8 = plot(S1t, smooth(adjr2_s4(:, 2), sf),':','Color', c3, 'LineWidth', lw); 
% add scatter for each of these
sz = 15;
scatter(S1t(id), adjr2_s1(id, 2), sz, 'k', 'd', 'filled') 
scatter(S1t(id), adjr2_s2(id, 2), sz, c1, 'd', 'filled') 
scatter(S1t(id), adjr2_s3(id, 2), sz, c2, 'd', 'filled') 
scatter(S1t(id), adjr2_s4(id, 2), sz, c3, 'd', 'filled')
legend ([p1(1) p2(1) p3(1) p4(1) p5(1) p6(1) p7(1) p8(1)], 'All, Exp.', 'All, Lin.', '/10, Exp.','/10, Linear',  '/20, Exp.',  '/20,Linear',...
    '/30, Exp.',  '/30,Linear','location', 'westoutside') 
ylim ([0 1])
ylabel ('R^2')
xlim([S1t(1) S1t(end)]);


subplot(2,1,2)
plot(S1t, smooth(rmse_s1(:, 1), sf), '-k', 'LineWidth', lw); hold on
plot(S1t, smooth(rmse_s1(:, 2), sf), ':k', 'LineWidth', lw); hold on
plot(S1t, smooth(rmse_s2(:, 1), sf),'-','Color', c1, 'LineWidth', lw); 
plot(S1t, smooth(rmse_s2(:, 2), sf),':','Color', c1, 'LineWidth', lw); 
plot(S1t, smooth(rmse_s3(:, 1), sf),'-','Color', c2,'LineWidth', lw); 
plot(S1t, smooth(rmse_s3(:, 2), sf),':','Color', c2,'LineWidth', lw); 
plot(S1t, smooth(rmse_s4(:, 1), sf),'-','Color', c3, 'LineWidth', lw); 
plot(S1t, smooth(rmse_s4(:, 2), sf),':','Color', c3, 'LineWidth', lw); 
ylim ([10 25])
scatter(S1t(id), rmse_s1(id, 2), sz, 'k', 'd', 'filled') 
scatter(S1t(id), rmse_s2(id, 2), sz, c1, 'd', 'filled') 
scatter(S1t(id), rmse_s3(id, 2), sz, c2, 'd', 'filled') 
scatter(S1t(id), rmse_s4(id, 2), sz, c3, 'd', 'filled')

legend ('All, Exp.', 'All, Lin.', '/10, Exp.','/10, Linear',  '/20, Exp.',  '/20,Linear',...
    '/30, Exp.',  '/30,Linear','location', 'westoutside') 
ylabel ('RMSE (cm)')
xlim([S1t(1) S1t(end)]);

figname = 'R2_RMSE_perSpatialRes_Linear_Exp';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% RMSE abd R2 value
[adjr2_s2(id, 2), rmse_s2(id, 2)]
[adjr2_s3(id, 2), rmse_s3(id, 2)]
[ adjr2_s4(id, 2), rmse_s4(id, 2)]


%% calculate debrs thickness across image for best time
TPit_select =  {TPitS1;TPitS2;TPitS3;TPitS4};
id = find(S1t  == '8-Aug-2019 4:35:02');% exp
TIRroi_S1 = reshape(S1(:,:,id).*ROI, 351*1000, 1);
TIRroi_S2 = reshape(S22(:,:,id).*ROI, 351*1000, 1);
TIRroi_S3 = reshape(S32(:,:,id).*ROI, 351*1000, 1);
TIRroi_S4 = reshape(S42(:,:,id).*ROI, 351*1000, 1);
TIRroi_all = [TIRroi_S1,TIRroi_S2,TIRroi_S3,TIRroi_S4];
TIRroi_all(TIRroi_all<-50)=nan;

for i = 1:length(TPit_select)
y = PitDepth(:, 2);
x1 = TPit_select{i};
x = x1(id, :)';
a = find(isnan(x));% remove the nan, from section of image being out of view
x(a)=[];
y(a)=[];

[fit, gof] =poly1fit(x, y); % 

adjr2_best(i)=gof.rsquare;
rmse_best(i) = gof.rmse;
yfit_IR = feval(fit, TIRroi_all(:, i));
TIRfit_best(:,:, i) = reshape(yfit_IR , 351, 1000);  
end 
IDX(17, :) = nan;
%% Plot the resulting debris tchikness
close all
header ={'(a) Original Resolution';'(b) Resolution/10';'(c) Resolution/20';'(d) Resolution/30';};
f = figure('units','inches','position',[0 0 8 5]);
cmap = parula(256);
% Make lowest one black
cmap(1,:) = 1;
for i = 1:4
    subplot(2,2,i)
    imagesc(TIRfit_best(:,:,i)); hold on
        colormap(cmap)
    text(25, 25, header(i))
    caxis([0 130])
    scatter(IDX(:, 2),IDX(:,1),8, 'ok')
    
if i == 2 | i == 4
     cb = colorbar;
     set(cb, 'Ytick', [0:20:120]);
     ylabel(cb, 'Debris Thickness (cm)')
     cb.Position = cb.Position+[0.08 0 0 0]
end   
xticklabels ([])
yticklabels([])

end 
%
clear h sp1
h=get(f,'children');
sp1 = h(2);
sp1.Position = sp1.Position .*[0.9 1 1 1]
sp1 = h(3);
sp1.Position = sp1.Position .*[1.3 1 1 1]
sp1 = h(5);
sp1.Position = sp1.Position .*[0.9 0.8 1 1.0]
sp1 = h(6);
sp1.Position = sp1.Position .*[1.3 0.8 1 1.0]
sp1 = h(1);% colorbar
sp1.Position = sp1.Position .*[0.93 1 1 1]
sp1 = h(4);% colorbar
sp1.Position = sp1.Position .*[0.93 0.8 1 1.0]

figname = 'Calculated_DT_SpatialRes';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% distribution of pixel for each
bins = [0:5:120]; % bin edges
[NumPixMeas, nd]=hist(DepthInterpROI_reshape,bins);
for i = 1:4
I = reshape(TIRfit_best(:,:,i), 351*1000,1);
[NumPixCalc(:, i),depth(:, i)]=hist(I,bins);
end
%% Combined plot

c1 = [255 127 5]./255; % orange
c2 = [100 0 205]./255; % purple
c3 = [26 164 59]./255; % green
id = find(S1t  == '8-Aug-2019 4:35:02');% exp

figure('units','inches','position',[0 0 8 6]);
sf = 12; % smooth factpr
lw = 1; % linewith
subplot(2,3,1:2)
p1 = plot(S1t, smooth(adjr2_s1(:, 1), sf), '-k', 'LineWidth', lw); hold on
p2 = plot(S1t, smooth(adjr2_s1(:, 2), sf), ':k', 'LineWidth', lw); hold on
p3 = plot(S1t, smooth(adjr2_s2(:, 1), sf),'-','Color', c1, 'LineWidth', lw);
p4 = plot(S1t, smooth(adjr2_s2(:, 2), sf),':','Color', c1, 'LineWidth', lw);
p5 = plot(S1t, smooth(adjr2_s3(:, 1), sf),'-','Color', c2, 'LineWidth', lw);
p6 = plot(S1t, smooth(adjr2_s3(:, 2), sf),':','Color', c2, 'LineWidth', lw);
p7 = plot(S1t, smooth(adjr2_s4(:, 1), sf),'-','Color', c3, 'LineWidth', lw);
p8 = plot(S1t, smooth(adjr2_s4(:, 2), sf),':','Color', c3, 'LineWidth', lw); 
% add scatter for each of these
sz = 25;
scatter(S1t(id), adjr2_s1(id, 2), sz, 'k', 'd', 'filled') 
scatter(S1t(id), adjr2_s2(id, 2), sz, c1, 'd', 'filled') 
scatter(S1t(id), adjr2_s3(id, 2), sz, c2, 'd', 'filled') 
scatter(S1t(id), adjr2_s4(id, 2), sz, c3, 'd', 'filled')
lg = legend([p1(1) p2(1) p3(1) p4(1) p5(1) p6(1) p7(1) p8(1)],'/1, Exp.', '/1, Linear', '/10, Exp.','/10, Linear',  '/20, Exp.',  '/20,Linear',...
    '/30, Exp.',  '/30,Linear','location', 'north', 'Orientation' ,'Horizontal') 
pos = lg.Position
lg.Position = pos +([+0.4 0.07 0 0])
ylim ([0 1])
ylabel ('R^2')
xlim([S1t(1) S1t(end)]);


subplot(2,3,3)
lw = 1.5
p0 = bar(nd, NumPixMeas, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor',[0.7 0.7 0.7]) ; hold on
p1 = plot(depth(:, 1),NumPixCalc(:,1),':', 'Color', 'k', 'linewidth', lw); hold on
p2 = plot(depth(:, 2),NumPixCalc(:,2),':', 'Color', c1, 'linewidth', lw); hold on
p3 = plot(depth(:, 3),NumPixCalc(:,3), ':','Color', c2, 'linewidth', lw); hold on
p4 = plot(depth(:, 4),NumPixCalc(:,4), ':','Color', c3, 'linewidth', lw); hold on
lg = legend([p0(1) p1(1) p2(1) p3(1) p4(1)], 'Measured', 'Res, Linear', '/10, Linear', '/20, Linear', '/30, Linear', 'Location', 'North');
pos = lg.Position;
lg.Position = pos +([0.1 0.01 0 0])
xlim([0 120])
ylabel ('Number of Pixels');
xlabel('Debris Thickness (cm)')
xticks ([0:25:100])

figname = 'Combo_Spatial_R2_Hist';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Table of fit
R2mean = nanmean([adjr2_s1,adjr2_s2,adjr2_s3,adjr2_s4])' ;
RMSEmean = nanmean([rmse_s1, rmse_s2, rmse_s3,  rmse_s4])';

R2min =min([adjr2_s1,adjr2_s2,adjr2_s3,adjr2_s4])' ;
RMSEmin = min([rmse_s1, rmse_s2, rmse_s3,  rmse_s4])';

R2max =max([adjr2_s1,adjr2_s2,adjr2_s3,adjr2_s4])' ;
RMSEmax = max([rmse_s1, rmse_s2, rmse_s3,  rmse_s4])';

VarName = {'Normal - exp';'Normal -lin';'/10- exp';'/10 -lin';'/20- exp';'/20 -lin'; '/30- exp';'/30 -lin'}
T = table (VarName, R2mean ,R2min, R2max, RMSEmean, RMSEmin, RMSEmax)
writetable(T, strcat(figdir, 'AjdR2_RMSE_SpatialRes.txt'))
