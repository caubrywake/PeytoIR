%% Register TIR3-4 images to correct for camera movement  
% This code co-register TIR3 images 

% set-up
close all
clear all

%% Location 3 (Glacier, USask Camera)
load('D:\2_IRPeyto\b_data_process\IntermediateProduct\L3.mat', 'L3')

%% Registering Location 3
FIXED = L3(:,:,8);
imagesc(L3(:,:,8))
sz = size(L3);
for i = 1:sz(3)
    MOVING = L3(:,:,i);
[MOVINGREG, REGnn] = registerImages_Usask(MOVING,FIXED);
L3r(:,:,i)= REGnn;
i
end 
imagesc(FIXED)
%% movie
loops =41;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    imagesc(L3r(:,:,j)); colorbar; colormap('jet'); caxis([-5 30]);
    title(num2str(j));
    drawnow
    F(j) = getframe(gcf);

end

% Save the images
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR3_name.mat')
save ('D:\2_IRPeyto\b_data_process\TIR_process\TIR3_registered.mat', 'TIR3_registered');

for i=1:41
     dlmwrite(strcat('D:\2_IRPeyto\b_data_process\TIR_process\TIR3_reg\TIR3_reg_', char(TIR3_name(i)), '.txt'),TIR3_registered(:,:,i));
end 

%% TIR4 
% TIR 4 does not need to be registered as the duration was very short, but to keep the fromatting consistent, we still export them. 

load('D:\2_IRPeyto\b_data_process\IntermediateProduct\L4.mat', 'L4')
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR4_name.mat')

for i=1:41
     dlmwrite(strcat('D:\2_IRPeyto\b_data_process\TIR_process\TIR4_reg\TIR4_reg_', char(TIR4_name(i)), '.txt'),TIR4_registered(:,:,i));
end 
