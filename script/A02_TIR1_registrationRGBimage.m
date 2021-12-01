%% Register a visible image to the IR one
% by Caroline Aubry-Wake, Feb 12
% This is to register a visible image to the infrared image to make point
% slecton easier to create a locla reference frame of coordinates

clear all
close all

load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_time_name.mat')
moving = imread('D:\2_IRPeyto\a_data_raw\tir\PeytoTIR1_20190805_20190809_5min\190808AE\AE080802.JPG');

fixed = TIR1_crop(:,:,400);
imagesc(fixed)
clear Rcrop;

figure;
cpselect (moving, mat2gray(fixed)) % manually select control points

t_moving = fitgeotrans(movingPoints,fixedPoints,'projective');
ortho_ref = imref2d(size(fixed));
moving_reg = imwarp(moving, t_moving, 'OutputView', ortho_ref);
figure
imshowpair(moving_reg, fixed, 'montage')

VISreg=moving_reg;
save('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_RGBreg.mat', 'TIR1_RGBreg')
imwrite(TIR1_RGBreg, 'D:\2_IRPeyto\b_data_process\TIR_process\TIR1_RGBreg.jpg')