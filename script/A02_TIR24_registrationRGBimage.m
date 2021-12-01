 %% A3 - Regster the visible images aof the USask Cam
 % Moraine
 moving = imread('D:\2_IRPeyto\a_data_raw\tir\UsaskCameraLocationPhoto\Loc_Moraine.JPG');

imagesc(Rc6(:,:,200)); colormap('jet')
fixed = Rc6(:,:,200);
imagesc(fixed)
clear Rcrop;

figure;
cpselect (moving, mat2gray(fixed))

t_moving = fitgeotrans(movingPoints,fixedPoints,'projective');
ortho_ref = imref2d(size(fixed));
moving_reg = imwarp(moving, t_moving, 'OutputView', ortho_ref);
figure
imshowpair(moving_reg, fixed, 'montage')

VISreg_moraine=moving_reg;
CP_moraine = [movingPoints; fixedPoints];
save('D:\IRPeyto\IR_2019\data_process\TIR_process\Registration_Usask\VisualImage_Registered_Moraine.mat', 'VISreg_moraine', 'CP_moraine')
  %% Galcier 
moving = imread('D:\2_IRPeyto\a_data_raw\tir\UsaskCameraLocationPhoto\Loc2_2.JPG');
fixed = Rc2(:,:,10);
imagesc(fixed)
clear Rcrop;
figure;
subplot(1,2,1);
imagesc(fixed);
subplot(1,2,2);
imagesc(moving);
figure;
cpselect (moving, mat2gray(fixed))

t_moving = fitgeotrans(movingPoints,fixedPoints,'projective');
ortho_ref = imref2d(size(fixed));
moving_reg = imwarp(moving, t_moving, 'OutputView', ortho_ref);
figure
imshowpair(moving_reg, fixed, 'montage')

VISreg_glacier=moving_reg;
CP_glacier = [movingPoints, fixedPoints];
save('D:\IRPeyto\IR_2019\data_process\TIR_process\Registration_Usask\VisualImage_Registered_Glacier.mat', 'VISreg_glacier', 'CP_glacier')
 
 %% Zoom: 
moving = imread('D:\IRPeyto\IR_2019\data_raw\tir\UsaskCameraLocationPhoto\Loc4_2.JPG');
fixed = Rc5(:,:,10);
figure;
imshow(moving);
figure;
imagesc(fixed)
clear Rcrop;

figure;
cpselect (moving, mat2gray(fixed))

t_moving = fitgeotrans(movingPoints,fixedPoints,'projective');
ortho_ref = imref2d(size(fixed));
moving_reg = imwarp(moving, t_moving, 'OutputView', ortho_ref);
figure
imshowpair(moving_reg, fixed, 'montage')

VISreg_zoom=moving_reg;
CP_zoom = [movingPoints, fixedPoints];
save('D:\IRPeyto\IR_2019\data_process\TIR_process\Registration_Usask\VisualImage_Registered_Zoom.mat', 'VISreg_zoom', 'CP_zoom')
 
%% Now i have 3 visible regitrated images
imwrite(VISreg_glacier, 'D:\IRPeyto\IR_2019\data_process\TIR_process\Registration_Usask\VISreg_glacier.jpg')
imwrite(VISreg_moraine, 'D:\IRPeyto\IR_2019\data_process\TIR_process\Registration_Usask\VISreg_moraine.jpg')
imwrite(VISreg_zoom, 'D:\IRPeyto\IR_2019\data_process\TIR_process\Registration_Usask\VISreg_zoom.jpg')
