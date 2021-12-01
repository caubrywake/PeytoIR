%% Analysis AWS data
% by Caroline Aubry-Wake
% edited 2021-06-06
% This script analyses the AWS data from the on-ice and off-ice automated
% weather stations

%% Set-Up
clear all
close all
cd ('D:\2_IRPeyto')
figdir='D:\2_IRPeyto\e_fig\aws\'

%% Load the AWS data
D = importdata('a_data_raw\AWS\PeytoIceAWS_15min.txt')
I =D.data(:, 1:4); % AWS ic data: T, RH, SWin, U
It = datetime(D.textdata(20:end, 1));% aws ice time:
a = datevec(It);b = find(a(:, 4)==0 & a(:, 5) ==0);a(b, 3) = a(b, 3)+1;% there is a problem with the midnight
It = datetime(a);

D = importdata('a_data_raw\AWS\PeytoMoraineAWS_15min.txt')
M = D.data;% moraine date: T, RH, SWin, U, LW
Mt = datetime(D.textdata(18:end, 1)); %moraine Time
clear D a b 
% Rename variable to make it easier
clear AWSicedata AWSicet PeytoAWS PeytoAWS_time time data

% Load the timing of the IR image
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat', 'TIR1_time')
TIRtime_McGill = TIR1_time-hours(8);

folderlist  = dir('D:\2_IRPeyto\a_data_raw\tir\PeytoTIR2_4_20190805_20190809_5min\19*');
folderpath = folderlist.folder;
for i = 1:10;
    clear foldername filepath
foldername = folderlist(i,1).name;
filepath = strcat(folderpath , '\', foldername);
filelist = dir(strcat(filepath, '\', '*.irb'));
t{1, i} = {filelist(:).date};
    end 

TIRtime_USask =(datetime([t{1,1} t{1,2} t{1,3} t{1,4} t{1,5} t{1,6} t{1,7} t{1,8}, t{1,9} t{1,10}])-hours(8))';
TIRtime_Usask_start_end = TIRtime_USask([1, 105, 108, 147, 149, 237, 238, 380, 381, 402]);

d = dir(fullfile(foldername, 'filename_*'));
struct2table(d);

t = TIR_USask_Reg_Moraine.Time;

clear TIRtime t

%% Plot AWS
c1 = [.9 .9 .9];
c2 = [.7 .7 .7];
c3 = [.4 .4 .4]
fig = figure('units','inches','position',[0 0 5 8]); % aug 7, 17:45
subplot(5,1,1); hold on
bv = 5; ylimtop = [20, 20];
area([TIRtime_Usask_start_end(1), TIRtime_Usask_start_end(2)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(3), TIRtime_Usask_start_end(4)],[20,20],'facecolor',c2, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(5), TIRtime_Usask_start_end(6)],[20,20],'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(7), TIRtime_Usask_start_end(8)],[20,20],'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(9), TIRtime_Usask_start_end(10)],[20,20],'facecolor',c3, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
p1 = plot(Mt, M(:, 1)); hold on
p2 = plot(It, I(:, 1));
xlim ([TIRtime_McGill(1) TIRtime_McGill(end)]); ylim([5 20])
ylabel ('Ta (C^{\circ})');
box on
xticklabels ([]);
lg = legend ([p1(1) p2(1)],'AWSmoraine', 'AWSice', 'location', 'northwest', 'Orientation', 'Horizontal')
pos = lg.Position;
lg.Position = pos + [-0.025 0.05 0 0];
text(TIRtime_USask(2), 18, '(a)')
box on

subplot(5,1,2);  hold on
bv = 20; ylimtop = [100, 100];
area([TIRtime_Usask_start_end(1), TIRtime_Usask_start_end(2)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(3), TIRtime_Usask_start_end(4)],ylimtop,'facecolor',c2, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(5), TIRtime_Usask_start_end(6)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(7), TIRtime_Usask_start_end(8)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(9), TIRtime_Usask_start_end(10)],ylimtop,'facecolor',c3, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
plot(Mt, M(:, 2)); hold on
plot(It, I(:, 2));
xlim ([TIRtime_McGill(1) TIRtime_McGill(end)]); ylim([20 100])
ylabel ('RH (%)')
xticklabels ([]);
text(TIRtime_USask(2), 93, '(b)')
box on

subplot(5,1,3);hold on
bv = 0; ylimtop = [1000, 1000];
area([TIRtime_Usask_start_end(1), TIRtime_Usask_start_end(2)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(3), TIRtime_Usask_start_end(4)],ylimtop,'facecolor',c2, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(5), TIRtime_Usask_start_end(6)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(7), TIRtime_Usask_start_end(8)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(9), TIRtime_Usask_start_end(10)],ylimtop,'facecolor',c3, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
plot(Mt, M(:, 3)); hold on
plot(It, I(:, 3));
xlim ([TIRtime_McGill(1) TIRtime_McGill(end)]);ylim([0 1000])
ylabel ('SWin (Wm^{-2})')
xticklabels ([]);
text(TIRtime_USask(2), 930, '(c)')
box on

subplot(5,1,4); hold on
bv = 250; ylimtop = [380,380];
area([TIRtime_Usask_start_end(1), TIRtime_Usask_start_end(2)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(3), TIRtime_Usask_start_end(4)],ylimtop,'facecolor',c2, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(5), TIRtime_Usask_start_end(6)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(7), TIRtime_Usask_start_end(8)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(9), TIRtime_Usask_start_end(10)],ylimtop,'facecolor',c3, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
plot(Mt, M(:, 4)); hold on
xlim ([TIRtime_McGill(1) TIRtime_McGill(end)]); ylim([250 380])
ylabel ('LWin (Wm^{-2})')
xticklabels ([]);
text(TIRtime_USask(2), 369, '(d)')
box on

subplot(5,1,5);  hold on
bv = 0; ylimtop = [10,10];
area([TIRtime_Usask_start_end(1), TIRtime_Usask_start_end(2)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(3), TIRtime_Usask_start_end(4)],ylimtop,'facecolor',c2, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(5), TIRtime_Usask_start_end(6)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(7), TIRtime_Usask_start_end(8)],ylimtop,'facecolor',c1, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
area([TIRtime_Usask_start_end(9), TIRtime_Usask_start_end(10)],ylimtop,'facecolor',c3, ...
    'facealpha',.5,'edgecolor','none', 'basevalue',bv);
plot(Mt, M(:, 5)); hold on
plot(It, I(:, 4));
xlim ([TIRtime_McGill(1) TIRtime_McGill(end)]); ylim([0 10])
ylabel ('U (ms^{-1})')
text(TIRtime_USask(2), 9, '(e)')
xtickformat ('MMM-dd, HH:mm')
 box on
 
figname = 'AWS_Moraine_Ice';
 savefig (gcf, strcat(figdir, figname))
 saveas (gcf, strcat(figdir, figname, '.png'))
 saveas (gcf, strcat(figdir, figname, '.pdf'))


