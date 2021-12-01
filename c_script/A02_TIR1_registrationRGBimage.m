%% Register a visible image to the IR one
% This script registers a visible RGB image to a infrared image to make point
% selecton easier to create a local reference frame of coordinates for
% TIR1-4

% set-up
clear all
close all

%% TIR1 
% Load cropped and registered TIR1 images
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat')
% select a RGB image from the raw camera output as the "moving image"
moving = imread('D:\2_IRPeyto\a_data_raw\tir\PeytoTIR1_20190805_20190809_5min\190808AE\AE080802.JPG');
% select a TIR1 image as the "fixed" image
fixed = TIR1_crop(:,:,400);
clear TIR1_crop

figure;
cpselect (moving, mat2gray(fixed)) % manually select control points
t_moving = fitgeotrans(movingPoints,fixedPoints,'projective');
ortho_ref = imref2d(size(fixed));
moving_reg = imwarp(moving, t_moving, 'OutputView', ortho_ref);

figure % check if image are aligned
imshowpair(moving_reg, fixed, 'montage')

% export output as matlab and rgb format
TIR1rgb_reg = moving_reg;
save('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR1_RGBreg.mat', 'TIR1rgb_reg')
imwrite(TIR1rgb_reg, 'D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR1rgb_reg.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TIR2
% Load cropped and registered TIR2 images
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR2_registered.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR2time.mat')
% select a RGB image as the moving image (the TIR rgb images where blurry)
moving = imread('D:\2_IRPeyto\a_data_raw\tir\RGBimage_TIRPeyto\TIR2_wideview.jpg');
% select a TIR1 image as the "fixed" image
fixed = TIR2_crop(:,:,200);
clear TIR2_crop

figure;
cpselect (moving, mat2gray(fixed)) % manually select control points
t_moving = fitgeotrans(movingPoints,fixedPoints,'projective');
ortho_ref = imref2d(size(fixed));
moving_reg = imwarp(moving, t_moving, 'OutputView', ortho_ref);

figure % check if image are aligned
imshowpair(moving_reg, fixed, 'montage')

% export output as matlab and rgb format
TIR2rgb_reg = moving_reg;
save('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR2_RGBreg.mat', 'TIR2rgb_reg')
imwrite(TIR1rgb_reg, 'D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR2_4\TIR2rgb_reg.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TIR3
% Load cropped and registered TIR2 images
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR3_registered.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR3time.mat')
% select a RGB image as the moving image (the TIR rgb images where blurry)
moving = imread('D:\2_IRPeyto\a_data_raw\tir\RGBimage_TIRPeyto\TIR3_wideview.jpg');
% select a TIR1 image as the "fixed" image
fixed = TIR3_crop(:,:,10);
clear TIR2_crop

figure;
cpselect (moving, mat2gray(fixed)) % manually select control points
t_moving = fitgeotrans(movingPoints,fixedPoints,'projective');
ortho_ref = imref2d(size(fixed));
moving_reg = imwarp(moving, t_moving, 'OutputView', ortho_ref);

figure % check if image are aligned
imshowpair(moving_reg, fixed, 'montage')

% export output as matlab and rgb format
TIR3rgb_reg = moving_reg;
save('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR3_RGBreg.mat', 'TIR3rgb_reg')
imwrite(TIR1rgb_reg, 'D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR3_4\TIR3rgb_reg.jpg')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TIR4
% Load cropped and registered TIR2 images
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR4_registered.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR4time.mat')
% select a RGB image as the moving image (the TIR rgb images where blurry)
moving = imread('D:\2_IRPeyto\a_data_raw\tir\RGBimage_TIRPeyto\TIR4_withcamera.JOG');
% select a TIR1 image as the "fixed" image
fixed = TIR4_crop(:,:,10);
clear TIR4_crop

figure;
cpselect (moving, mat2gray(fixed)) % manually select control points
t_moving = fitgeotrans(movingPoints,fixedPoints,'projective');
ortho_ref = imref2d(size(fixed));
moving_reg = imwarp(moving, t_moving, 'OutputView', ortho_ref);

figure % check if image are aligned
imshowpair(moving_reg, fixed, 'montage')

% export output as matlab and rgb format
TIR4rgb_reg = moving_reg;
save('D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR1_4\TIR4_RGBreg.mat', 'TIR4rgb_reg')
imwrite(TIR1rgb_reg, 'D:\2_IRPeyto\b_data_process\TIR_process\registeredRGB_TIR4_4\TIR4rgb_reg.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%