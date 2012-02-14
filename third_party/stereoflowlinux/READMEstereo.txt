Stereo using diffuse connectivity (Matlab 7 code)
Abhijit Ogale (ogale@cs.umd.edu)
Computer Vision Lab, University of Maryland at College Park
http://www.cfar.umd.edu/users/ogale


Research code. Not for commercial use. 
If you use this code for results in your papers, please cite:

A roadmap to the integration of early visual modules, 
A. S. Ogale and Y. Aloimonos, 
International Journal of Computer Vision: Special Issue on Early Cognitive Vision


Usage:

 [bestshiftsL, occlL, bestshiftsR, occlR] = stereoCorrespondRobust(iLt, iRt, shiftrange, <alpha>);

Inputs:
 iLt = left image (color or grayscale)
 iRt = right image (color or grayscale)
 shiftrange = disparity search range, e.g. [0:15]
 alpha = (optional) smoothing parameter (range 5 to 50), default is 10

Outputs:
 bestshiftsL = left disparity map 
 occlL = left occlusions
 bestshiftsR = right disparity map 
 occlR = right occlusions


Example: (using the included images from the sawtooth sequence)

    iLt = imread('sawleft.tif'); 
    iRt = imread('sawright.tif'); 
    shiftrange = [-19:-4];
    [bestshiftsL, occlL, bestshiftsR, occlR] = stereoCorrespond(iLt, iRt, shiftrange);