Flow using diffuse connectivity (Matlab 7 code)
Abhijit Ogale (ogale@cs.umd.edu)
Computer Vision Lab, University of Maryland at College Park
http://www.cfar.umd.edu/users/ogale


Research code. Not for commercial use. 
If you use this code for results in your papers, please cite:

A roadmap to the integration of early visual modules, 
A. S. Ogale and Y. Aloimonos, 
International Journal of Computer Vision: Special Issue on Early Cognitive Vision

Usage:

 [bestshiftsX, bestshiftsY, occlL, bestshiftsRX, bestshiftsRY, occlR] = flow(iLt, iRt, shiftrangeX, shiftrangeY, alpha)
 Created by: Abhijit Ogale (ogale@cs.umd.edu)

 Use for noncommercial research purposes only. Do not distribute.

 Usage:
 [x1, y1, o1, x2, y2, o2] = flow(i1, i2, shiftrangeX, shiftrangeY, alpha)

 i1 = image 1 (color or grayscale) 
 i2 = image 2 (color or grayscale)
 shiftrangeX = X-flow search range (using i1 as reference), e.g. [-5:5]
 shiftrangeY = Y-flow search range (using i1 as reference), e.g. [-5:5]
 alpha = (optional) sharpening parameter (range 5 to 50), default is 20
 (Note: if too many occlusions appear, try reducing alpha closer to 5 which increases smoothing)

 x1 = X-component of flow of image 1
 y1 = Y-component of flow of image 1
 o1 = occlusions in image 1
 x2 = X-component of flow of image 2
 y2 = Y-component of flow of image 2
 o2 = occlusions in image 2


Example: (using the included images from the flower-garden sequence)
  i1 = imread('car1.png');
  i2 = imread('car0.png');
  shiftrangeX = [0:18];
  shiftrangeY = [-3:0];
  [x1,y1,o1,x2,y2,o2] = flow (i1, i2, shiftrangeX, shiftrangeY);

