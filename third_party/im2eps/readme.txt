---------------------------------------------------------
im2eps: export directly Matlab 2D and 2Dx3 arrays as eps
---------------------------------------------------------



1) Description
2) Content
3) Installation
4) Use
5) Bugs, Limitations.
6) Boring part


1) Description:
===============
  Matlab can save/export figures to Encapsulated Postscript (EPS) files but 
  apparently lacks a "imwrite" mechanism to directly save a Matlab array 
  into an EPS file. Often it takes time to print figures into an EPS file,
  problems with white borders etc...
  This small package is the fruit of my frustration and of a few others in my lab
  and provide a matlab command, "writeeps", that finally does that, with a syntax 
  identical to imwrite: array + filename.
  The code has been adapted from a part of an ImageMagick source file "ps.c"
  Voila!



2) Content:
===========

  - im2eps.c Matlab mex function source file
  - im2eps.m Matlab m-function file to access im2eps mex file
  - writeeps.m the m-function to be used by user
  - License.txt: info about the Image Magick License
  - lgpl.txt: The GNU Lesser General Public License, so that the resulting
    code can be used commercially? Basically as long as it is used ethically, 
    I don't care.
  - readme.txt: this file!



3) Installation:
================
  Step 1. 
     Copy im2eps.c, im2eps.m and writeeps.m to a directory within Matlab path
     or wherever you want and add the directorty to matlab path.
  Step 2. 
     Once you have located your mex compiler or if already in the execuatble path, then
     compile im2eps.c from command line, while being in the directory where c and m files
     have been copied as

     $ path/to/mex im2eps.c

     or something like that. This should produce a file im2eps.dll on windows, 
     im2eps.mexglx on Linux, im2eps.??? who knows what on an other architecture.
     If you don't understand what I'm talking about, there is probably someone in 
     your surroundings that does, so ask!
     The source file im2eps.c is plain ANSI/ISO C, should not give you any trouble at 
     compilation. It does not require any fancy library or complicated tools, except, 
     of course, for Matlab header files! 
     You could compile it with your local C compiler directly, but don't, mex does it OK.
  Step 3. 
     You're done!



4) Use:
=======
  from Matlab prompt, assume array A contains your beautiful grayscale or RGB image you
  want to save as EPS, in a file named "pure_wonder.eps"

  >> writeeps(A,'pure_wonder.eps')

  This is it.
  If it does not work, you had probably a path problem? See previous and next paragraph.
  Your should NOT use im2eps.m directly from Matlab, as it expects some specific
  image data, and may result in a crash. Call it through writeeps which takes care
  of the correct format, data conversions.



5) Bugs, Limitations:
=====================
  Bugs: I don't know of any, but as Socrates used to say...
  in case something goes really wrong: mailto:francois@itu.dk
  Limitations: Works only for 2D grayscale and RGB images - array should be numerical
  non complex.



6) Boring part:
===============

  Author: Francois Lauze
  Copyright (C) 2005, 2006 the IT University of Copenhagen,
  with a portion from ImageMagick.
  License: The Gnu Lesser Public License (LGPL), see file lgpl.txt 
  and Image Magick portions are covered by the ImageMagick Licence,
  see file Licence.txt.
