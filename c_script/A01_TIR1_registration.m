%% Register TIR1 images to correct for camera movement  
% This code co-register TIR1 images and crops them to the area of interest.
% This is done in 3 steps because of large movement when the camera
% batteries were changed. 
% Step 1: Automated registration for each group
    % batch 1: 1:279
    % batch 2: 280:868
    % batch 3: 869:1079
% Step 2: Control point registration between the images
% Step 3: Crop images

% Load the images
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_imageraw.mat')

%% Registration for batch 1 (1:279)
I = TIR1_imageraw(:,:,1:279);
FIXED = I(:,:,100);
sz = size(I);
for i = 1:sz(3)
 MOVING = I(:,:,i);
[MOVINGREG, REGnn] = registerImages(MOVING,FIXED);
Rc1(:,:,i)= REGnn;
toc
end

%%%  video to check if aligned worked
loops =279;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    imagesc(Rc1(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
    title(strcat('Image ', num2str(j)));
    
    drawnow
    F(j) = getframe(gcf);

end
clear I FIXED

%% Registration for batch 2 (280:868)
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

%%% video to check if alignment worked
loops =589;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    imagesc(Rc2_2(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
    title(strcat('Image ', num2str(j)));
    
    drawnow
    F(j) = getframe(gcf);

end
clear I FIXED

%% Registration for batch 3
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

%%% video to check if alignment worked
loops =211;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    imagesc(Rc2_2(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
    title(strcat('Image ', num2str(j)));
    
    drawnow
    F(j) = getframe(gcf);
end

%% Group image together and check video
Rc = cat(3, Rc1, Rc2, Rc3(:,:,1:211));
loops =1079;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    imagesc(Rc(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
    title(strcat('Image ', num2str(j)));
    
    drawnow
    F(j) = getframe(gcf);
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Step 2: Register them with control points
% Between Batch 1 and 2
% control point is done by selecting matching feature between the images. 
 cpselect(mat2gray(Rc1(:,:,279)),mat2gray( Rc2(:,:,1))); %saved as 'ControlPoints_TIR1_batch1tobatch2.mat'
 
% control points can be loaded as:
% load('D:\2_IRPeyto\b_data_process\parameter\ControlPoints_TIR1registration_batch1tobatch2.mat')

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

% Batch 3 to batch 2
% select control points
cpselect(mat2gray(Rc3(:,:,1)),mat2gray(Rc2(:,:,589))) %saved as ControlPoints_TIR1_batch2tobatch3.mat

% control points can be loaded from: 
% load('D:\2_IRPeyto\b_data_process\parameter\ControlPoints_TIR1registration_batch2tobatch3.mat')

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

% Checking the image alignment of the combined images
Rcc = cat(3, Rcc1, Rc2, Rcc3);% grup the 3 batches of image
loops =1079;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    imagesc(Rcc(:,:,j)); colorbar; colormap('jet'); caxis([260 310]);
    title(strcat('Image ', num2str(j)));
    drawnow
    F(j) = getframe(gcf);
end 

%% Step 3: Crop to a smaller area
rec = [0 100 1000 350]; % Select ROI
for i = 1:1079
I = Rcc(:,:,i);
J=imcrop(I, rec);
Rcrop(:,:,i)=J;
end 

TIR1_crop = Rcrop;

%% checking if the cropping worked with a short video
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
close (V)


%% Save outputs
save ('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop.mat', 'TIR1_crop')

% export each image as a .txt file
for i = 1:length(TIR1_crop);
     dlmwrite(strcat('D:\2_IRPeyto\b_data_process\TIR_process\TIR1_crop\TIR1_crop_', char(TIR1_name(i)), '.txt'),TIR1_crop(:,:,i))
end 


