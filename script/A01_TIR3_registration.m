% this register each folder individually 
close all
clear all
%% Location 2 (Moraine, USask Camera)
load('D:\2_IRPeyto\b_data_process\IntermediatepProduct\L3_ManualDownload.mat', 'L3')

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

%% tiR4 DO NOT NEED TO BE REGISTERED BUT STILL GET EXPORTED
load('D:\2_IRPeyto\b_data_process\TIR_process\RegisteredImage_Usask\USask_TIR_L4_zoom.mat')
for i=1:41
     dlmwrite(strcat('D:\2_IRPeyto\b_data_process\TIR_process\TIR4_reg\TIR4_reg_', char(TIR4_name(i)), '.txt'),TIR4_registered(:,:,i));
end 
