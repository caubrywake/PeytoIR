function [MOVINGREG, REGnn] = registerImages(MOVING,FIXED)
%registerImages  Register grayscale images using auto-generated code from Registration Estimator app.
%  [MOVINGREG] = registerImages(MOVING,FIXED) Register grayscale images
%  MOVING and FIXED using auto-generated code from the Registration
%  Estimator App. The values for all registration parameters were set
%  interactively in the App and result in the registered image stored in the
%  structure array MOVINGREG.

% Auto-generated by registrationEstimator app on 10-Jan-2020
%-----------------------------------------------------------

% Normalize FIXED image

% Get linear indices to finite valued data
finiteIdx = isfinite(FIXED(:));

% Replace NaN values with 0
FIXED(isnan(FIXED)) = 0;

% Replace Inf values with 1
FIXED(FIXED==Inf) = 1;

% Replace -Inf values with 0
FIXED(FIXED==-Inf) = 0;

% Normalize input data to range in [0,1].
FIXEDmin = min(FIXED(:));
FIXEDmax = max(FIXED(:));
if isequal(FIXEDmax,FIXEDmin)
    FIXED = 0*FIXED;
else
    FIXED(finiteIdx) = (FIXED(finiteIdx) - FIXEDmin) ./ (FIXEDmax - FIXEDmin);
end

% Normalize MOVING image

% Get linear indices to finite valued data
finiteIdx = isfinite(MOVING(:));

% Replace NaN values with 0
MOVING(isnan(MOVING)) = 0;

% Replace Inf values with 1
MOVING(MOVING==Inf) = 1;

% Replace -Inf values with 0
MOVING(MOVING==-Inf) = 0;

% Normalize input data to range in [0,1].
MOVINGmin = min(MOVING(:));
MOVINGmax = max(MOVING(:));
if isequal(MOVINGmax,MOVINGmin)
    MOVING = 0*MOVING;
else
    MOVING(finiteIdx) = (MOVING(finiteIdx) - MOVINGmin) ./ (MOVINGmax - MOVINGmin);
end

% Default spatial referencing objects
fixedRefObj = imref2d(size(FIXED));
movingRefObj = imref2d(size(MOVING));

% Intensity-based registration
[optimizer, metric] = imregconfig('multimodal');
metric.NumberOfSpatialSamples = 500;
metric.NumberOfHistogramBins = 50;
metric.UseAllPixels = true;
optimizer.GrowthFactor = 1.050000;
optimizer.Epsilon = 1.50000e-06;
optimizer.InitialRadius = 6.25000e-04;
optimizer.MaximumIterations = 300;

% Align centers
fixedCenterXWorld = mean(fixedRefObj.XWorldLimits);
fixedCenterYWorld = mean(fixedRefObj.YWorldLimits);
movingCenterXWorld = mean(movingRefObj.XWorldLimits);
movingCenterYWorld = mean(movingRefObj.YWorldLimits);
translationX = fixedCenterXWorld - movingCenterXWorld;
translationY = fixedCenterYWorld - movingCenterYWorld;

% Coarse alignment
initTform = affine2d();
initTform.T(3,1:2) = [translationX, translationY];

% Apply transformation
tform = imregtform(MOVING,movingRefObj,FIXED,fixedRefObj,'affine',optimizer,metric,'PyramidLevels',3,'InitialTransformation',initTform);
MOVINGREG.Transformation = tform;
MOVINGREG.RegisteredImage = imwarp(MOVING, movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true);

% Store spatial referencing object
MOVINGREG.SpatialRefObj = fixedRefObj;

% Undoing the normlization to get temperature
REG = MOVINGREG.RegisteredImage;
REGnn(finiteIdx) = REG(finiteIdx)*  (MOVINGmax- MOVINGmin) + MOVINGmin;
REGnn(REGnn<=MOVINGmin)=nan;
REGnn = reshape(REGnn, 768, 1024);

end

