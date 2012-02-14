/***********************************************************************
 * im2eps                                                              *
 * ------                                                              *
 * A MatLab external function that saves a 2D grayscale/color image to *
 * an encapsulated postscript file.                                    *
 * The way it is done is simply by reusing the postscript code         *
 * produced by ImageMagick, with for instance the convert command      * 
 * line tool.                                                          *
 * I'm not as smart as ImageMagick in the sense that I do not try      *
 * to use a compact representation for the output if gray values are   *
 * in a range smaller than {0,...,255}.                                *
 *                                                                     *
 * This is an "internal" function, i.e. im2ps should not be used       *
 * directly but through the "driver" function writeeps that will take  *
 * care of some of the annoying details that are straightforward to    *
 * write down in Matlab.                                               *
 * Basically, im2ps expect an uint8 class matlab array of the correct  *
 * dimensions, and it's easier do deal with that in Matlab than in     *
 * plain C.
 *                                                                     *
 * For ImageMagick stuffs, see: http://www.imagemagick.org.            *
 * I do not think I violate ImageMagick license when doing so, see     *
 * the license at http://www.imagemagick.org/script/license.php.       *
 *                                                                     *
 * License for that one: LGPL, http://www.gnu.org/copyleft/lesser.html *
 * with portions of the code borrowed from ImageMagick covered by the  *
 * above mentioned one.                                                *
 * Basically I don't care what will happen to that code but at least,  *
 * "Redde Caesari quae sunt Caesaris..." is always a good practice.    *
 * Author: Francois Lauze.                                             *
 * Copyright 2005, The IT University of Copenhagen.                    *
 ***********************************************************************/


/* matlab external functions header file */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <mex.h>

#define MAXFILENAMELEN 1023
#define MAXDATALINELEN   36

#define BADIMAGE     0
#define COLORIMAGE   1
#define GRAYIMAGE    2


/* eps_prolog: this is the part that comes from ImageMagick! 
 * see the file ps2.c in image magick source distribution.
 * This is the list of of parameters to be replaced in the following eps_header string.
 * 1. %s: title
 * 2. %s: date
 * 3. %d: width
 * 4. %d: height
 * 5. %d: width
 * 6. %d: height
 * 7. %d: width
 * 8. %d: height
 * 9. %d: width
 * 10.%d: height
 * 11.%d: width
 * 12.%d: height
 */

char *eps_prolog = 
	"%%!PS-Adobe-3.0 EPSF-3.0\n"
	"%%%%Creator: (Matlab mex function im2eps.m)\n"
	"%%%%Title: (%s)\n"
	"%%%%CreationDate: (%s)\n"
	"%%%%BoundingBox: 0 0 %d %d\n"
	"%%%%HiResBoundingBox: 0 0 %d %d\n"
	"%%%%DocumentData: Clean7Bit\n"
	"%%%%LanguageLevel: 1\n"
	"%%%%Pages: 1\n"
	"%%%%EndComments\n"
	"\n"
	"%%%%BeginDefaults\n"
	"%%%%EndDefaults\n"
	"\n"
	"%%%%BeginProlog\n"
	"%%\n"
	"%% Display a color image.  The image is displayed in color on\n"
	"%% Postscript viewers or printers that support color, otherwise\n"
	"%% it is displayed as grayscale.\n"
	"%%\n"
	"/DirectClassPacket\n"
	"{\n"
	"  %%\n"
	"  %% Get a DirectClass packet.\n"
	"  %%\n"
	"  %% Parameters:\n"
	"  %%   red.\n"
	"  %%   green.\n"
	"  %%   blue.\n"
	"  %%   length: number of pixels minus one of this color (optional).\n"
	"  %%\n"
	"  currentfile color_packet readhexstring pop pop\n"
	"  compression 0 eq\n"
	"  {\n"
	"    /number_pixels 3 def\n"
	"  }\n"
	"  {\n"
	"    currentfile byte readhexstring pop 0 get\n"
	"    /number_pixels exch 1 add 3 mul def\n"
	"  } ifelse\n"
	"  0 3 number_pixels 1 sub\n"
	"  {\n"
	"    pixels exch color_packet putinterval\n"
	"  } for\n"
	"  pixels 0 number_pixels getinterval\n"
	"} bind def\n"
	"\n"
	"/DirectClassImage\n"
	"{\n"
	"  %%\n"
	"  %% Display a DirectClass image.\n"
	"  %%\n"
	"  systemdict /colorimage known\n"
	"  {\n"
	"    columns rows 8\n"
	"    [\n"
	"      columns 0 0\n"
	"      rows neg 0 rows\n"
	"    ]\n"
	"    { DirectClassPacket } false 3 colorimage\n"
	"  }\n"
	"  {\n"
	"    %%\n"
	"    %% No colorimage operator;  convert to grayscale.\n"
	"    %%\n"
	"    columns rows 8\n"
	"    [\n"
	"      columns 0 0\n"
	"      rows neg 0 rows\n"
	"    ]\n"
	"    { GrayDirectClassPacket } image\n"
	"  } ifelse\n"
	"} bind def\n"
	"\n"
	"/GrayDirectClassPacket\n"
	"{\n"
	"  %%\n"
	"  %% Get a DirectClass packet;  convert to grayscale.\n"
	"  %%\n"
	"  %% Parameters:\n"
	"  %%   red\n"
	"  %%   green\n"
	"  %%   blue\n"
	"  %%   length: number of pixels minus one of this color (optional).\n"
	"  %%\n"
	"  currentfile color_packet readhexstring pop pop\n"
	"  color_packet 0 get 0.299 mul\n"
	"  color_packet 1 get 0.587 mul add\n"
	"  color_packet 2 get 0.114 mul add\n"
	"  cvi\n"
	"  /gray_packet exch def\n"
	"  compression 0 eq\n"
	"  {\n"
	"    /number_pixels 1 def\n"
	"  }\n"
	"  {\n"
	"    currentfile byte readhexstring pop 0 get\n"
	"    /number_pixels exch 1 add def\n"
	"  } ifelse\n"
	"  0 1 number_pixels 1 sub\n"
	"  {\n"
	"    pixels exch gray_packet put\n"
	"  } for\n"
	"  pixels 0 number_pixels getinterval\n"
	"} bind def\n"
	"\n"
	"/GrayPseudoClassPacket\n"
	"{\n"
	"  %%\n"
	"  %% Get a PseudoClass packet;  convert to grayscale.\n"
	"  %%\n"
	"  %% Parameters:\n"
	"  %%   index: index into the colormap.\n"
	"  %%   length: number of pixels minus one of this color (optional).\n"
	"  %%\n"
	"  currentfile byte readhexstring pop 0 get\n"
	"  /offset exch 3 mul def\n"
	"  /color_packet colormap offset 3 getinterval def\n"
	"  color_packet 0 get 0.299 mul\n"
	"  color_packet 1 get 0.587 mul add\n"
	"  color_packet 2 get 0.114 mul add\n"
	"  cvi\n"
	"  /gray_packet exch def\n"
	"  compression 0 eq\n"
	"  {\n"
"    /number_pixels 1 def\n"
"  }\n"
"  {\n"
"    currentfile byte readhexstring pop 0 get\n"
"    /number_pixels exch 1 add def\n"
"  } ifelse\n"
"  0 1 number_pixels 1 sub\n"
"  {\n"
"    pixels exch gray_packet put\n"
"  } for\n"
"  pixels 0 number_pixels getinterval\n"
"} bind def\n"
"\n"
"/PseudoClassPacket\n"
"{\n"
"  %%\n"
"  %% Get a PseudoClass packet.\n"
"  %%\n"
"  %% Parameters:\n"
"  %%   index: index into the colormap.\n"
"  %%   length: number of pixels minus one of this color (optional).\n"
"  %%\n"
"  currentfile byte readhexstring pop 0 get\n"
"  /offset exch 3 mul def\n"
"  /color_packet colormap offset 3 getinterval def\n"
"  compression 0 eq\n"
"  {\n"
"    /number_pixels 3 def\n"
"  }\n"
"  {\n"
"    currentfile byte readhexstring pop 0 get\n"
"    /number_pixels exch 1 add 3 mul def\n"
"  } ifelse\n"
"  0 3 number_pixels 1 sub\n"
"  {\n"
"    pixels exch color_packet putinterval\n"
"  } for\n"
"  pixels 0 number_pixels getinterval\n"
"} bind def\n"
"\n"
"/PseudoClassImage\n"
"{\n"
"  %%\n"
"  %% Display a PseudoClass image.\n"
"  %%\n"
"  %% Parameters:\n"
"  %%   class: 0-PseudoClass or 1-Grayscale.\n"
"  %%\n"
"  currentfile buffer readline pop\n"
"  token pop /class exch def pop\n"
"  class 0 gt\n"
"  {\n"
"    currentfile buffer readline pop\n"
"    token pop /depth exch def pop\n"
"    /grays columns 8 add depth sub depth mul 8 idiv string def\n"
"    columns rows depth\n"
"    [\n"
"      columns 0 0\n"
"      rows neg 0 rows\n"
"    ]\n"
"    { currentfile grays readhexstring pop } image\n"
"  }\n"
"  {\n"
"    %%\n"
"    %% Parameters:\n"
"    %%   colors: number of colors in the colormap.\n"
"    %%   colormap: red, green, blue color packets.\n"
"    %%\n"
"    currentfile buffer readline pop\n"
"    token pop /colors exch def pop\n"
"    /colors colors 3 mul def\n"
"    /colormap colors string def\n"
"    currentfile colormap readhexstring pop pop\n"
"    systemdict /colorimage known\n"
"    {\n"
"      columns rows 8\n"
"      [\n"
"        columns 0 0\n"
"        rows neg 0 rows\n"
"      ]\n"
"      { PseudoClassPacket } false 3 colorimage\n"
"    }\n"
"    {\n"
"      %%\n"
"      %% No colorimage operator;  convert to grayscale.\n"
"      %%\n"
"      columns rows 8\n"
"      [\n"
"        columns 0 0\n"
"        rows neg 0 rows\n"
"      ]\n"
"      { GrayPseudoClassPacket } image\n"
"    } ifelse\n"
"  } ifelse\n"
"} bind def\n"
"\n"
"/DisplayImage\n"
"{\n"
"  %%\n"
"  %% Display a DirectClass or PseudoClass image.\n"
"  %%\n"
"  %% Parameters:\n"
"  %%   x & y translation.\n"
"  %%   x & y scale.\n"
"  %%   label pointsize.\n"
"  %%   image label.\n"
"  %%   image columns & rows.\n"
"  %%   class: 0-DirectClass or 1-PseudoClass.\n"
"  %%   compression: 0-none or 1-RunlengthEncoded.\n"
"  %%   hex color packets.\n"
"  %%\n"
"  gsave\n"
"  /buffer 512 string def\n"
"  /byte 1 string def\n"
"  /color_packet 3 string def\n"
"  /pixels 768 string def\n"
"\n"
"  currentfile buffer readline pop\n"
"  token pop /x exch def\n"
"  token pop /y exch def pop\n"
"  x y translate\n"
"  currentfile buffer readline pop\n"
"  token pop /x exch def\n"
"  token pop /y exch def pop\n"
"  currentfile buffer readline pop\n"
"  token pop /pointsize exch def pop\n"
"  /Times-Roman findfont pointsize scalefont setfont\n"
"  x y scale\n"
"  currentfile buffer readline pop\n"
"  token pop /columns exch def\n"
"  token pop /rows exch def pop\n"
"  currentfile buffer readline pop\n"
"  token pop /class exch def pop\n"
"  currentfile buffer readline pop\n"
"  token pop /compression exch def pop\n"
"  class 0 gt { PseudoClassImage } { DirectClassImage } ifelse\n"
"  grestore\n"
"} bind def\n"
"%%%%EndProlog\n"
"%%%%Page:  1 1\n"
"%%%%PageBoundingBox: 0 0 %d %d\n"
"userdict begin\n"
"DisplayImage\n"
"0 0\n"
"%d %d\n"
"12.000000\n"
"%d %d\n";

char *eps_epilog = "end\n%%%%PageTrailer\n%%%%Trailer\n%%%%EOF\n";

/* check wether the image is a valid one, i.e. of 
 * dimensions MxNxC, C = 1 or 3, class uint8 and if
 * ok gets its width and height.
 */
static int check_image(const mxArray *mImg, int *width, int *height)
{
	int ndims, imgtype = BADIMAGE;
	const int *dimarray = mxGetDimensions(mImg);
	if (mxGetClassID(mImg) != mxUINT8_CLASS) return BADIMAGE;
	if ((ndims = mxGetNumberOfDimensions(mImg)) > 3) return BADIMAGE;
	
	if (ndims == 3) {
		if (dimarray[2] != 3) return BADIMAGE;
		imgtype = COLORIMAGE;
	} else imgtype = GRAYIMAGE;
	*width = dimarray[1];
	*height = dimarray[0];
	return imgtype;
}


/* check wether the filename argument appears to be a legal one */
static char *get_filename(const mxArray *mString)
{
	static char filename[MAXFILENAMELEN+1];
	int   buflen;
	filename[0] = 0;
    
	if (mxIsChar(mString) != 1) return 0;

	/* Input must be a row vector. */
	if (mxGetM(mString) != 1) return 0;
    
	/* Get the length of the input string. */
	buflen = mxGetN(mString) + 1;
	if (buflen > MAXFILENAMELEN) return 0;

	/* Copy the string data from mString into C string filename */
	if (mxGetString(mString, filename, buflen) != 0) return 0;
	return filename;
}

/* my smart call to printf produces some undefined behaviours, so I recreate the hexa string myself */
static char *hexabyte(unsigned char val)
{
	static char hexa[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
	static char hbyte[3];
	hbyte[2] = 0;
	hbyte[0] = hexa[val / 16];
	hbyte[1] = hexa[val % 16];
	return hbyte;
}

/* write the ascii hexa representation of the content of the grayscale image to output file */
static void write_gray_image_data(const mxArray *mImg, int width, int height, FILE *fp)
{
	/* usual mess about dimensions fo matlab */
	int i, j, l;
	const unsigned char *val = (const unsigned char *)mxGetPr(mImg);
	
	/* before writing pixel values, say, it will be a grayscale image to postscript interpreter */
	/* also from ImageMagick */
	fprintf(fp,"1\n1\n1\n8\n");
	
	l = 0; /* used for jumping to a new line when necessary */
	for (j = 0; j < height; ++j) {
		for (i = 0; i < width; ++i) {
			if (l == MAXDATALINELEN) {
				l = 0;
				fprintf(fp, "\n");
			}
			++l;
			fprintf(fp,"%s",hexabyte(val[i*height + j]));
		}
	}
	/* add a new line if not already done */
	if (l) fprintf(fp, "\n");	
}


/* write the ascii hexa representation of the content of the color RGB image to output file */
static void write_color_image_data(const mxArray *mImg, int width, int height, FILE *fp)
{
	/* same remarks as above about Matlab dims + new color mess */
	int i, j, k, l;
	const unsigned char *val = (const unsigned char *)mxGetPr(mImg);

	/* before writing pixel values, say, it will be a color image to postscript interpreter */
	/* also from ImageMagick */
	fprintf(fp,"0\n0\n");
      
	l = 0; /* used for jumping to a new line when necessary */
 	for (j = 0; j < height; ++j) {
		for (i = 0; i < width; ++i) {
			for (k = 0; k < 3; ++k) {
				if (l == MAXDATALINELEN) {
					l = 0;
					fprintf(fp, "\n");
				}
				fprintf(fp,"%s",hexabyte(val[(k*width + i)*height + j]));
				++l;
			}
		}
	}
	/* add a new line if not already done */
	if (l) fprintf(fp, "\n");
}

/*******************************************************************
 * the mex function, which is executed by a call to im2eps.m
 * im2eps.m:
 * function im2eps(img, filename)
 * should be called through writeeps which performs some checking 
 * as well as normalization of intensity range to {0,...,255} and 
 * conversion to a uint8 type (basically unsigned char...)
 *******************************************************************/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray* prhs[])
{
    int width, height, imgtype;
	FILE *fp;
	char *filename;
	char time_and_date[1024];
	time_t time_data = time(NULL);  /* get the current time and date */

	/* a minimal argument checking here */
	if (nrhs != 2) mexErrMsgTxt("expects exactly 2 input arguments.");
	imgtype = check_image(prhs[0], &width, &height);
	if (imgtype == BADIMAGE) mexErrMsgTxt("incorrect image format.");

	/* convert current time to a string representation, remove trailing '\n' */
	strcpy(time_and_date, ctime((const time_t *)&time_data));
	time_and_date[strlen(time_and_date)-1] = 0;

	filename = get_filename(prhs[1]);
	if (filename == 0) mexErrMsgTxt("incorrect filename.");

	/* open output file for writing */
	if ((fp = fopen(filename,"w")) == NULL) mexErrMsgTxt("cannot open specified file.");


	/* write the eps "prolog" into it */
	fprintf(fp,eps_prolog, filename, time_and_date, 
		width, height, width, height, 
		width, height, width, height, 
		width, height);
	
	/* write image values to the file */
	if (imgtype == GRAYIMAGE) write_gray_image_data(prhs[0], width, height, fp);
	else write_color_image_data(prhs[0], width, height, fp);
	
	/* add the eps epilog */
	fprintf(fp, eps_epilog);
	fclose(fp);
}






