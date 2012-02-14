OpenVis3D: Open Source 3D Vision Library

The goal of this project is to provide a library of efficient 3D computer vision routines for image and video processing. It currently includes routines for dense stereo matching, optical flow (motion) estimation, occlusion detection, and egomotion (3D self-motion) estimation.

**********************************************************
Copyright 2006 Abhijit Ogale 

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
**********************************************************

Contributors: 
Abhijit Ogale (http://www.cs.umd.edu/users/ogale): 
-- Overall library design, Dense stereo and optical flow code.
Justin Domke (http://www.cs.umd.edu/users/domke)
-- 3D egomotion estimation.

**********************************************************

Documentation:

http://www.cs.umd.edu/users/ogale/openvis3d/docs/index.html

**********************************************************
Examples showing how to use the library:
**********************************************************
A) OpenCV Example:
**********************************************************
A sample program OpencvExample.cpp which tests the stereo and optical flow code on the included image pairs is provided. A Makefile is also provided. This particular example uses OpenCV, hence please modify the following lines of the Makefile to suit your OpenCV installation:

  * Change include path: 
    INC = -I /usr/include/opencv

  * Change the library path and the names of the libraries if needed:
    LDFLAGS = -L /usr/lib -L . -lm -lcv -lhighgui -lcvaux

**********************************************************
B) Matlab Examples:
**********************************************************
1) STEREO

OvStereoMatlab.cpp shows how the stereo algorithm can be called from Matlab. It first be compiled into mex files using Matlab by going to the directory containing OpenVis3D and running the following command within Matlab:

mex OvStereoMatlab.cpp MatlabImageAdapter.cpp OvImageAdapter.cpp

Once the mex file is created, you can execute the stereo algorithm on the supplied images as follows in Matlab:

i1 = imread('tsukuba1color.png'); 
i2 = imread('tsukuba2color.png');
minshift = 5;
maxshift = 15;
[bestshiftsL, occlL, bestshiftsR, occlR] = OvStereoMatlab(i1, i2, minshift, maxshift);

% To display results, you can run the following commands:

figure; imagesc(bestshiftsL); 
figure; imagesc(bestshiftsR);
figure; imagesc(occlL);
figure; imagesc(occlR);

*****************************
2) OPTICAL FLOW

OvFlowMatlab.cpp shows how the optical flow algorithm can be called from Matlab. It first be compiled into mex files using Matlab by going to the directory containing OpenVis3D and running the following command within Matlab:

mex OvFlowMatlab.cpp MatlabImageAdapter.cpp OvImageAdapter.cpp

Once the mex file is created, you can execute the optical flow algorithm on the supplied images as follows in Matlab:

i1 = imread('car1.png'); 
i2 = imread('car0.png');
minshiftX = 0;
maxshiftX = 18;
minshiftY = -3; 
maxshiftY = 0;
[bestshiftsLX, bestshiftsLY, occlL, bestshiftsRX, bestshiftsRY, occlR] = OvFlowMatlab(i1, i2, minshiftX, maxshiftX, minshiftY, maxshiftY);

% To display results, you can use the following commands:
figure; imagesc(bestshiftsLX);
figure; imagesc(bestshiftsLY);
figure; imagesc(bestshiftsRX);
figure; imagesc(bestshiftsRY);
figure; imagesc(occlL);
figure; imagesc(occlR);

