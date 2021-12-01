%% Calculatin debris thickness with less pits
% This code plots the correlation between debris thickness and surface
% tmeperature following 6 scenarios:

% scenario 1(norm): Regular
% scenario 2 (half): representative depth, but 1/2 pits (22)
% scenatio 3 (quart): represetative pit, but 1/4 pits (11)

% scenario 4 (shal): shallo pits 
% scenario 5 (med): medium pit
% scenario 6 (deep): deep pits

% the analysis is done in 2 steps: 
% first we calculate the r2 and rmse for all the images for
% all the scenarios with both the exp and linear regression
% then we extract the "best" performing regression image and analyse how
% the caluclate debris thickness compares with the measures distribution,
% and how a bias is introduced by the number of validation poinst 

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
ROI =double( ROI);
ROI(ROI==0)=nan;
TIRroi = TIR.*ROI;

%% Scenario 1: Business as usual 
for i = 1:length(TIRtime)
    clear x y
y = PitDepth(:, 2);
x = TPit(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end
% exp fit
[fit, gof] =expfit(x, y); % y = x*x + b
adjr2_norm(i, 1)=gof.rsquare;
rmse_norm(i, 1) = gof.rmse;
% Linear fit
[fit, gof] =poly1fit(x, y); % y = x*x + b
adjr2_norm(i, 2)=gof.rsquare;
rmse_norm(i, 2) = gof.rmse;
end 

%% Scenario 2: with random 1/2 pits
% first sort the pits, then select 1 out of 2
[PitDepthsrt, idsort] = sort(PitDepth(:,2));
TPit_srt = TPit(:,idsort);
id = 1:2:45;
TPit_half = TPit_srt(:, id);
PitDepth_half= PitDepthsrt(id);
hist(PitDepth_half)

for i = 1:length(TIRtime)
    clear x y
y = PitDepth_half;
x = TPit_half(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end
% exp fit
[fit, gof] =expfit(x, y); 
adjr2_half(i, 1)=gof.rsquare;
rmse_half(i, 1) = gof.rmse;
% Linear fit
[fit, gof] =poly1fit(x, y); % y = x*x + b
adjr2_half(i, 2)=gof.rsquare;
rmse_half(i, 2) = gof.rmse;
end 
%% Scenario 3: with 1/4 of pits (11)
[PitDepthsrt, idsort] = sort(PitDepth(:, 2));
TPit_srt = TPit(:,idsort);
id = 1:4:45;

TPit_quart = TPit_srt(:, id);
PitDepth_quart= PitDepthsrt(id);
hist(PitDepth_quart)

for i = 1:length(TIRtime)   
    clear x y
y = PitDepth_quart;
x = TPit_quart(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end
 % exp fit
[fit, gof] =expfit(x, y); % y = x*x + b
adjr2_quart(i, 1)=gof.rsquare;
rmse_quart(i, 1) = gof.rmse;
% lin fit
[fit, gof] =poly1fit(x, y); % y = x*x + b
adjr2_quart(i, 2)=gof.rsquare;
rmse_quart(i, 2) = gof.rmse;
end 
%%  Scenario 4: With only shallow
id = find(PitDepth(:, 2)<=35); % find(PitDepth>=50);
TPit_shal = TPit(:, id);
PitDepth_shal= PitDepth(id, 2);
numel(id)

for i = 1:length(TIRtime)
    clear x y fit_h
y = PitDepth_shal;
x = TPit_shal(i, :)';
a = find(isnan(x));% remove the nan, from section of image being out of view
x(a)=[];
y(a)=[];
  
[fit, gof] =expfit(x, y); % y = x*x + b
adjr2_shal(i, 1)=gof.rsquare;
rmse_shal(i, 1) = gof.rmse;

[fit, gof] =poly1fit(x, y); % y = x*x + b   
adjr2_shal(i, 2)=gof.rsquare;
rmse_shal(i, 2) = gof.rmse;
end 

%% Scenario 5: med
id = find(PitDepth(:, 2)>35 & PitDepth(:, 2)<=50 );
TPit_mid = TPit(:, id);
PitDepth_mid= PitDepth(id, 2);

for i = 1:length(TIRtime)
    clear x y
y = PitDepth_mid;
x = TPit_mid(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end
 
[fit, gof] =expfit(x, y); % y = x*x + b
adjr2_mid(i, 1)=gof.rsquare;
rmse_mid(i, 1) = gof.rmse;

[fit, gof] =poly1fit(x, y); % y = x*x + b   
adjr2_mid(i, 2)=gof.rsquare;
rmse_mid(i, 2) = gof.rmse;
end
%% Scenario 6: deep
id = find(PitDepth(:, 2)>50 );
TPit_deep = TPit(:, id);
PitDepth_deep= PitDepth(id, 2);
for i = 1:length(TIRtime)
    clear x y
y = PitDepth_deep;
x = TPit_deep(i, :)';
a = find(isnan(x));% remove the nan, from section of image being out of view
x(a)=[];
y(a)=[];

[fit, gof] =expfit(x, y); 
adjr2_deep(i, 1)=gof.rsquare;
rmse_deep(i, 1) = gof.rmse;

[fit, gof] =poly1fit(x, y); % 
adjr2_deep(i, 2)=gof.rsquare;
rmse_deep(i, 2) = gof.rmse;
end


%% Figure of pit distribution fo eahc catgeroy
% add lables, grid, and consistent bin size
close all
edge = [0:5:120];
figure('units','inches','position',[0 0 8 5]);
subplot(2,2,1)
h1 = histogram(PitDepth(:, 2), edge,  'FaceColor', [0.5 0.5 0.5], 'FaceAlpha', 1);xlim([0 120]);  ylim([0 7])
legend ('All')
text (3, 6.5, '(a)')
ylabel ('Number of Manual Excavation'); xlabel ('Debris Thickness (cm)')

subplot(2,2,2)
h2 = histogram(PitDepth_half, edge,  'FaceColor', [0.5 0.5 0.5], 'FaceAlpha', 1);xlim([0 120]);  ylim([0 7])
legend ('Half')
ylabel ('Number of Manual Excavation'); xlabel ('Debris Thickness (cm)')
text (3, 6.5, '(b)')

subplot(2,2,3)
h3 = histogram(PitDepth_quart, edge,  'FaceColor', [0.5 0.5 0.5], 'FaceAlpha', 1);xlim([0 120]); ylim([0 7])
legend ('Quarter')
ylabel ('Number of Manual Excavation'); xlabel ('Debris Thickness (cm)')
text (3, 6.5, '(c)')

subplot(2,2,4)
histogram(PitDepth_shal, edge, 'FaceColor', c1);xlim([0 120]); ylim([0 7]); hold on
histogram(PitDepth_mid, edge, 'Facecolor', c2);xlim([0 120]); ylim([0 7])
histogram(PitDepth_deep, edge, 'Facecolor', c3);
xlim([0 120]); ylim([0 7])
legend ('Shallow', 'Med', 'Deep')
ylabel ('Number of Manual Excavation'); xlabel ('Debris Thickness (cm)')
text (3, 6.5, '(d)')
figname = 'Hist_PitDistribution';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Table of mean R and rmse for eahc type
% 12 column
AJDR2mean = nanmean([adjr2_norm,adjr2_half,adjr2_quart,adjr2_shal,adjr2_mid,adjr2_deep])' ;
RMSEmean = nanmean([rmse_norm, rmse_half, rmse_quart,  rmse_shal, rmse_mid, rmse_deep])';

AJDR2min =min([adjr2_norm,adjr2_half,adjr2_quart,adjr2_shal,adjr2_mid,adjr2_deep])';
RMSEmin = min([rmse_norm, rmse_half, rmse_quart,  rmse_shal, rmse_mid, rmse_deep])';

AJDR2max =max([adjr2_norm,adjr2_half,adjr2_quart,adjr2_shal,adjr2_mid,adjr2_deep])';
RMSEmax = max([rmse_norm, rmse_half, rmse_quart,  rmse_shal, rmse_mid, rmse_deep])';

VarName = {'Normal - exp';'Normal -lin';'Half- exp';'Half -lin';'Quarter- exp';'Quarter -lin';...
    'Shallow- exp';'Shallow -lin';'Medium- exp';'Medium -lin';'Deep- exp';'Deep -lin'}
T = table (VarName, AJDR2mean , AJDR2min, AJDR2max, RMSEmean, RMSEmin, RMSEmax)
writetable(T, strcat(figdir, 'AjdR2_RMSE_LessPits.txt'))

%% Id timestep of good corelation
id_all= find(TIRtime  == '8-Aug-2019 4:00:02');% lin
id_shal= find(TIRtime  == '7-Aug-2019 12:50:02');% lin
id_deep = find(TIRtime  == '7-Aug-2019 18:30:02');% lin
id_mid = find(TIRtime  == '8-Aug-2019 8:20:02');% lin
id_norm = find(TIRtime  == '8-Aug-2019 4:00:02');% lin
%% Select only ID time step of interest

TPit_select =     {TPit;    TPit_half;   TPit_quart;    TPit_shal;     TPit_mid;     TPit_deep};
PitDepth_select = {PitDepth(:, 2);PitDepth_half;PitDepth_quart;  PitDepth_shal; PitDepth_mid;PitDepth_deep};

id = [id_all, id_all, id_all, id_shal, id_mid, id_deep]
%% Calculate fit 
for i = 1:length(id)
y = PitDepth_select{i};
x1 = TPit_select{i};
x = x1(id(i), :)';
a = find(isnan(x));% remove the nan, from section of image being out of view
x(a)=[];
y(a)=[];
X = reshape(TIRroi(:,:,id(i)), 351*1000, 1); X(X<-50)=nan;

if i == 1 | i == 4
[fit, gof] =poly1fit(x, y); % 
else
[fit, gof] =expfit(x, y); % 
end 

adjr2_best(i)=gof.rsquare;
rmse_best(i) = gof.rmse;
yfit_IR = feval(fit, X);
TIRfit_best(:,:, i) = reshape(yfit_IR , 351, 1000);  
end 

%% Plot caluclate debris ticnkness
load('D:\2_IRPeyto\b_data_process\parameter\PitLocation_TIR.mat')
PitLocation_TIR(17,:)=nan; % pit 17 is out of view
PitLocIDX = PitLocation_TIR;

id_pitloc{1} =[1:45]
id_pitloc{2} =idsort(1:2:45);
id_pitloc{3} =idsort(1:4:45);
id_pitloc{4} = find(PitDepth(:, 2)<=35); % find(PitDepth>=50);
id_pitloc{5}= find(PitDepth(:, 2)>35 & PitDepth(:, 2)<=50 );
id_pitloc{6}= find(PitDepth(:, 2)>50 );

header ={'(a) All';'(b) Half';'(c) Quarter';'(d) Shallow';'(e) Med';'(f) Deep'};
f = figure('units','inches','position',[0 0 8 5]);
cmap = parula(256);
% Make lowest one black
cmap(1,:) = 1;
for i = 1:length(id_pitloc)
 subplot(2,3,i)
    imagesc(TIRfit_best(:,:,i)); hold on
    text(25, 25, header(i))
    caxis([0 130])
    colormap(cmap)
    scatter(PitLocIDX(id_pitloc{i}, 2),PitLocIDX(id_pitloc{i},1),8, 'ok')
if i == 3 | i == 6
     cb = colorbar;
     set(cb, 'Ytick', [0:20:120]);
     ylabel(cb, 'Debris Thickness (cm)')
     cb.Position = cb.Position+[0.08 0 0 0]
end   
xticklabels ([])
yticklabels([])
end 
%
% move suplot
clear h sp1
h=get(f,'children');
sp1 = h(2);
sp1.Position = sp1.Position .*[0.92 1 1.2 1.1]
sp1 = h(3);
sp1.Position = sp1.Position .*[0.9 1 1.2 1.1]
sp1 = h(4);
sp1.Position = sp1.Position .*[0.8 1 1.2 1.1]
sp1 = h(6);
sp1.Position = sp1.Position .*[0.92 0.85 1.2 1.1]
sp1 = h(7);
sp1.Position = sp1.Position .*[0.9 0.85 1.2 1.1]
sp1 = h(8);
sp1.Position = sp1.Position .*[0.8 0.85 1.2 1.1]
% legends
sp1 = h(5);
sp1.Position = sp1.Position .*[1 0.85 1.1 1.1]
sp1 = h(1);
sp1.Position = sp1.Position .*[1 1 1.1 1.1]

%
figname = 'Calculated_DT_ValidationPoints';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% distribution of pixel for each
DepthInterpROI = DepthInterp.*ROI;
DepthInterpROI(DepthInterpROI<0) = nan;
DepthInterpROI_reshape = reshape(DepthInterpROI, 1, 351:100);
DepthInterpROI_reshape(DepthInterpROI_reshape<=0)=nan;

bins = [0:5:120]; % bin edges
[NumPixMeas, nd]=hist(DepthInterpROI_reshape,bins);
for i = 1:length(id)
I = reshape(TIRfit_best(:,:,i), 351*1000,1);
[NumPixCalc(:, i),depth(:, i)]=hist(I,bins);
end

%% Plot time seris and histogram together
figure('units','inches','position',[0 0 8 6]);
sf = 12; % smooth factpr
lw = 1; % linewith
subplot(2,3,1:2)
plot(TIRtime, smooth(adjr2_norm(:, 1), sf), '-k', 'LineWidth', lw); hold on
plot(TIRtime, smooth(adjr2_norm(:, 2), sf), ':k', 'LineWidth', lw); hold on
plot(TIRtime, smooth(adjr2_half(:, 1), sf),'-','Color', c1, 'LineWidth', lw); 
plot(TIRtime, smooth(adjr2_half(:, 2), sf),':','Color', c1, 'LineWidth', lw); 
plot(TIRtime, smooth(adjr2_quart(:, 1), sf),'-','Color', c2, 'LineWidth', lw); 
plot(TIRtime, smooth(adjr2_quart(:, 2), sf),':','Color', c2, 'LineWidth', lw); 
grid on
% add scatter for each of these
sz = 35;
scatter(TIRtime(id_all), adjr2_norm(id_all, 2), sz, 'k', 'd', 'filled') 
scatter(TIRtime(id_all), adjr2_half(id_all, 1), sz, c1, 'd', 'filled') 
scatter(TIRtime(id_all), adjr2_quart(id_all, 1), sz, c2, 'd', 'filled') 

lg1 = legend ('All, exp', 'All, lin', 'Half, exp','Half,lin',  'Quarter, exp',  'Quarter,lin', 'location', 'northeast', 'orientation', 'horizontal') 
pos = lg1.Position;
lg1.Position = pos +([0.27 0.07 0 0]);
ylim ([0 1])
ylabel ('R^2')
xlim([TIRtime(1) TIRtime(end)]);
xticks([datetime('05-Aug-2019 18:00:00'):hours(6):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
xtickangle (30)

subplot(2,3,4:5)
p1 = plot(TIRtime, smooth(adjr2_norm(:, 1), sf), '-k', 'LineWidth', lw); hold on
p2 = plot(TIRtime, smooth(adjr2_norm(:, 2), sf), ':k', 'LineWidth', lw); hold on
p3 = plot(TIRtime, smooth(adjr2_shal(:, 1), sf),'-','Color', c1, 'LineWidth', lw); 
p4 = plot(TIRtime, smooth(adjr2_shal(:, 2), sf),':','Color', c1, 'LineWidth', lw); 
p5 = plot(TIRtime, smooth(adjr2_mid(:, 1), sf),'-','Color', c2, 'LineWidth', lw); 
p6 = plot(TIRtime, smooth(adjr2_mid(:, 2), sf),':','Color', c2, 'LineWidth', lw); 
p7 = plot(TIRtime, smooth(adjr2_deep(:, 1), sf),'-','Color', c3, 'LineWidth', lw); 
p8 = plot(TIRtime, smooth(adjr2_deep(:, 2), sf),':','Color', c3, 'LineWidth', lw); 
scatter(TIRtime(id_norm), adjr2_norm(id_norm, 2), sz, 'k', 'd', 'filled');
scatter(TIRtime(id_shal), adjr2_shal(id_shal, 2),sz, c1, 'd', 'filled');
scatter(TIRtime(id_mid), adjr2_mid(id_mid, 1), sz, c2, 'd', 'filled');
scatter(TIRtime(id_deep), adjr2_deep(id_deep, 1), sz, c3, 'd', 'filled');
ylim ([0 1])
lg2 = legend ([p1(1) p2(1) p3(1) p4(1) p5(1) p6(1) p7(1) p8(1)], 'All, exp', 'All, lin', 'Shallow, exp','Shallow, lin', 'Med, exp', 'Med, lin', 'Deep, exp','Deep, lin', 'location', 'northeast', 'orientation', 'horizontal') 
pos = lg2.Position;
lg2.Position = pos +([0.4 0.05 0 0]);
ylabel ('R^2')
xlim([TIRtime(1) TIRtime(end)]);
xticks([datetime('05-Aug-2019 18:00:00'):hours(6):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
xtickangle (30)
grid on

subplot(2,3,3)
p0 = bar(nd, NumPixMeas, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor',[0.7 0.7 0.7]) ; hold on
p1 = plot(depth(:, 1),NumPixCalc(:,1), ':','Color', 'k',  'linewidth', 1.2); hold on
p2 = plot(depth(:, 2),NumPixCalc(:,2), 'Color', c1, 'linewidth', 1.2); hold on
p3 = plot(depth(:, 3),NumPixCalc(:,3), 'Color', c2, 'linewidth', 1.2); hold on
lg3 = legend([p0(1) p1(1) p2(1) p3(1)], 'Measured', 'All', 'Half', 'Quart', 'location', 'north')
pos = lg3.Position;
lg3.Position = pos +([0.09 0.01 0 0]);
xlim([0 120])
ylabel ('Number of Pixels');
xlabel('Debris Thickness (cm)')
xticks ([0:25:100])

subplot(2,3,6)
p0 = bar(nd, NumPixMeas, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor',[0.7 0.7 0.7]) ; hold on
p1 = plot(depth(:, 1),NumPixCalc(:,1), ':','Color', 'k', 'linewidth', 1.2); hold on
p4 = plot(depth(:, 4),NumPixCalc(:,4), ':','Color', c1, 'linewidth', 1.2); hold on
p5 = plot(depth(:, 5),NumPixCalc(:,5), 'Color', c2, 'linewidth', 1.2); hold on
p6 = plot(depth(:, 6),NumPixCalc(:,6), 'Color', c3, 'linewidth', 1.2); hold on
lg4 = legend([p0(1) p1(1) p4(1) p5(1) p6(1)], 'Measured', 'All', 'Shallow', 'Mid', 'Deep', 'location', 'north')
pos = lg4.Position;
lg4.Position = pos +([0.09 0.01 0 0]);
xlim([0 120])

% ylim([0 3.6e4]); xlim([0 120])
ylabel ('Number of Pixels');
xlabel('Debris Thickness (cm)')
xticks ([0:25:100])

figname = 'Combi_TS_Hist_perValidationPoints';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Plot rmse as supplementary

%% figure rmse
figure('units','inches','position',[0 0 8 5]);
sf = 12; % smooth factpr
lw = 1; % linewith
subplot(2,1,1)
plot(TIRtime, smooth(rmse_norm(:, 1), sf), '-k', 'LineWidth', lw); hold on
plot(TIRtime, smooth(rmse_norm(:, 2), sf), ':k', 'LineWidth', lw); hold on
plot(TIRtime, smooth(rmse_half(:, 1), sf),'-','Color', c1, 'LineWidth', lw); 
plot(TIRtime, smooth(rmse_half(:, 2), sf),':','Color', c1, 'LineWidth', lw); 
plot(TIRtime, smooth(rmse_quart(:, 1), sf),'-','Color', c2, 'LineWidth', lw); 
plot(TIRtime, smooth(rmse_quart(:, 2), sf),':','Color', c2, 'LineWidth', lw); 
legend ('All, Exp. ', 'All, Linear', 'Half, Exp.','Half, Linear', 'Quarter, Exp.', 'Quarter, Linear','location', 'eastoutside') 
ylabel ('RMSE (cm)')
xlim([TIRtime(1) TIRtime(end)]);

subplot(2,1,2)
plot(TIRtime, smooth(rmse_norm(:, 1), sf), '-k', 'LineWidth', lw); hold on
plot(TIRtime, smooth(rmse_norm(:, 2), sf), ':k', 'LineWidth', lw); hold on
plot(TIRtime, smooth(rmse_shal(:, 1), sf),'-','Color', c1, 'LineWidth', lw); 
plot(TIRtime, smooth(rmse_shal(:, 2), sf),':','Color', c1, 'LineWidth', lw); 
plot(TIRtime, smooth(rmse_mid(:, 1), sf),'-','Color', c2, 'LineWidth', lw); 
plot(TIRtime, smooth(rmse_mid(:, 2), sf),':','Color', c2, 'LineWidth', lw); 
plot(TIRtime, smooth(rmse_deep(:, 1), sf),'-','Color', c3, 'LineWidth', lw); 
plot(TIRtime, smooth(rmse_deep(:, 2), sf),':','Color', c3, 'LineWidth', lw); 
legend ('All, Exp. ', 'All, Linear', 'Shallow, Exp.','Shallow, Linear', 'Med, Exp.', 'Med, Linear', 'Deep, Exp.','Deep, Lin', 'location', 'eastoutside') 
ylabel ('RMSE (cm)')
xlim([TIRtime(1) TIRtime(end)]);

figname = 'RMSE_perValidationPoints_Linear_Exp';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')





