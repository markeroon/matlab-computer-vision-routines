/* Linear interpolation of a 2D matrix. Hope to speed up interp2 by
 * bypassing all the special checks.
 *
 *
 *
 * $Id: vgg_interp2.cxx,v 1.10 2001/08/06 17:12:04 awf Exp $
 * Yoni, Wed Jul 25 12:14:22 2001
 */

#include <mex.h>
#include <stdlib.h>

typedef double real;

//: Determines the minimum of five ints.
static real Minimum5(real a, real b, real c, real d, real e)
{
  if( (a<=b) && (a<=c) && (a<=d) && (a<=e) )
    return a;

  if( (b<=c) && (b<=d) && (b<=e) )
    return b;
  
  if( (c<=d) && (c<=e) )
    return c;
  
  if( d<=e )
    return d;

  return e;
}

static void borgefors(const double A[], const int h, const int w,
		      double V[])
{
  int i,j;
   double *out=V;
   const double NaN = mxGetNaN();

   double dmax = (w + h) * 3;

   double* Voff = V - h - 1;
#define D(r,c) (Voff[(c) * h + (r)])
   
   // Fill with dists
   int n = w*h;
   for(i = 0; i < n; ++i)
     V[i] = A[i]?0:dmax;

#if 1
   // Perform a forward chamfer convolution on the distance image.
   for(i = 2; i <= h; ++i)
     for(j = 2; j <= w-1; ++j) {
       real v1 = D(i-1,j-1)+4;
       real v2 = D(i-1,j  )+3;
       real v3 = D(i-1,j+1)+4;
       real v4 = D(i  ,j-1)+3;
       real v5 = D(i  ,j  );
       
       D(i,j) = Minimum5(v1,v2,v3,v4,v5);
     }

   // Performs a backward chamfer convolution on the D image.
   for (i=h-2; i>=1; --i)
     for (j=w-2; j>=2; --j) {
       real v1 = D(i,j);
       real v2 = D(i,j+1)+3;
       real v3 = D(i+1,j-1)+4;
       real v4 = D(i+1,j)+3;
       real v5 = D(i+1,j+1)+4;
       
       D(i,j) = Minimum5(v1,v2,v3,v4,v5);
     }
   
   // Fill the borders of D and Id
   for (i=1; i <= h; ++i) {
     D(i,1) = D(i,2);
     D(i,w) = D(i,w-1);
   }

   for (i=1; i <=w; ++i) {
     D(1,i) = D(2,i);
     D(h,i) = D(h-1,i);
   }
#endif
   
   for(i = 0; i < n; ++i)
     V[i] /= 3.0;
   
}

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
   if(nrhs!=1)
      mexErrMsgTxt("linterp2 must have 1 argument");

   if (!mxIsDouble(prhs[0]))
     mexErrMsgTxt("linterp2 takes only double arguments");
   
   const int *dims =  mxGetDimensions(prhs[0]);
   int h=dims[0], w=dims[1], col=1;

   int number_of_dims = mxGetNumberOfDimensions(prhs[0]);
   if(number_of_dims==3) col=dims[2];

   if(nlhs!=1)
      mexErrMsgTxt("Must have one output.");

   plhs[0] = mxCreateDoubleMatrix(h, w, mxREAL);
   double *V=mxGetPr(plhs[0]);

   if(mxGetClassID(prhs[0])==mxDOUBLE_CLASS) {
     borgefors(mxGetPr(prhs[0]), h, w, V);
   } else if (mxGetClassID(prhs[0]) == mxUINT8_CLASS) {
     mexErrMsgTxt("Cannot be uint");
   } else {
     mexErrMsgTxt("Unsupported type of 'A'");
   }
}
