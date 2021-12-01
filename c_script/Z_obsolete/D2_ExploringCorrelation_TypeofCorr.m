%% D2 - Type of correlation between Debris thickness and surface temperature
% Caroline Aubry-Wake
% edited 2021-06-07

% this code calculates the correlation (and significance) between the surface tmeperature at
% the pit location and the debric thicnkess, for five type of equations
%% Set-Up
clear all
close all
cd ('D:\2_IRPeyto')
figdir='D:\2_IRPeyto\e_fig\correlation\'

%% Load Variables
load('D:\2_IRPeyto\b_data_process\TIR_process\MatImage_McGill\McGill_TIR_time_name.mat', 'TIRtime')
load('D:\2_IRPeyto\b_data_process\Pit_process\TIRtemperature_atpitlocation.mat')

TPit =TIRtemperature_atpitlocation; % change name
TPit=TPit(2:1078, :);% remove first and last value
TIRtime = TIRtime(2:1078);
 
load('b_data_process\Pit_process\ExcavationLocation_TIR.mat')
D = importdata('a_data_raw\excavation\ManualExcavationDepth.csv');
PitDepth = D.data;
clear D

%% find correlation and significance between surface temperture and debris thcikness
for i = 1:length(TPit)
    [r, p] = corrcoef(PitDepth(:, 2), TPit(i, :),'rows', 'pairwise');
    R(i) = r(2);
    P(i) = p(2);
end 

Pval = nan(1, 1077);
Pval(P>0.05) = 1;
Pval = Pval.*R;
figure
plot(TIRtime, R, 'k'); hold on
ylabel ('Correlation Coefficient R')
scatter(TIRtime, Pval, 20, 'o', 'r');
legend ('Correlation Coefficient R', 'Non significant values')
grid on

figname = 'Debris_TIRTemp_Correlation_Significance';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% Curve fitting for linear, 
% Which type of correlation is better? test for linear, poly2, power, expoenetial and log

% Compile RMSE and adjusted R2 for each curve fitting of temperatur and
% pit thickness

% to reduce computational time, we select 12 timestep over a 24 day

ii = 1
id = [478:24:745];

figure('units','inches','position',[0 0 8 8]);
for i = 1:length(TPit)
clear x y
y = PitDepth(:, 2);
x = TPit(i, :)';
n = find(isnan(x));
if ~isempty(n)
x(n)=[];
y(n)=[];
end
 
% Linear
[y_poly1, gof_poly1] = poly1fit(x, y); % y = m*x + b
coef_poly1(i, :) = coeffvalues(y_poly1);
yfit = feval(y_poly1, x);
[r,c] = size(yfit); add  = numel(n); yn = NaN(r + add,c);  idx  = setdiff(1:r+add,n);   yn(idx,:) = yfit;
Y1(:, i) = yn;

% Polynomial
[y_poly2, gof_poly2] = poly2fit(x, y);
coef_poly2(i, :) = coeffvalues(y_poly2);
yfit = feval(y_poly2, x);
[r,c] = size(yfit); add  = numel(n); yn = NaN(r + add,c);  idx  = setdiff(1:r+add,n);   yn(idx,:) = yfit;
Y2(:, i)  = yn;
 
% Power
[y_pow, gof_pow] = powfit(x, y); % y = a*x^b
coef_pow(i, :) = coeffvalues(y_pow);
yfit = feval(y_pow, x);
[r,c] = size(yfit); add  = numel(n); yn = NaN(r + add,c);  idx  = setdiff(1:r+add,n);   yn(idx,:) = yfit;
Y3(:, i) = yn;

% Exponential
[y_exp, gof_exp] = expfit(x, y); % y = a*exp(b*x)
coef_exp(i, :) = coeffvalues(y_exp);
yfit = feval(y_exp, x);
[r,c] = size(yfit); add  = numel(n); yn = NaN(r + add,c);  idx  = setdiff(1:r+add,n);   yn(idx,:) = yfit;
Y4(:, i) = yn;

% Log
myfittype=fittype('a +b*log(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});
[y_log, gof_log]=fit(x,y,myfittype,'StartPoint',[1 1]);
coef_log(i, :) = coeffvalues(y_log);
yfit = feval(y_log,x);
 [r,c] = size(yfit); add  = numel(n); yn = NaN(r + add,c);  idx  = setdiff(1:r+add,n);   yn(idx,:) = yfit;
 Y5(:, i)  = yn;
 
%  Extacrt r2 and rmse
ADJRSQUARE(i, 1)=gof_poly1.adjrsquare;
ADJRSQUARE(i, 2)=gof_poly2.adjrsquare;
ADJRSQUARE(i, 3)= gof_pow.adjrsquare;
ADJRSQUARE(i, 4)= gof_exp.adjrsquare;
ADJRSQUARE(i, 5)= gof_log.adjrsquare;

RMSE(i, 1) = gof_poly1.rmse;
RMSE(i, 2) = gof_poly2.rmse;
RMSE(i, 3) = gof_pow.rmse;
RMSE(i, 4) = gof_exp.rmse;
RMSE(i, 5) = gof_log.rmse;

% plot scatter 
if find(ismember(id, i))>=1 
subplot(3,4,ii)
p1 =  plot(y_poly1, x, y); hold on
p1(1).Color = 'k'; p1(2).Color = 'r';
p2 = plot(y_poly2, x, y); hold on
p2(1).Color = 'k'; p2(2).Color = 'b';
p3 =  plot(y_pow, x, y); hold on
p3(1).Color = 'k'; p3(2).Color = 'm';
p4 =  plot(y_exp, x, y); hold on
p4(1).Color = 'k'; p4(2).Color = 'c';
p5 =  plot(y_log, x, y); hold on
p5(1).Color = 'k'; p5(2).Color = 'g';
legend ([p1(2) p2(2) p3(2) p4(2) p5(2)], 'y = ax+b', 'y = ax^2+bx+c', 'y =ax^b','y = a*exp(b*x)', 'y =a+b*log(x)')
 title (datestr(TIRtime(i), 'dd-mmm, HH:MM'));
 ylim([0 120]);

if ii > 1
    legend off;
end 
 xlim([min(x)-1 max(x)+1])
 ii = ii+1
end 
 i
end 
% scave the scatter plot figure
figname = 'Scatter_DebrisTempFit_R2_RMSE_Poly1Poly2PowExpLog_1';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

% create and save the time series figure
figure('units','inches','position',[0 0 8 6]);
subplot(2,1,1)
plot(TIRtime, ADJRSQUARE(:, 1), 'linewidth', 1, 'color', 'r'); hold on
plot(TIRtime, ADJRSQUARE(:, 2), 'linewidth', 1, 'color', 'b'); hold on
plot(TIRtime, ADJRSQUARE(:, 3), 'linewidth', 1, 'color', 'm'); hold on
plot(TIRtime, ADJRSQUARE(:, 4), 'linewidth', 1, 'color', 'c'); hold on
plot(TIRtime, ADJRSQUARE(:, 5), 'linewidth', 1, 'color', 'g'); hold on
ylabel ('adjusted r^2')
xlim([TIRtime(1) TIRtime(end)])
xticks([datetime('05-Aug-2019 18:00:00'):hours(6):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
xtickangle (30)
xticklabels([])
idx = [478:24:745];
scatter(TIRtime(idx), ADJRSQUARE(idx, 2), '.k')
legend ('y = ax+b', 'y = ax^2+bx+c', 'y =ax^b','y = a*exp(b*x)', 'y =a+b*log(x)', 'location', 'best' , 'orientation', 'horizontal')

subplot(2,1,2)
plot(TIRtime, RMSE(:, 1), 'linewidth', 1, 'color', 'r'); hold on
plot(TIRtime, RMSE(:, 2), 'linewidth', 1, 'color', 'b'); hold on
plot(TIRtime, RMSE(:, 3), 'linewidth', 1, 'color', 'm'); hold on
plot(TIRtime, RMSE(:, 4), 'linewidth', 1, 'color', 'c'); hold on
plot(TIRtime, RMSE(:, 5), 'linewidth', 1, 'color', 'g'); hold on

scatter(TIRtime(idx), RMSE(idx, 2), '.k')
ylabel ('RMSE (cm)')
xlim([TIRtime(1) TIRtime(end)])
xticks([datetime('05-Aug-2019 18:00:00'):hours(6):datetime('09-Aug-2019 9:00:00')]);
xtickformat ('d-MMM, HH:mm') 
xtickangle (30)
legend ('y = ax+b', 'y = ax^2+bx+c', 'y =ax^b','y = a^{bx}', 'y =a+b*log(x)', 'location', 'best' , 'orientation', 'horizontal')
figname = 'DebrisTempFit_R2_RMSE_Poly1Poly2PowExpLog';
saveas(gcf, strcat(figdir, figname), 'png')
saveas(gcf, strcat(figdir, figname), 'pdf')
saveas(gcf, strcat(figdir, figname), 'fig')

%% end



% based on this, we select linear and  power as our two correlation type
% 
% %% Just with top 2 fit instead of 5 (linear and power)
% % id for the scatter
% idx = [538:36:730];
% TIRtime(idx)
% c1 =   [0 0 204]./255;
% c2 =   [255 128 0]./255;
% figure('units','inches','position',[0 0 6 5]);
% subplot(2,1,1)
% plot(TIRtime, ADJRSQUARE(:, 1), 'linewidth', 1, 'color',c1); hold on
% plot(TIRtime, ADJRSQUARE(:, 3), 'linewidth', 1, 'color', c2); hold on
% scatter(TIRtime(idx), ADJRSQUARE(idx, 3), '.k')
% ylabel ('adjusted R^2')
% xlim([TIRtime(1) TIRtime(end)])
% xticks([datetime('05-Aug-2019 18:00:00'):hours(6):datetime('09-Aug-2019 9:00:00')]);
% xtickformat ('d-MMM, HH:mm') 
% xtickangle (30)
% xticklabels([])
% legend ('y = ax+b', 'y =ax^b', 'location', 'best' , 'orientation', 'horizontal')
% grid on
% 
% subplot(2,1,2)
% plot(TIRtime, RMSE(:, 1), 'linewidth', 1, 'color', c1); hold on
% plot(TIRtime, RMSE(:, 3), 'linewidth', 1, 'color', c2); hold on
% scatter(TIRtime(idx), RMSE(idx, 3), '.k')
% ylabel ('RMSE (cm)')
% xlim([TIRtime(1) TIRtime(end)])
% xticks([datetime('05-Aug-2019 18:00:00'):hours(6):datetime('09-Aug-2019 9:00:00')]);
% xtickformat ('d-MMM, HH:mm') 
% xtickangle (30)
% legend ('y = ax+b', 'y =ax^b', 'location', 'best' , 'orientation', 'horizontal')
% grid on
% 
% figname = 'DebrisTempFit_R2_RMSE_LinearPower';
% saveas(gcf, strcat(figdir, figname), 'png')
% saveas(gcf, strcat(figdir, figname), 'pdf')
% saveas(gcf, strcat(figdir, figname), 'fig')
% % 
% %% Curve fitting scatter plot
% idx = [468:24:738];
% TIRtime(idx)
% figure('units','inches','position',[0 0 7 4]);
% for i = 1:length(idx);
%     clear x y
% y = PitDepth(:, 2);
% x = TPit(idx(i), :)';
% n = find(isnan(x));
% if ~isempty(n)
% x(n)=[];
% y(n)=[];
% end
% 
%  subplot(4,3,i)
% [y_poly1, gof_poly1] = poly1fit_withplot(y, x);hold on
% [y_pow, gof_pow] = powfit_withplot(y, x);
%  title (datestr(TIRtime(idx(i)), 'dd-mmm, HH:MM'), 'FontWeight', 'normal');
%  legend off;
%  xlim([0 120]);
% %  ylim([min(x)-1 max(x)+1])
%  if i == 1 
%  h1 = findobj(gca,'Type','Line');
%  lg = legend ([h1(1) h1(3) ],  'y = ax^b', 'y = ax + b', 'location', 'northwest');
%  end 
% set(findall(gcf,'-property','FontSize'),'FontSize',10)
% 
% 
% ADJRSQUARE_plot(i, 1)=gof_poly1.adjrsquare;
% ADJRSQUARE_plot(i, 2)=gof_pow.adjrsquare;
% 
% RMSE_plot(i, 1) = gof_poly1.rmse;
% RMSE_plot(i, 2) = gof_pow.rmse;
% end 
% figname = 'DebrisTempFit_CurveFittingScatter_LinearPower';
% saveas(gcf, strcat(figdir, figname), 'png')
% saveas(gcf, strcat(figdir, figname), 'pdf')
% saveas(gcf, strcat(figdir, figname), 'fig')
% 
% %% find the best correlation for each time step
% [m, im] = max(ADJRSQUARE,[], 2)
% figure
%  plot(TIRtime, smooth(ADJRSQUARE(:, 1), 12))
%  hold on
%  plot(TIRtime, smooth(ADJRSQUARE(:, 3),12))
%  plot(TIRtime, smooth(m, 12))
%  
%  figure
% plot( smooth(ADJRSQUARE(:, 1), 12))
%  hold on
% plot(smooth(ADJRSQUARE(:, 3),12))
% 
% legend ('linear','power')
%  LinearBest = [80:176, 393:470, 680:789, 964:1077];
%  PowBest = [1:79, 177:392, 471:679, 790:963];
%  
%  
%  figure
%  plot(TIRtime(LinearBest), ADJRSQUARE(LinearBest, 1), '.b'); hold on
%  plot(TIRtime( PowBest), ADJRSQUARE( PowBest, 3), '.r')
% 
%  %% switching point
%  figure
%   plot(TIRtime, ADJRSQUARE(:, 2), 'k'); 
%  plot(TIRtime, ADJRSQUARE(:, 3), 'b');hold on
%   plot(TIRtime, ADJRSQUARE(:, 1), 'r')
% legend ('poly2','power','linear')
% 
% plot(TIRtime, round(im, 2))
% r2= round(ADJRSQUARE, 2);
% plot(r2)
% [m, im] = max(r2(:, 1:3),[], 2)
% scatter(TIRtime,im, '.k') 
% 
% numel(find(im==1))
% numel(find(im==2))
% numel(find(im==3))
% 
% % inflection point:
% 
% Tswitch = {'7-Aug-2019 08:00:02'; '8-Aug-2019 01:50:02';
%             '08-Aug-2019 13:35:02';'09-Aug-2019 02:20:02';
%             }
% %% to the whole image
% load('D:\IRPeyto\IR_2019\data_process\TIR_process\Registration\Image_Registered_Cropped_Feb12.mat')
%  TIR = Rcrop(:,:,2:1078);
% 
% for i = 1:length(TIR)
% y = PitDepth;
% x = TPit(i, :)';
% n = find(isnan(x));
% if ~isempty(n)
% x(n)=[];
% y(n)=[];
% end
% % apply curve fitting
% if find(ismember(PowBest, i))>=1 % power fit
% [fit, gof_pow] = powfit(x, y); 
% else % linear fit
% [fit, gof_poly1] = poly1fit(x, y); 
% 
% end
% X = reshape(TIR(:,:,i), 351*1000, 1);
% yfit_IR = feval(fit, X);
% 
% yfit = feval(fit, x);
% [r,c] = size(yfit); add  = numel(n); yn = NaN(r + add,c);  idx  = setdiff(1:r+add,n);   yn(idx,:) = yfit;
%   yfit_pit(:, i) = yn;
% 
% TIR_depthcalc(:,:,i) = reshape(yfit_IR , 351, 1000);  
% end 
% 
% figure
% for i = 1:length(idx)
% subplot(3,2,i)
% imagesc(TIR_depthcalc(:,:,idx(i)).*ROI)
% caxis ([0 120])
% colorbar
% title(datestr(TIRtime(idx(i))))
% 
% end 
% 
% figure;imagesc(TIR_depthcalc(:,:,idx(1)));colorbar; caxis([0 120])
% bins = [0:5:120]; % bin edges
%  I = TIR_depthcalc(:,:,754).*ROI;
%     Ir = reshape(I, 1, 351:100);
%     Ir(Ir<=0)=nan;
%     [distrib, nd]=hist(Ir,bins);
%     figure; bar(nd, distrib, 'k', 'Linewidth',1.1); hold on
%     plot(nd, numpixMeas, 'r', 'Linewidth',1.1)
% [numpixMeas, nd]=hist(DepthInterpROI_reshape,bins);
% 
% y = PitDepth;
% x = TPit(754, :)';
% n = find(isnan(x));
% if ~isempty(n)
% x(n)=[];
% y(n)=[];
% end
% figure
% [y_poly1, gof_poly1] = poly1fit_withplot(y, x);hold on
% [y_pow, gof_pow] = powfit_withplot(y, x);
%  title (datestr(TIRtime(754), 'dd-mmm, HH:MM'), 'FontWeight', 'normal');
%  legend off;
%  xlim([0 120]);
% 
% 
% ADJRSQUARE_plot=gof_poly1.adjrsquare
% ADJRSQUARE_plot=gof_pow.adjrsquare
% 
% RMSE_plot= gof_poly1.rmse
% RMSE_plot = gof_pow.rmse
% 
% 
% %% Distribution of pixels (in % of area)
% load('D:\IRPeyto\IR_2019\data_process\Pit_process\PitDepthInterpolated.mat', 'DepthInterp')
% load('D:\IRPeyto\IR_2019\data_process\Pit_process\ROIstudyslope.mat')
% load('D:\IRPeyto\IR_2019\data_process\Pit_process\PitDepthInterpolated.mat', 'DepthInterpLinear', 'DepthInterpNearest')
% 
% ROI =double( ROI);
% ROI(ROI==0)=nan;
% % measured depth 
% DepthInterpROI = DepthInterp.*ROI;
% DepthInterpROI(DepthInterpROI<0) = nan;
% DepthInterpROI_reshape = reshape(DepthInterpROI, 1, 351:100);
% DepthInterpROI_reshape(DepthInterpROI_reshape<=0)=nan;
% Depth_meanmeas = nanmean(DepthInterpROI_reshape); % eamean depth measured
%     
% %% get the distrbituion of pits 
% bins = [0:5:120]; % bin edges
% [numpixMeas, nd]=hist(PitDepth,bins);
% bar(nd, numpixMeas, 'k', 'Linewidth',1.1)
% idx = [479:36:740]; % time steps 
% 
% cm_redtoblue = color_shades({'red','blue'})
% cm = cm_redtoblue(1:round(length(cm_redtoblue)./length(idx)):end, :)
% 
% clear n w p Mv I Ir numpix depth pl2
% for i= 1:length(idx)    
% [numpix(:, i),depth(:, i)]=hist(yfit_pit(:,i),bins);hold on
% pl2(i) = plot(depth(:, i), numpix(:, i))
% end
% 
% ylabel ('% of Study slope Area')
% xlabel ('Debris Thickness (cm)')
% set(gca,'FontSize',10)
% grid on
% legend ([p1(1) pl2 s1], 'Measured', ...
%     datestr(th(idx(1)),'HHAM, mmm-dd'), datestr(th(idx(2)),'HHAM'), datestr(th(idx(3)),'HHAM') ,...
%     datestr(th(idx(4)),'HHAM'), datestr(th(idx(5)),'HHAM'), datestr(th(idx(6)),'HHAM'),...
%     datestr(th(idx(7)),'HHAM'), datestr(th(idx(8)),'HHAM'),'Mean', 'location', 'EastOutside');
% %% for inidivudal time
% bins = [0:5:120]; % bin edges
% 
% idx = [466:24:1040]; % time steps
% [numpixMeas, nd]=hist(PitDepth,bins);
% 
% for i = 1:length(idx);
% subplot(4,6,i)
% [numpix,depth]=hist(yfit_pit(:, i),bins);
% bar(nd,numpix, 'k')
% hold on
% plot(nd, numpixMeas, 'r', 'linewidth', 2)
% ylim([0 10]);xlim([0 120])
% title (datestr(TIRtime(idx(i))))
% end
% %% get the distrbituion of pixels for the area
% bins = [0:5:120]; % bin edges
% totalpixel = numel(find(~isnan(DepthInterpROI_reshape)))
% [numpixMeas, nd]=hist(DepthInterpROI_reshape,bins);
% percentarea = numpixMeas*100./totalpixel;
% 
% sum(percentarea)
%  th = TIRtime;
% idxMeas = find(nd == round(Depth_meanmeas/5)*5);% find id of the mean thickness 
% 
% idx = [479:36:740]; % time steps 
% TIRtime(idx)
% 
% subplot(3,1,1)
% idx = [178:36:465]; % time steps 
% cm_redtoblue = color_shades({'red','blue'})
% cm = cm_redtoblue(1:round(length(cm_redtoblue)./length(idx)):end, :)
% 
% clear n w p Mv I Ir numpix depth pl2
% for i= 1:length(idx)
%     I = TIR_depthcalc(:,:,idx(i)).*ROI;
%     Ir = reshape(I, 1, 351:100);
%     Ir(Ir<=0)=nan;
%     Mv(i)= round(nanmean(Ir)); % mean depth of the ROI
%     
% [numpix(:, i),depth(:, i)]=hist(Ir,bins);
% percentarea_calc= numpix*100./totalpixel;
% 
% pl2(i) = plot(depth(:, i), percentarea_calc(:, i), 'Color', cm(i,:), 'linewidth', 1); hold on
% idxMv= find(depth(:,i) == round(Mv(i)/5)*5);% find the IDX corresponding to mean depth
% scatter(Mv(:, i),percentarea_calc(idxMv,i) , 30, cm(i, :), 'd','filled') % add a point at the location of mean depth (x) and number of pixels)
% ylim([0 30])
% xlim ([0 110])
% end
% p1 = plot(nd,percentarea, '-k', 'linewidth', 2); hold on
% s1 = scatter(Depth_meanmeas ,percentarea(idxMeas) , 50, 'kd','filled')
% 
% ylabel ('% of Study slope Area')
% xlabel ('Debris Thickness (cm)')
% set(gca,'FontSize',10)
% grid on
% legend ([p1(1) pl2 s1], 'Measured', ...
%     datestr(th(idx(1)),'HHAM, mmm-dd'), datestr(th(idx(2)),'HHAM'), datestr(th(idx(3)),'HHAM') ,...
%     datestr(th(idx(4)),'HHAM'), datestr(th(idx(5)),'HHAM'), datestr(th(idx(6)),'HHAM'),...
%     datestr(th(idx(7)),'HHAM'), datestr(th(idx(8)),'HHAM'),'Mean', 'location', 'EastOutside');
% 
% subplot(3,1,2)
% idx = [466:36:753]; % time steps 
% TIRtime(idx)
% clear n w p Mv I Ir numpix depth pl2
% for i= 1:length(idx)
%     I = TIR_depthcalc(:,:,idx(i)).*ROI;
%     Ir = reshape(I, 1, 351:100);
%     Ir(Ir<=0)=nan;
%     Mv(i)= round(nanmean(Ir)); % mean depth of the ROI
%     
% [numpix(:, i),depth(:, i)]=hist(Ir,bins);
% percentarea_calc= numpix*100./totalpixel;
% 
% pl2(i) = plot(depth(:, i), percentarea_calc(:, i), 'Color', cm(i,:), 'linewidth', 1); hold on
% idxMv= find(depth(:,i) == round(Mv(i)/5)*5);% find the IDX corresponding to mean depth
% scatter(Mv(:, i),percentarea_calc(idxMv,i) , 30, cm(i, :), 'd','filled') % add a point at the location of mean depth (x) and number of pixels)
% ylim([0 30])
% xlim ([0 110])
% end
% p1 = plot(nd,percentarea, '-k', 'linewidth', 2); hold on
% s1 = scatter(Depth_meanmeas ,percentarea(idxMeas) , 50, 'kd','filled')
% 
% ylabel ('% of Study slope Area')
% xlabel ('Debris Thickness (cm)')
% set(gca,'FontSize',10)
% grid on
% legend ([p1(1) pl2 s1], 'Measured', ...
%     datestr(th(idx(1)),'HHAM, mmm-dd'), datestr(th(idx(2)),'HHAM'), datestr(th(idx(3)),'HHAM') ,...
%     datestr(th(idx(4)),'HHAM'), datestr(th(idx(5)),'HHAM'), datestr(th(idx(6)),'HHAM'),...
%     datestr(th(idx(7)),'HHAM'), datestr(th(idx(8)),'HHAM'),'Mean', 'location', 'EastOutside');
% 
% subplot(3,1,3)
% idx = [754:36:1040]; % time steps 
% clear n w p Mv I Ir numpix depth pl2
% for i= 1:length(idx)
%     I = TIR_depthcalc(:,:,idx(i)).*ROI;
%     Ir = reshape(I, 1, 351:100);
%     Ir(Ir<=0)=nan;
%     Mv(i)= round(nanmean(Ir)); % mean depth of the ROI
%     
% [numpix(:, i),depth(:, i)]=hist(Ir,bins);
% percentarea_calc= numpix*100./totalpixel;
% 
% pl2(i) = plot(depth(:, i), percentarea_calc(:, i), 'Color', cm(i,:), 'linewidth', 1); hold on
% idxMv= find(depth(:,i) == round(Mv(i)/5)*5);% find the IDX corresponding to mean depth
% scatter(Mv(:, i),percentarea_calc(idxMv,i) , 30, cm(i, :), 'd','filled') % add a point at the location of mean depth (x) and number of pixels)
% ylim([0 30])
% xlim ([0 110])
% end
% p1 = plot(nd,percentarea, '-k', 'linewidth', 2); hold on
% s1 = scatter(Depth_meanmeas ,percentarea(idxMeas) , 50, 'kd','filled')
% legend ([p1(1) pl2 s1], 'Measured', ...
%     datestr(th(idx(1)),'HHAM, mmm-dd'), datestr(th(idx(2)),'HHAM'), datestr(th(idx(3)),'HHAM') ,...
%     datestr(th(idx(4)),'HHAM'), datestr(th(idx(5)),'HHAM'), datestr(th(idx(6)),'HHAM'),...
%     datestr(th(idx(7)),'HHAM'), datestr(th(idx(8)),'HHAM'),'Mean', 'location', 'EastOutside');
% 
% ylabel ('% of Study slope Area')
% xlabel ('Debris Thickness (cm)')
% set(gca,'FontSize',10)
% grid on
% 
% % orient('landscape')
% % saveas (gcf, 'D:\IRPeyto\IR_2019\fig\DistributionThicknessPixels_PolyPow.pdf')
% % saveas (gcf, 'D:\IRPeyto\IR_2019\fig\DistributionThicknessPixels_PolyPow.png')
% % savefig ( gcf, 'D:\IRPeyto\IR_2019\fig\DistributionThicknessPixels_PolyPow.fig')
% %% A different visual (individual bar + line) for each hour
% bins = [0:5:120]; % bin edges
% totalpixel = numel(find(~isnan(DepthInterpROI_reshape)))
% sum(percentarea)
%  th = TIRtime;
% idxMeas = find(nd == round(Depth_meanmeas/5)*5);% find id of the mean thickness 
% 
% 
% 
% idx = [466:24:1040]; % time steps
% 
% for i = 1:length(idx);
% subplot(4,6,i)
%  Ir = reshape(TIR_depthcalc(:,:,idx(i)).*ROI, 351*1000,1);
% [numpix,depth]=hist(Ir,bins); percentarea= numpix*100./totalpixel;
% bar(nd,percentarea, 'k')
% hold on
% plot(nd, percentarea_meas, 'r', 'linewidth', 2)
% ylim([0 30]);xlim([0 120])
% title (datestr(TIRtime(idx(i))))
% end
% 
% %% For pit data instead
% %%
% idx = [178:36:465]; % time steps 
% cm_redtoblue = color_shades({'red','magenta','cyan', 'blue'})
% cm = cm_redtoblue(1:round(length(cm_redtoblue)./length(idx)):end, :)
% 
% clear n w p Mv I Ir numpix depth pl2
% for i= 1:length(idx)
%     I = TIR_depthcalc(:,:,idx(i)).*ROI;
%     Ir = reshape(I, 1, 351:100);
%     Ir(Ir<=0)=nan;
%     Mv(i)= round(nanmean(Ir)); % mean depth of the ROI
%  
% [numpix(:, i),depth(:, i)]=hist(Ir,bins);
% percentarea_calc= numpix*100./totalpixel;
% 
% pl2(i) = plot(depth(:, i), percentarea_calc(:, i), 'Color', cm(i,:), 'linewidth', 1); hold on
% idxMv= find(depth(:,i) == round(Mv(i)/5)*5);% find the IDX corresponding to mean depth
% scatter(Mv(:, i),percentarea_calc(idxMv,i) , 30, cm(i, :), 'd','filled') % add a point at the location of mean depth (x) and number of pixels)
% ylim([0 30])
% xlim ([0 110])
% end
% h1 = histogram(percentarea, bins) '-k', 'linewidth', 2); hold on
% s1 = scatter(Depth_meanmeas ,percentarea(idxMeas) , 50, 'kd','filled')
% 
% ylabel ('% of Study slope Area')
% xlabel ('Debris Thickness (cm)')
% set(gca,'FontSize',10)
% grid on
% 
% 
% 
% %% for some other timestep
% figure
% e = [0:1:117]; % bin edges
% [numpixMeas, nd]=hist(DepthInterpROI_reshape,e);
%  th = TIRtime;
%  p1 = plot(nd,numpixMeas, '-k', 'linewidth', 2); hold on
% idxMeas = find(nd == round(Md));% find id of the mean thickness 
% idx = [754:36:1041]; % time steps 
% TIRtime(idx)
% 
% cm_redtoblue = color_shades({'red', 'blue'})
% cm = cm_redtoblue(1:round(length(cm_redtoblue)./length(idx)):end, :)
% 
% subplot(3,1,1)
% p1 = plot(nd,numpixMeas, '-k', 'linewidth', 2); hold on
% s1 = scatter(Md,numpixMeas(idxMeas) , 40, 'kd','filled')
% clear n w p Mv I Ir numpix depth pl2
% for i= 1:length(idx)
%     I = Yfit_poly1(:,:,idx(i)).*ROI;
%     Ir = reshape(I, 1, 351:100);
%     Ir(Ir<=0)=nan;
%     Mv(i)= round(nanmean(Ir)); % mean depth of the ROI
% [numpix(:, i),depth(:, i)]=hist(Ir,e);
% pl2(i) = plot(depth(:, i), numpix(:, i), 'Color', cm(i,:), 'linewidth', 1); hold on
% idxMv= find(depth(:,i) == Mv(i));% find the IDX corresponding to mean depth
% scatter(Mv(:, i),numpix(idxMv,i) , 30, cm(i, :), 'd','filled') % add a point at the location of mean depth (x) and number of pixels)
% ylim([0 10000])
% xlim ([0 110])
% end
% 
% ylabel ('Number of Pixels')
% xlabel ('Debris Thickness (cm)')
% title ('Poly1')
% set(gca,'FontSize',10)
% grid on
% 
% subplot(3,1,2)
% p1 = plot(nd,numpixMeas, '-k', 'linewidth', 2); hold on
% s1 = scatter(Md,numpixMeas(idxMeas) , 40, 'kd','filled')
% clear n w p Mv I Ir numpix depth pl2
% for i= 1:length(idx)
%     I = Yfit_poly2(:,:,idx(i)).*ROI;
%     Ir = reshape(I, 1, 351:100);
%     Ir(Ir<=0)=nan;
%     Mv(i)= round(nanmean(Ir)); % mean depth of the ROI
% [numpix(:, i),depth(:, i)]=hist(Ir,e);
% pl2(i) = plot(depth(:, i), numpix(:, i), 'Color', cm(i,:), 'linewidth', 1); hold on
% idxMv= find(depth(:,i) == Mv(i));% find the IDX corresponding to mean depth
% scatter(Mv(:, i),numpix(idxMv,i) , 30, cm(i, :), 'd','filled') % add a point at the location of mean depth (x) and number of pixels)
% ylim([0 10000])
% xlim ([0 110])
% end
% legend ([p1 pl2 s1], 'Measured', ...
%     datestr(th(idx(1)),'HHAM, mmm-dd'), datestr(th(idx(2)),'HHAM'), datestr(th(idx(3)),'HHAM') ,...
%     datestr(th(idx(4)),'HHAM'), datestr(th(idx(5)),'HHAM'), datestr(th(idx(6)),'HHAM'),...
%     datestr(th(idx(7)),'HHAM'), datestr(th(idx(8)),'HHAM'),'Mean'); %, 'location', 'East');
% 
% ylabel ('Number of Pixels')
% xlabel ('Debris Thickness (cm)')
% title('Poly2')
% set(gca,'FontSize',10)
% grid on
% 
% subplot(3,1,3)
% p1 = plot(nd,numpixMeas, '-k', 'linewidth', 2); hold on
% s1 = scatter(Md,numpixMeas(idxMeas) , 40, 'kd','filled')
% clear n w p Mv I Ir numpix depth pl2
% for i= 1:length(idx)
%     I = Yfit_pow(:,:,idx(i)).*ROI;
%     Ir = reshape(I, 1, 351:100);
%     Ir(Ir<=0)=nan;
%     Mv(i)= round(nanmean(Ir)); % mean depth of the ROI
% [numpix(:, i),depth(:, i)]=hist(Ir,e);
% pl2(i) = plot(depth(:, i), numpix(:, i), 'Color', cm(i,:), 'linewidth', 1); hold on
% idxMv= find(depth(:,i) == Mv(i));% find the IDX corresponding to mean depth
% scatter(Mv(:, i),numpix(idxMv,i) , 30, cm(i, :), 'd','filled') % add a point at the location of mean depth (x) and number of pixels)
% ylim([0 10000])
% xlim ([0 110])
% end
% % legend ([p1(1) pl2 s1], 'Measured', ...
% %     datestr(th(idx(1)),'HHAM, mmm-dd'), datestr(th(idx(2)),'HHAM'), datestr(th(idx(3)),'HHAM') ,...
% %     datestr(th(idx(4)),'HHAM'), datestr(th(idx(5)),'HHAM'), datestr(th(idx(6)),'HHAM'),...
% %     datestr(th(idx(7)),'HHAM'), datestr(th(idx(8)),'HHAM'), datestr(th(idx(9)),'HHAM, mmm-dd'),...
% %     datestr(th(idx(10)),'HHAM'),datestr(th(idx(11)),'HHAM'),datestr(th(idx(12)),'HHAM'),'Mean', 'location', 'EastOutside');
% ylabel ('Number of Pixels')
% xlabel ('Debris Thickness (cm)')
% title ('Power')
% set(gca,'FontSize',10)
% grid on
% 
% %%
% 
% 
% orient('landscape')
% print( 'D:\IRPeyto\IR_2019\fig\DistributionThicknessPixels', '-dpdf')
% saveas (gcf, 'D:\IRPeyto\IR_2019\fig\DistributionThicknessPixels.pdf')
% saveas (gcf, 'D:\IRPeyto\IR_2019\fig\DistributionThicknessPixels.png')
% savefig ( gcf, 'D:\IRPeyto\IR_2019\fig\DistributionThicknessPixels.fig')
% 
% %% what the relative error for the pit
% for i = 1:9
%    MB = nanmean(yfit_pit(i, :)-PitDepth(i)) - (yfit_pit(i, :)-PitDepth(i));
% plot(TIRtime,MB ); hold on
% plot(TIRtime, zeros(1, length(TIRtime)), 'k')
% title (num2str(round(PitDepth(i))))
% end 