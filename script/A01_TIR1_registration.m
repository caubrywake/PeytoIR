%  Image Registration for the TIR1 images

% by Caroline Aubry-Wake, last edited Feb 12, 2020
% This code co-register TIR images and crops them to the area of interest.

% this is done in 3 steps because the images moved
% Step 1: Automated registration to middle of each group
    % batch 1: 1:279
    % batch 2: 280:868
    % batch 3: 869:1079
% Step 2: Control point registration between the images
% Step 3: Crop images

% Load the images
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_imageraw.mat')

%% Batch 1 (1:2979)
I = TIR1_imageraw(:,:,1:279);
FIXED = I(:,:,100);
sz = size(I);
for i = 1:sz(3)
 MOVING = I(:,:,i);
[MOVINGREG, REGnn] = registerImages(MOVING,FIXED);
Rc1(:,:,i)= REGnn;
toc
end 
% video to check
% loops =278;
% F(loops) = struct('cdata',[],'colormap',[]);
% for j = 1:loops
%     imagesc(Rc1(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
%     title(strcat('Image ', num2str(j)));
%     
%     drawnow
%     F(j) = getframe(gcf);
% 
% end
clear I FIXED

%% Batch 2
I = TIR1_imageraw(:,:,280:868);
FIXED = I(:,:,300);
sz = size(I);
tic
for i = 1:sz(3)
    MOVING = I(:,:,i);
[MOVINGREG, REGnn] = registerImages(MOVING,FIXED);
Rc2(:,:,i)= REGnn;
i
toc
end 

% %video to check
% loops =589;
% F(loops) = struct('cdata',[],'colormap',[]);
% for j = 1:loops
%     imagesc(Rc2_2(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
%     title(strcat('Image ', num2str(j)));
%     
%     drawnow
%     F(j) = getframe(gcf);
% 
% end

% save ('D:\IRPeyto\IRPeyto_2019\Peyto IR fieldwork data\Analysis_IR\Test\Code\Rc2_Feb11.mat', 'Rc2');
clear I FIXED

%% Batch 3
I = TIR1_imageraw(:,:, 869:1079);
FIXED = I(:,:,100);
sz = size(I);
for i = 1:sz(3)
    MOVING = I(:,:,i);
[MOVINGREG, REGnn] = registerImages(MOVING,FIXED);
Rc3(:,:,i)= REGnn;
toc
i
end 
% save ('D:\IRPeyto\IRPeyto_2019\Peyto IR fieldwork data\Analysis_IR\Test\Code\Rc3_Feb11.mat', 'Rc3');

% %video to check
% loops =211;
% F(loops) = struct('cdata',[],'colormap',[]);
% for j = 1:loops
%     imagesc(Rc2_2(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
%     title(strcat('Image ', num2str(j)));
%     
%     drawnow
%     F(j) = getframe(gcf);
% 
% end

%% Group image together and check video
% Rc = cat(3, Rc1, Rc2, Rc3(:,:,1:211));
% loops =1079;
% F(loops) = struct('cdata',[],'colormap',[]);
% for j = 1:loops
%     imagesc(Rc(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
%     title(strcat('Image ', num2str(j)));
%     
%     drawnow
%     F(j) = getframe(gcf);
% end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Register them with control points
% load control poinrs
clear all
% Group 1 to group 2
load('D:\2_IRPeyto\b_data_process\TIR_process\ControlPoints_TIR1_batch1tobatch2.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\ControlPoints_TIR1_batch2tobatch3.mat')
load('D:\IRPeyto\IR_2019\data_process\TIR_process\Registration\TIR_image_registeredingroups.mat')

% I select the control poinst manually and save them
figure;
subplot(1,2,1); imagesc(Rc1(:,:,279)); caxis([260 290]); 
subplot(1,2,2); imagesc(Rc2(:,:,1)); caxis([260 290])

% cpselect(mat2gray(Rc1(:,:,279)),mat2gray( Rc2(:,:,1))); %svaed as 'ControlPoints_TIR1_batch1tobatch2.mat'
Rfixed = imref2d(size(Rc2(:,:,80)));% setting the view frame for the warped images
fixed = Rc2(:,:,80);

for i = 1:279
I = Rc1(:,:,i);
I(isnan(I))=0;%imwarp does not accept nan
tform = fitgeotrans(movingPoints,fixedPoints,'affine') ;
J=imwarp(I, tform,'OutputView',Rfixed);
J(J==0)=nan;
Rcc1(:,:,i)=J;
end 
figure;imshowpair(Rcc1(:,:,279), (Rc2(:,:,1))) % check alignment
clear Rc1

% 3 to 2
load('Rc_Feb12.mat', 'Rc3')
figure
subplot(1,2,1); imagesc(Rc2(:,:,589)); caxis([260 290]); 
subplot(1,2,2); imagesc(Rc3(:,:,1)); caxis([260 290])
% load control poinrs
load ('ControlPoints_Rc3_Rc2_Feb12.mat')
%cpselect(mat2gray(Rc3(:,:,1)),mat2gray(Rc2(:,:,589))) %saved as ControlPoints_TIR1_batch2tobatch3.mat
Rfixed = imref2d(size(Rc2(:,:,80)));
for i = 1:211
I = Rc3(:,:,i);
I(isnan(I))=0;%imwarp does not accept nan
tform = fitgeotrans(movingPointsR3,fixedPointsR3,'affine') ;
J=imwarp(I, tform,'OutputView',Rfixed);
J(J==0)=nan;
Rcc3(:,:,i)=J;
end 
figure;imshowpair(Rcc3(:,:,1), (Rc2(:,:,589)))% check alignment

% Checking the image alignment
Rcc = cat(3, Rcc1, Rc2, Rcc3);% grup the 3 batches of image
loops =1079;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    imagesc(Rcc(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
    title(strcat('Image ', num2str(j)));
    drawnow
    F(j) = getframe(gcf);
end 

%% Crop to a smaller area
rec = [0 100 1000 350];
for i = 1:1079
I = Rcc(:,:,i);
J=imcrop(I, rec);
Rcrop(:,:,i)=J;
end 

TIR1_crop = Rcrop;
save ('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_Registered_Cropped.mat', 'TIR1_crop')

% export each image as a .txt file
for i = 1:length(TIR1_crop);
     dlmwrite(strcat('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop\TIR1_crop_', char(TIR1_name(i)), '.txt'),TIR1_crop(:,:,i))
end 


% checking if the cropping worked
loops =1079;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 2:loops
    imagesc(Rcrop(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
    title(cellstr(DTst(j)));
    
    drawnow
    F(j) = getframe(gcf);
end 
V = VideoWriter('IR_Video.avi','Motion JPEG AVI');
open(V)
writeVideo(V, F)
close (V)%% Dont forget to save manually - the files are too big for this version of matlab.