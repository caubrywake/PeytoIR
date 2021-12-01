%% Extracting TIR surface temperature at pit location
%  This code extracts the surface temperature at the location of each pit
% for the TIR McGill images and creates a figure of the surface temperature
% according to depth

%% Set-Up
clear all
close all
cd ('D:\2_IRPeyto')
figdir='D:\2_IRPeyto\e_fig\tir_surfacet\'

%% Load Variables
% TIR image 
load('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR1rgb_reg.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat', 'TIR1_time')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop.mat')

% Manual Excavation Depth and Location
D = importdata('D:\2_IRPeyto\a_data_raw\excavation\Manualexcavation_Peyto_20190806_short.txt'); % version without the notes
d = D.data; PitDepth = d(:, 3);
clear D d
% Load study slope ROI
load('D:\2_IRPeyto\b_data_process\parameter\ROIstudyslope.mat')
% Pit location
load('D:\2_IRPeyto\b_data_process\parameter\PitLocation_TIR.mat')
%% Extract TIR surface temperature for each pit
IDX = PitLocation_TIR;
clear IDXroi
for i = 1:45 % select the pixels for eahc pit
 M0 = zeros(351, 1000);
 M0(IDX(i, 1)-3:IDX(i, 1)+3, IDX(i,2)-3:IDX(i,2)+3) = 1;% each pit is set to be 3x3 pixel
 IDXroi(:, i) = find(M0);
end 
 
 for i = 1:1079 % extract the mean temperature of the pixels for each timestep
     for ii = 1:45  
         [row, col] = ind2sub([351, 1000],IDXroi(:, ii)); 
TPit(i, ii) = mean(mean((TIR1_crop(row,col, i)))); % from the raw IR image
     end 
 end 
% remove some of the bad values
TPit(TPit<=265)=nan; % when the pit were not in the filed of view due to shift in the camera
TPit(:, [17])=nan;
TPit(:, [17, 33, 34])=nan; % pit our of view form IR, of on the edge of the ice cliff

% Temperature array at pit locations. this is a timeseries that is used a
% lot in later analysis, so i save it as well.
TIRtemperature_atpitlocation = TPit;
save ('D:\2_IRPeyto\b_data_process\parameter\TIRtemperature_atpitlocation.mat', 'TIRtemperature_atpitlocation')



%% Plot the temperature for each pit
% load air temperature
D = importdata('a_data_raw\AWS\PeytoMoraineAWS_15min.csv')
M = D.data;% moraine date: T, RH, SWin, U, LW
Mt = datetime(D.textdata(18:end, 1)); %moraine Time
clear D

% sort the pit depth
[PitSrt,id] = sort(PitDepth(:, 1));
    TPitSrt = TPit(:, id);
  for i = 1:45
      TPitSrt_smooth(:, i) = smooth(TPitSrt(:, i), 6);
  end 
 % set the nans as before
 x = find(isnan(TPitSrt));
 TPitSrt_smooth(x)=nan; 
 
 % set colormap
    cm = colormap(cool(size(TPit,2)));  
    map(:,1) = linspace(0 , 1, size(TPit,2)) % black to red
    map(:, 2) = zeros(size(TPit,2), 1)
    map(:, 3) = linspace(1 ,0, size(TPit,2))  % black to red
 
    figure('units','inches','position',[0 0 8 4]);
for i =1:45
p1 = plot(TIR1_time(2:end-1),TPitSrt_smooth(2:end-1, i)-273.15, 'color', map(i, :)); hold on
end 
plot(Mt, M(:, 1), ':k', 'linewidth', 1)
colormap(map);caxis([0 120])
cb = colorbar;
ylabel(cb,'Debris Thickness (cm)')
ylabel('Temperature (^{\circ}C)')
xlim([TIR1_time(2) TIR1_time(end-1)]);
ylim([-5 30]);grid on    
xticks ([TIRtime(83):hours(12):TIRtime(end-1)])
grid on
xtickformat ('H:mm, M-dd')

 figname = 'TIRSurfaceTemperature_atPitLocation';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))

