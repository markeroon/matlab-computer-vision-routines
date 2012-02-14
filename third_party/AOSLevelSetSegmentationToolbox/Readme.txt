The Matlab toolbox for 2D/3D image segmentation using level-set based active contour/surface with AOS scheme was developed by Yan Zhang during his post-doctorial research in the ADSIP Centre at the University of Central Lancashire sponsored by the EPSRC-funded MEGURATH and ECSON projects (www.megurath.org and www.ecson.org). 
 Features of the toolbox: 
(1)	The toolbox includes classic level-set methods such as geodesic active contours (GAC), Chan-Vese model and a hybrid model combining the boundary and regional terms.
(2)	All the methods are implemented with the semi-implicit solver AOS which can guarantee the stability of the numerical methods even with very large time steps, thus boosting the efficiency for level-set based segmentation.
(3)	All the methods can be applied to 2D and 3D data.
Software requirement: Matlab version 7 or later with Image Processing Toolbox. The medical data [1] is included only for the demonstration purposes.
To get started with the toolbox, you can run and study the programs with names starting with “test_” and the examples included in the help of each major function. All the data needed for these programs and examples are either in the “\data” folder of this toolbox or in the Matlab default path associated with Image Processing Toolbox.  All the C++ codes essential for the performances of the toolbox are included in the “\mex” folder.  If there are any problems regarding the mex files, please use the Matlab script “\mex\ compile_mex_codes.m” to re-compile all the C++ codes with your local compiler, the generated mex files will be automatically moved to the “\private” folder. 
NOTE: Academic and educational uses are highly encouraged, whereas commercial uses without permissions are forbidden.  Although the toolbox has been carefully tested on a few different machines with different versions of Matlab, no warranty can be given to any part of the programs.  If this toolbox can directly lead to any publications, a brief mention of the toolbox and a reference to the paper [2] will be truly appreciated. Please feel free to contact me if there are any bugs, comments, extensions and new ideas. With your help and feedback, we can make the toolbox better in the later versions.  

A few steps for quick start:
1. Go to the '\mex' folder and run compile_mex_codes.m to generate the necessary mex files. The generated mex files will be automatically moved to the '\private' folder. (Use 'mex -setup' to select a c++ compiler if necessary.) 
2. Include the '\data' folder in the matlab path. 
3. Run test_ChanVese_model_3d.m and test_hybrid_model_3d.m.

A more complete toolbox with mex files generated in the Windows system can be downloaded from the following link:  
http://ecson.org/resources/active_contour_segmentation.html


Author: Yan ZHANG.
ADSIP Research Centre, University of Central Lancashire, Preston, UK
Email: zhangyan.academia@googlemail.com 


Reference:
[1]The CT medical data was kindly made available by The Christie Hospital, Withington,  Manchester, UK for use in the EPSRC funded MEGURATH project. 
Where the data is utilised in presentations, publications or other dissemination activity The Christie Hospital must be acknowledged’
[2] Y. Zhang, B. J. Matuszewski, L.-K. Shark, and C. J. Moore. Medical Image Segmentation Using New Hybrid Level-Set Method. IEEE International Conference on Biomedical Visualisation, MEDi08VIS, London, pp.71-76, July, 2008.

