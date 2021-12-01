%% Image registration Usask
% this register each folder individually 
close all
clear all
%% Location 2 (Moraine, USask Camera)
load('D:\2_IRPeyto\b_data_process\TIR_process\IntermediatepProduct\TIR2_imageraw\L2_1_ManualDownload.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\IntermediatepProduct\TIR2_imageraw\L2_2_ManualDownload.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\IntermediatepProduct\TIR2_imageraw\L2_3_ManualDownload.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\IntermediatepProduct\TIR2_imageraw\L2_4_ManualDownload.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\IntermediatepProduct\TIR2_imageraw\L2_5_ManualDownload.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\IntermediatepProduct\TIR2_imageraw\L2_7_ManualDownload.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\IntermediatepProduct\TIR2_imageraw\L2_8_ManualDownload.mat')
load('D:\2_IRPeyto\b_data_process\TIR_process\IntermediatepProduct\TIR2_imageraw\L2_6_ManualDownload.mat')

% Fix some missing images
L2_2= L2_2 (:,:,[1:33, 33, 34:end]);
L2_7= L2_7 (:,:,[1:7, 7, 8:end]);
%% Registering Location 2
L2 = cat(3, L2_1, L2_2, L2_3, L2_4, L2_5, L2_6, L2_7, L2_8);
FIXED = L2(:,:,300);
imagesc(L2(:,:,300))
sz = size(L2);
for i = 1:sz(3)
    MOVING = L2(:,:,i);
[MOVINGREG, REGnn] = registerImages_Usask(MOVING,FIXED);
L2r(:,:,i)= REGnn;
i
end 
imagesc(FIXED)
%% movie
loops =339;
F(loops) = struct('cdata',[],'colormap',[]);
for j = 1:loops
    imagesc(L2r(:,:,j)); colorbar; colormap('jet'); caxis([-5 30]);
    title(num2str(j));
    drawnow
    F(j) = getframe(gcf);

end

% Save the images and export as txt file
load('D:\2_IRPeyto\b_data_process\TIR_process\TIR2_name.mat')
save ('D:\2_IRPeyto\b_data_process\TIR_process\TIR2_registered.mat', 'TIR2_registered');

for i=1:length(TIR2_registered)
     dlmwrite(strcat('D:\2_IRPeyto\b_data_process\TIR_process\TIR2_reg\TIR2_reg_', char(TIR2_name(i)), '.txt'),TIR2_registered(:,:,i));
end 