# PeytoIR
The script for the analysis of the TIR imagery on the debris-covered glacial ice at Peyto Glacier. 

The script folder (c_script)  contains the matlab scripts to :

1. register the .asc images to correct for camera movement and register a visual image to the TIR images (AXX scripts)
2. extract the TIR surface temperature at the locatio of the point measurement of debris thickness (BXX scripts)
3. interpolate debris thickness across the study slope (CXX scripts)
4. analyse the empirical relationship between surface temperature and debris thickness (DXX scripts)
5. process and display the MET data during the experiment (EXX script)

The parameter folder includes data used in the analysis, such as control points during image registration or location of the pit in the TIR images, as well as intermediry data that facilitates further analysis, such as the interpolated debris thickness. The folder registeredRGB_TIR1_4 contains registered RGB images corresponding to the TIR images.

The TIR images, both raw and registered, are available at:https://www.hydroshare.org/resource/d2768996e761412381c2051b99d02c87/  
The Peyto AWS data is available at:https://www.hydroshare.org/resource/d2768996e761412381c2051b99d02c87/, and related to: https://essd.copernicus.org/articles/13/2875/2021/essd-13-2875-2021.html  
The manual excavations data is available at:https://www.hydroshare.org/resource/d2768996e761412381c2051b99d02c87/  

