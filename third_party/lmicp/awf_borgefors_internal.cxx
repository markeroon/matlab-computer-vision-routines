/* Linear interpolation of a 2D matrix. Hope to speed up bprgefors by
 * bypassing all the special checks.
 *
 *
 *
 * $Id: vgg_borgefors.cxx,v 1.12 2001/08/16 13:49:17 wexler Exp $
 * Yoni, Wed Jul 25 12:14:22 2001
 */

#include <mex.h>
#include <stdlib.h>
#include <memory.h>

typedef double real;
typedef double ID;

//: Determines the minimum of five ints.
inline void
Minimum5(real a, real b, real c, real d, real e,
	 ID id_a, ID id_b, ID id_c, ID id_d, ID id_e,
	 real* a_out, ID* id_out
	 )
{
  if ((a<=b) && (a<=c) && (a<=d) && (a<=e) )
    {
      *a_out = a;
      *id_out = id_a;
      return;
    }

  if( (b<=c) && (b<=d) && (b<=e) )
    {
      *a_out = b;
      *id_out = id_b;
      return;
    }
  
  if( (c<=d) && (c<=e) )
    {
      *a_out = c;
      *id_out = id_c;
      return;
    }
  
  if( d<=e )
    {
      *a_out = d;
      *id_out = id_d;
      return;
    }

  {
    *a_out = e;
    *id_out = id_e;
    return;
  }
}

void borgefors(int h, int w, double* D_ptr, double* Id_ptr)
{
  // Perform a forward chamfer convolution on the distance image and associates
  // a second image (id) that reports on the ID of the nearest pixel.
#define D(y,x) (D_ptr[(y) + (x) * h])
#define Id(y,x) (Id_ptr[(y) + (x) * h])
  int xsize = h; // sic. copied from targetjr
  int ysize = w;
  int i,j;
  for(i=1;i<xsize-1;i++)
    for(j=1;j<ysize-1;j++)
      Minimum5(
	       D(i-1,j-1)+4,
	       D(i-1,j  )+3,
	       D(i-1,j+1)+4,
	       D(i  ,j-1)+3,
	       D(i  ,j  ),
	       Id(i-1,j-1),
	       Id(i-1,j  ),
	       Id(i-1,j+1),
	       Id(i  ,j-1),
	       Id(i  ,j  ),
	       &D(i,j),
	       &Id(i,j)
	       );
  
  // Performs a backward chamfer convolution on the D and Id images.
  for(i=xsize-2;i>0;i--)
    for(j=ysize-2;j>0;j--) 
      Minimum5(
	       D(i,j),
	       D(i,j+1)+3,
	       D(i+1,j-1)+4,
	       D(i+1,j)+3,
	       D(i+1,j+1)+4,
	       Id(i,j),
	       Id(i,j+1),
	       Id(i+1,j-1),
	       Id(i+1,j),
	       Id(i+1,j+1),
	       &D(i,j),
	       &Id(i,j)
	       );
  
  // Fill the borders of D and Id
  for (i=0; i < h; ++i) {
    D(i,0) = D(i,1);
    Id(i,0) = Id(i,1);
    D(i,w-1) = D(i,w-2);
    Id(i,w-1) = Id(i,w-2);
  }

  for( i=0; i < w; ++i) {
    D(0,i) = D(1,i);
    Id(0,i) = Id(1,i);
    D(h-1,i) = D(h-2,i);
    Id(h-1,i) = Id(h-2,i);
  }
}

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  if(nrhs!=2)
    mexErrMsgTxt("vgg_borgefors must have 2 arguments");
  
  if (!(mxIsDouble(prhs[0]) && mxIsDouble(prhs[1])))
    mexErrMsgTxt("vgg_borgefors takes only double arguments for D, Id");
   
  const int *dims =  mxGetDimensions(prhs[0]);
  int h=dims[0];
  int w=dims[1];

  int number_of_dims = mxGetNumberOfDimensions(prhs[0]);
  if(number_of_dims!=2)
    mexErrMsgTxt("vgg_borgefors must have 2 arguments");
  
  if (h<2 || w<2)
    mexErrMsgTxt("'img' must be 2--dimensional");
  
  if (mxGetM(prhs[0])!=mxGetM(prhs[1]) || 
      mxGetN(prhs[0])!=mxGetN(prhs[1]))
    mexErrMsgTxt("X,Y must have the same size");

  if(nlhs!=2)
    mexErrMsgTxt("Must have 2 outputs.");

  double const *D = mxGetPr(prhs[0]);
  double const *Id = mxGetPr(prhs[1]);

  plhs[0] = mxCreateDoubleMatrix(h, w, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(h, w, mxREAL);

  double *D_out = (double *)mxGetData(plhs[0]);
  double *Id_out = (double *)mxGetData(plhs[1]);

  memcpy(D_out, D, w*h*sizeof *D);
  memcpy(Id_out, Id, w*h*sizeof *D);
  
  borgefors(h, w, D_out, Id_out);
}
