% C2 - Linear vs Exponential Correlation with Poor, Avg and Good scatter
% plot
% Caroline Aubry-Wake
% edited 2021-06-07

% This code plots the correlation between debris thickness and surface
% tmeperature following the two main type of fit: linar and epxoential

%% Set-Up
clear all
close all
cd ('D:\2_IRPeyto')
figdir='D:\2_IRPeyto\e_fig\correlation_linear_exp\'
addpath('D:\2_IRPeyto\d_function')

%% Load Variables
%TIR imagery and surfce temp at pit location
load('D:\2_IRPeyto\b_data_process\TIR_process\MatImage_McGill\McGill_TIR_time_name.mat', 'TIRtime')
load('D:\2_IRPeyto\b_data_process\TIR_process\RegisteredImage_McGill\McGill_TIR_Reg_Crop.mat')
TIR = Rcrop(:,:,2:1078)-273.15;
clear Rcrop

% Pit surface temperature
load('D:\2_IRPeyto\b_data_process\Pit_process\TIRtemperature_atpitlocation.mat')
TPit =TIRtemperature_atpitlocation-273.15; % change name
TPit=TPit(2:1078, :);% remove first and last value
TIRtime = TIRtime(2:1078);

 % Pit location and depth
load('b_data_process\Pit_process\ExcavationLocation_TIR.mat')
D = importdata('a_data_raw\excavation\ManualExcavationDepth.csv');
PitDepth = D.data;
clear D

% interpolated debris thickness
load('D:\2_IRPeyto\b_data_process\Pit_process\DebrisThickness_interpolated_studyslope.mat')

% Study Slope
load('D:\2_IRPeyto\b_data_process\Pit_process\ROIstudyslope.mat')
ROI =double(ROI);
ROI(ROI==0)=nan;
TIRroi = TIR.*ROI;
DepthInterpROI = DepthInterp.*ROI;
DepthInterpROI(DepthInterpROI<0) = nan;
DepthInterpROI_reshape = reshape(DepthInterpROI, 1, 351:100);
DepthInterpROI_reshape(DepthInterpROI_reshape<=0)=nan;
Depth_meanmeas = nanmean(DepthInterpROI_reshape); 

% color
 c1 = [0 0 204]./255;   % blue
 c2 = [255 128 0]./255; % orange
 
 % calculate significance
 for i = 1:length(TPit)
    [r, p] = corrcoef(PitDepth(:, 2), TPit(i, :),'rows', 'pairwise');
    R(i) = r(2);
    P(i) = p(2);
 end 
nonsign = find(P>0.05);

% ID for good, average and poor goodness of fit
tgood = find(TIRtime == '9-Aug-2019 7:50:02')
taverage = find(TIRtime == '8-Aug-2019 18:00:02')
tpoor  = find(TIRtime == '8-Aug-2019 12:00:02')
id = [tgood,taverage, tpoor];
%% Calculate goodness of fit for all the timestep
for i = 1:length(TPit)
    clear x y
y = PitDepth(:, 2);
x = TPit(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end

% Exponential Fit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[fit, gof] =expfit(x, y); % y = a^(bx)
 exp_coeff(i, :)=coeffvalues(fit);
 
% Exponential fit applied to the pit data
     yfit = feval(fit, x);
     yfit1=yfit;
     [r,c] = size(yfit); 
     add  = numel(n); 
     yn = NaN(r + add,c); 
     idx  = setdiff(1:r+add,n);   
     yn(idx,:) = yfit1;
     Yfitexp(:, i) = yn;
     
% Exponential fit applied to the TIR image
         X = reshape(TIRroi(:,:,i), 351*1000, 1);
         X(X<-50)=nan;
         yfit_IR = feval(fit, X);
         TIRfit_exp(:,:,i) = reshape(yfit_IR , 351, 1000);  

% extract Statictics
RSQUARE(i, 1)=gof.rsquare;
RMSE(i, 1) = gof.rmse;
[a, pval]= corrcoef(PitDepth(:, 2),  Yfitexp(:, i), 'rows', 'pairwise');
PVAL(i, 1) = pval(2);

% Linear fit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[fit, gof] =poly1fit(x, y); % y = a*x + b
lin_coeff(i, :)=coeffvalues(fit);

% Linar applied to the pit data
     yfit = feval(fit, x);
     yfit1=yfit;
     [r,c] = size(yfit); 
     add  = numel(n); 
     yn = NaN(r + add,c); 
     idx  = setdiff(1:r+add,n);   
     yn(idx,:) = yfit1;
     Yfitexp(:, i) = yn;
 
% Linear fit to the TIR image
      X = reshape(TIRroi(:,:,i), 351*1000, 1);
      X(X<-50)=nan;
      yfit_IR = feval(fit, X);
      TIRfit_lin(:,:,i) = reshape(yfit_IR , 351, 1000); 
         
RSQUARE(i, 2)=gof.rsquare;
RMSE(i, 2) = gof.rmse;
[a, pval]= corrcoef(PitDepth(:, 2),  Yfitexp(:, i), 'rows', 'pairwise');
PVAL(i, 2) = pval(2);
end

%% Plot gododness of fit timeseries
figure('units','inches','position',[0 0 6 5]);
sb1 = subplot(2,1,1); hold on
l = line([TIRtime(nonsign) TIRtime(nonsign)], [0 1], 'Color',[0.8 .8 .8])
p1 = plot(TIRtime, smooth(RSQUARE(:, 1), 6), 'linewidth', 1, 'color',c1); hold on
p2 = plot(TIRtime, smooth(RSQUARE(:, 2), 6), 'linewidth', 1, 'color', c2); hold on
ylabel ('R^2')
xlim([TIRtime(1) TIRtime(end)])
ylim ([0 1])
xticks([datetime('05-Aug-2019 18:00:00'):hours(6):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
xtickangle (30)
xticklabels([])
box on
grid on
pos = get(sb1, 'Position');
posnew = pos; posnew(2) = posnew(2)+0.04; set(sb1, 'Position', posnew);
scatter(TIRtime(id), ones(length(TIRtime(id)), 1).* RSQUARE(id, 1), 35, 'kd', 'filled')
legend ([p1(1) p2(1)], 'y =a^{bx}', 'y = ax+b', 'location', 'Northwest' , 'orientation', 'horizontal')

sb2 = subplot(2,1,2); hold on
l = line([TIRtime(nonsign) TIRtime(nonsign)], [10 30], 'Color',[0.8 .8 .8])
p1 = plot(TIRtime, smooth(RMSE(:, 2), 6), 'linewidth', 1, 'color', c1); hold on
p2 = plot(TIRtime, smooth(RMSE(:, 1), 6), 'linewidth', 1, 'color', c2); hold on
ylabel ('RMSE (cm)')
xlim([TIRtime(1) TIRtime(end)])
ylim ([10 23])
xticks([datetime('05-Aug-2019 18:00:00'):hours(6):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
xtickangle (30)
box on; grid on
pos = get(sb2, 'Position');
posnew = pos; posnew(2) = posnew(2)+0.15; set(sb2, 'Position', posnew);
scatter(TIRtime(id), ones(length(TIRtime(id)), 1).* RMSE(id, 1), 35, 'kd', 'filled')
 
figname = 'DebrisTempFit_R2_RMSE_LinearExp_timeseries';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Curve fitting for linear and power for the three timestep
close all
figure('units','inches','position',[0 0 6 2]);
lab = {'(a) ';'(b) ';'(c) '};
for i = 1:length(id)
    clear x y
y = PitDepth(:, 2);
x = TPit(id(i), :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end

 %%%%%%%%%%%%%%%%% Exponential fit 
[fitexp, gof] = expfit(x, y); % y = a^(bx}
r2_exp(i, 1)=gof.rsquare;
rmse_exp(i, 1) = gof.rmse;

%%%%%%%%%%%%%%%%%%% Linear fit
[fitlin, gof] =poly1fit(x, y); % y = a*x + b
r2_lin(i, 1)=gof.rsquare;
rmse_lin(i, 1) = gof.rmse;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot scatter 
figure(1)
        subplot(1,3,i)
        p1 =  plot(fitexp, x, y); hold on
        p1(1).Color = 'k'; p1(2).Color = c1;
        p2 =  plot(fitlin, x, y); hold on
        p2(1).Color = 'k'; p2(2).Color = c2;
        p2(2).LineWidth =1; p1(2).LineWidth =1;
        
% Text
       text(min(x)-0.5, 138, strcat(lab{i},{' '}, datestr(TIRtime(id(i)), 'dd-mmm, HH:MM')), 'FontSize', 10)
       text(min(x)-0.5, 124, strcat('R^2:', num2str(round(r2_exp(i),2)), ...
           ', RMSE:', num2str(round(rmse_exp(i),1))), 'Color', c1, 'FontSize', 9)
       text(min(x)-0.5, 112, strcat('R^2:', num2str(round(r2_lin(i),2)), ...
            ', RMSE:', num2str(round(rmse_lin(i),1))), 'Color', c2, 'FontSize',9)
% Figure layout
  ylim([0 130]); xlim ([min(x)-1 max(x)+1]);
  box on; grid on;
  
lg= legend ([p1(2) p2(2)], 'y = a^{bx}','y = ax+b', 'Location', 'south', 'Orientation','Vertical')
lg.FontSize = 8;
  if i > 1
   legend off;
  end
  
  xlabel('TIR temperature ({\circ}C)', 'FontSize',10)
 if i == 1 
    ylabel('Debris Thickness (cm)', 'FontSize',10)
 else 
     ylabel('')
 end 
end

% Save the scatter plot figure
figname = 'Scatter_DebrisTempFit_Linear_Exp_GoodAvgPoor';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')
 
%% Histogram for the entire image for thr 3 time step
figure('units','inches','position',[0 0 7 2]);
bins = [0:5:120]; % bin edges
[numpix_meas, nd]=hist(DepthInterpROI_reshape,bins);

for i = 1:length(id);
subplot(1,3,i)
 Ir = reshape(TIRfit_exp(:,:,id(i)), 351*1000,1);
 MAE_exp(i) = mae(DepthInterpROI_reshape-Ir');
[numpix_exp,depth]=hist(Ir,bins);
 p3 = bar(nd, numpix_meas, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor',[0.7 0.7 0.7]) ; hold on

Ir = reshape(TIRfit_lin(:,:,id(i)), 351*1000,1);
[numpix_lin,depth]=hist(Ir,bins);
p2 = plot(depth,numpix_lin, 'Color', c2, 'linewidth', 1.2)
p1 = plot(depth,numpix_exp, 'Color', c1, 'linewidth', 1.2)

if i == 1
 legend ([p3(1) p1(1) p2(1) ], 'Measured', 'y = a^{bx}','y = ax+b')
else
    legend off
end 
 ylim([0 5e4]);xlim([0 120])
        title (datestr(TIRtime(id(i)), 'dd-mmm, HH:MM'), 'FontWeight', 'normal');     
        text(1, 4.8e4, strcat('R^2:', num2str(round(r2_exp(i),2)),',RMSE:', num2str(round(rmse_exp(i),1))), 'Color', c1, 'FontSize', 10)
        text(1, 4.3e4, strcat('R^2:', num2str(round(r2_lin(i),2)),',RMSE:', num2str(round(rmse_lin(i),1))), 'Color', c2, 'FontSize', 10)
 if i == 1 || i == 5
    ylabel('Number of Pixel')
 else 
     ylabel('')
 end 
 if i > 4
        xlabel('Debris thickness (cm)')
 else xlabel ('');
 end 
end

figname = 'DebrisTempFit_Linear_Exp_Histogram';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure - P values
figure('units','inches','position',[0 0 6 3]);
p1 = plot(TIRtime, smooth(PVAL(:, 1), 6), 'linewidth', 1, 'color',c1); hold on
p2 = plot(TIRtime, smooth(PVAL(:, 2), 6), 'linewidth', 1, 'color', c2); hold on
ylabel ('p-value')
xlim([TIRtime(1) TIRtime(end)])
ylim ([0 0.05])
xticks([datetime('05-Aug-2019 18:00:00'):hours(6):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
xtickangle (30)
box on
grid on
scatter(TIRtime(id), ones(length(TIRtime(id)), 1).* PVAL(id,1), 20, 'kd', 'filled')
legend ([p1(1) p2(1)], 'y =a^{xb}', 'y = ax+b', 'location', 'Northwest' , 'orientation', 'horizontal')
figname = 'TimeSeries_DebrisTempFit_PVal_Linear_Exp';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Figure - coefficient
figure('units','inches','position',[0 0 8 5]);
subplot(2,2,1)
p1 = plot(TIRtime, smooth(exp_coeff(:, 1), 6), 'linewidth', 1, 'color',c1); hold on
ylabel ('a coefficient, exp. model')
xlim([TIRtime(1) TIRtime(end)])
xticks([datetime('05-Aug-2019 18:00:00'):hours(12):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
xticklabels ([])
 xtickangle (30)
box on
grid on
scatter(TIRtime(id), ones(length(TIRtime(id)), 1).* exp_coeff(id, 1), 20, 'kd', 'filled')
subplot(2,2,2)
p2 = plot(TIRtime, smooth(exp_coeff(:, 2), 6), 'linewidth', 1, 'color',c1); hold on
ylabel ('b coefficient, exp. model')
xlim([TIRtime(1) TIRtime(end)])
xticks([datetime('05-Aug-2019 18:00:00'):hours(12):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
xticklabels ([])
% xtickangle (30)
box on
grid on
scatter(TIRtime(id), ones(length(TIRtime(id)), 1).* exp_coeff(id, 2), 20, 'kd', 'filled')

%linear
p3 = subplot(2,2,3)
plot(TIRtime, smooth(lin_coeff(:, 1), 6), 'linewidth', 1, 'color',c2); hold on
ylabel ('a coefficient, lin. model')
xlim([TIRtime(1) TIRtime(end)])
xticks([datetime('05-Aug-2019 18:00:00'):hours(12):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
 xtickangle (30)
box on
grid on
scatter(TIRtime(id), ones(length(TIRtime(id)), 1).* lin_coeff(id, 1), 20, 'kd', 'filled')

 pos = get(p3, 'Position') 
 posnew = pos; posnew(2) = posnew(2) + 0.1; set(p3, 'Position', posnew)
 
p4=subplot(2,2,4)
plot(TIRtime, smooth(lin_coeff(:, 2), 6), 'linewidth', 1, 'color',c2); hold on
ylabel ('b coefficient, lin. model')
xlim([TIRtime(1) TIRtime(end)])
xticks([datetime('05-Aug-2019 18:00:00'):hours(12):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
 xtickangle (30)
box on
grid on
scatter(TIRtime(id), ones(length(TIRtime(id)), 1).* lin_coeff(id,2), 20, 'kd', 'filled')
 pos = get(p4, 'Position') 
 posnew = pos; posnew(2) = posnew(2) + 0.1; set(p4, 'Position', posnew)
 
figname = 'TimeSeries_DebrisTempFit_Coeff_Linear_Exp';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Histogram of distribution with image for good, average and poor
bins = [0:5:120]; % bin edges
[NumPixMeas, nd]=hist(DepthInterpROI_reshape,bins);
I = reshape(TIRfit_lin(:,:,id(1)), 351*1000,1);
[NumPixGood,depth]=hist(I,bins);
I = reshape(TIRfit_exp(:,:,id(2)), 351*1000,1);
[NumPixAvg,depth]=hist(I,bins);
I = reshape(TIRfit_exp(:,:,id(3)), 351*1000,1);
[NumPixPoor,depth]=hist(I,bins);

%% Figure of modleled distributed thickness with histogram
f1 = figure(1)
f1.Units = 'inches'
f1.Position = [0 0 8 4];
sb1 = subplot (2,3,1)
imagesc(TIRfit_lin(:,:,id(1))); caxis([0 120]); 
xticklabels([]); yticklabels ([])
cmap=[1 1 1;parula(200)];% add black for the lowest values
colormap(cmap);
loc = sb1.Position;
loc = loc + [+0.03 0 0 0];
sb1.Position = loc;
text (10, 24, '(a) 7:55, Aug. 9', 'Color', 'k')
text(10, 320,  strcat('R^2:', num2str(round(r2_lin(1),2)), ...
                   ', RMSE:', num2str(round(rmse_lin(1),1))), 'Color', c1, 'FontSize', 9)
               
sb2 = subplot (2,3,2)
imagesc(TIRfit_exp(:,:,id(2))); caxis([0 120]); 
xticklabels([]); yticklabels ([])
loc = sb2.Position;
loc = loc + [0 0 0 0];
sb2.Position = loc;
text (10, 24, '(b) 20:00, Aug. 8', 'Color', 'k')
text(10, 320,  strcat('R^2:', num2str(round(r2_exp(2),2)), ...
                   ', RMSE:', num2str(round(rmse_exp(2),1))), 'Color', c2, 'FontSize', 9)
sb3 = subplot (2,3,3)
imagesc(TIRfit_exp(:,:,id(3))); caxis([0 120]); cb = colorbar
cbP = cb.Position;
cb.Position = cbP+[0.05 0 0 0];
cb.Ticks = [0:25:100]
cb.LineWidth = 0.5;
cb.TickLength = 0.03;
ylabel(cb, 'Debris Thickness (cm)', 'FontSize', 10)
xticklabels([]); yticklabels ([])
xticklabels([]); yticklabels ([])
loc = sb3.Position;
loc = loc + [-0.03 0 0 0];
sb3.Position = loc;
text (10, 24, '(c) 12:00, Aug. 8', 'Color', 'k')
text(10, 320,  strcat('R^2:', num2str(round(r2_exp(3),2)), ...
                   ', RMSE:', num2str(round(rmse_exp(3),1))), 'Color', c2, 'FontSize', 9)

               sb4 = subplot (2,3,4)
p3 = bar(nd, NumPixMeas, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor',[0.7 0.7 0.7]) ; hold on
p1 = plot(depth,NumPixGood, 'Color', c1, 'linewidth', 1.2); hold on
ylim([0 3.6e4]); xlim([0 120])
ylabel ('Number of Pixels');
xlabel('Debris Thickness (cm)')
loc = sb4.Position;
loc = loc + [+0.03 0.07 0 0];
sb4.Position = loc;
xticks ([0:25:100])
text (2, 3.3e4, '(d) 6:45, Aug. 9', 'Color', 'k')
lg = legend ('Measured', 'Modelled', 'Location', 'NorthWest')
lgPos = lg.Position;
lg.Position = lgPos+[-0.01 -0.02 0 0]

sb5 = subplot (2,3,5)
p3 = bar(nd, NumPixMeas, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor',[0.7 0.7 0.7]) ; hold on
p1 = plot(depth,NumPixAvg, 'Color', c2, 'linewidth', 1.2); hold on
ylim([0 3.6e4]); xlim([0 120])
xlabel('Debris Thickness (cm)')
loc = sb5.Position;
loc = loc + [0 0.07 0 0];
sb5.Position = loc;
xticks ([0:25:100])
text (2, 3.3e4, '(e) 20:00, Aug. 8', 'Color', 'k')

sb6 = subplot (2,3,6)
p3 = bar(nd, NumPixMeas, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor',[0.7 0.7 0.7]) ; hold on
p1 = plot(depth,NumPixPoor, 'Color', c2, 'linewidth', 1.2); hold on
ylim([0 3.6e4]); xlim([0 120])
xlabel('Debris Thickness (cm)')
loc = sb6.Position;
loc = loc + [-0.03 0.07 0 0];
sb6.Position = loc;
xticks ([0:25:100])
text (2, 3.3e4, '(f) 12:00, Aug. 8', 'Color', 'k')

figname = 'CalculatedDebris_GoodAvgPoor_TIR_Hist';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Quick assessment of cooling and heating rate
% full triangle figure is in supp,ementary script

% Cooling rate
t1 = find(TIRtime == '7-Aug-2019 14:00:02');
t2 = find(TIRtime == '8-Aug-2019 16:00:02');

T = TPit(t2, :) - TPit(t1, :);
r = corrcoef(T,PitDepth(:, 2) , 'rows', 'pairwise');
R_16 = r(2)

t2 = find(TIRtime == '7-Aug-2019 18:00:02');
T = TPit(t2, :) - TPit(t1, :);
r = corrcoef(T,PitDepth (:, 2), 'rows', 'pairwise');
R_18 = r(2)

t2 = find(TIRtime == '8-Aug-2019 20:00:02');
T = TPit(t2, :) - TPit(t1, :);
r = corrcoef(T,PitDepth(:, 2) , 'rows', 'pairwise');
R_20 = r(2)

t2 = find(TIRtime == '7-Aug-2019 22:00:02');
T = TPit(t2, :) - TPit(t1, :);
r = corrcoef(T,PitDepth (:, 2), 'rows', 'pairwise');
R_22 = r(2)

