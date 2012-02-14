#include "mex.h"

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
	double *phi;
	mxLogical *contour;
	int iWidth, iHeight;

	/* The input must be a noncomplex scalar double.*/
	iHeight = mxGetM(prhs[0]);
	iWidth = mxGetN(prhs[0]);
	iDepth = ...;

	/* Create matrix for the return argument. */
	plhs[0] = mxCreateLogicalMatrix(iHeight,iWidth,iDepth); // Matlab matrices are in order Y,X,Z
  
	/* Assign pointers to each input and output. */
	phi = mxGetPr(prhs[0]);
	contour = mxGetLogicals(plhs[0]);

	for( int a = 0; a < iWidth; a++ ) {
		for( int b = 0; b < iHeight; b++ ) {
			for( int c = 0; c < iDepth; c++ ) {
				if (phi[a*iHeight+b] >= 0) {
					for( int k = -1; k <= 1; k++ )  {
          					for( int l = -1; l <= 1; l++) {
							for( int m = -1; m <= 1; m++ ) {
								if (a+k >= 0 && a+k < iWidth && 
								    b+l >= 0 && b+l < iHeight && 
								    phi[(a+k)*iHeight+b+l] < 0) {
        								if (-phi[(a+k)*iHeight+b+l] < phi[a*iHeight+b]) {
               									contour[(a+k)*iHeight+b+l] = true;
									}
									else {
										contour[a*iHeight+b] = true;
									}
								}
							}
						}
					}
 				}
 			}
 		}
	}
}
