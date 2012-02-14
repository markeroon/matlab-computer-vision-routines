Epipolar Rectification Toolkit

Andrea Fusiello (andrea.fusiello@univr.it) 1999, 2003, 2007. 

The core routine is rectify.m, which implements  the algoritm
described in the reference paper below.

The MATLAB function "rectifyImageE.m." reads two images and the calibration
data and perform rectification. With respect to the algorihm described
in the reference paper, a trick is used here to keep the images
centered. In order to test it, type:
>> rectifyImageE('Sport')

In order to use the Rectification Toolkit the user must provide his own images
(a stereo pair) in the directory 'images' and the camera matrices in the directory
'data' (see example).

If calibration data is not available, you may want to use the "Uncalibrated 
Epipolar Rectification Toolkit" available from 
http://profs.sci.univr.it/\~fusiello/demo/rect.

The calibrated images in this distribution are copyrighted
by Syntim-INRIA. (http://www-syntim.inria.fr/syntim/analyse/paires-eng.html)


Reference paper:

@Article{FusTruVer99,
 author = 	 {A. Fusiello and E. Trucco and A. Verri},
  title = 	 {A Compact Algorithm for Rectification of Stereo Pairs},
  year = 	 {2000},
  journal = 	 {Machine Vision and Applications},
  volume = 	 {12},
  number = 	 {1},
  pages = 	 {16-22},
  pdf =          {http://profs.sci.univr.it/\~fusiello/papers/00120016.pdf}
}

-------------------------------------------------------------------------------
 
Part of this software was written by Andrea Fusiello while he
was with the Dipartimento di Matematica e Informatica, University of Udine.

Last modified 17/05/07

 
   			Andrea Fusiello

			Dipartimento di Informatica
			Universita' degli Studi di Verona  
			Ca' Vignal 2, Strada Le Grazie,  
			
			E-mail: andrea.fusiello@univr.it 
			Tel.: +39 (045) 802 7088 
			Fax:  +39 (045) 802 7928 
			HTTP: www.sci.univr.it/~fusiello/ 
