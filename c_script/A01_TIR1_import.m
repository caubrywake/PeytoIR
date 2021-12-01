%% A1: Preprocessing -  Import TIR1 images, and names/time of images
close all
clear all

cd('D:\2_IRPeyto\')
addpath(genpath('D:\2_IRPeyto\'));

%% Import .asci files
% Note: The names and time are imported from the .irb images (raw files),
% but the actual measurement (surface T) are imported form .asc files that
% were exported form the variocam software.

close all
clear all
files = dir('D:\2_IRPeyto\a_data_raw\tir\PeytoTIR1_20190805_20190809_5min\1*') ;%get the names of all the folders

% for each folder
for ii =1:length(files);
FolderName = files(ii).name;
fileList = dir(strcat('D:\2_IRPeyto\a_data_raw\tir\PeytoTIR1_20190805_20190809_5min\',FolderName, '\*.irb'));
ImageTime = datetime({fileList.date})';% extract the time and change to datetime format
ImageName = char({fileList.name}'); ImageName= string(ImageName(1:length(ImageName), 1:8)); %remove .irb extension

% append the names and time for all the folders
if ii == 1;
   TIR1_time = ImageTime;
   TIR1_name = ImageName;
else
    TIR1_time = [TIR1_time;ImageTime];
    TIR1_name = [TIR1_name; ImageName];
end 
end 
% save outputs
save ('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat', 'TIR1_time','TIR1_name')
T = table(TIR1_time,TIR1_name);
writetable(T, 'D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.txt')

%% import TIR image 
files = dir('D:\2_IRPeyto\b_data_process\TIR_process\AsciImage_TIR1\*.asc')
fn = {files.name}'; fn = string(fn); %obtain the namelist of all the images

% Import the image in a cube 
for i = 1:length(fn)
     TIRimage(:,:,i)= importfile(fn(i), 2, 769);
end
% TIR1_image is saved manually in matlab format as D:\2_IRPeyto\b_data_process\TIR_process\TIR1_raw.mat

%% import time and file name from the IRB files
close all
clear all
files = dir('D:\IRPeyto\IR_2019\data_raw\tir\McGill\1*') ;%get the names of all the folders

% for each folder
for ii =1:length(files);
FolderName = files(ii).name;
fileList = dir(strcat('D:\IRPeyto\IR_2019\data_raw\tir\McGill\',FolderName, '\*.irb'));
ImageTime = datetime({fileList.date})';% extract the time and change to datetime format
ImageName = char({fileList.name}'); ImageName= string(ImageName(1:length(ImageName), 1:8)); %remove .irb extension

% append the names and time for all the folders
if ii == 1;
   TIRtime = ImageTime;
   TIRname = ImageName;
else
    TIRtime = [TIRtime;ImageTime];
    TIRname = [TIRname; ImageName];
end 
end 
save ('D:\IRPeyto\IR_2019\data_process\TIR_process\McGill_TIR_time_name.mat', 'TIRtime','TIRname')