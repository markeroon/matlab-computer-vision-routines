#include "mex.h"
#include <math.h>


void BinaryBoundaryDetection(char *pI, int width, int height, int depth, int type, char *pOut);

void mexFunction(int nlhs,mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
	// [x,y] = BinaryEdgeDetector(I, pixelval);
	int width, height, depth, type, n_dims;
	char *pI;
	int i;

	if(!mxIsClass(prhs[0],"uint8"))
		mexErrMsgTxt("Input binary image must be of uint8.");
	n_dims = mxGetNumberOfDimensions(prhs[0]);
	if( n_dims != 3 )
		mexErrMsgTxt("Input data must be 3-dimensional.");
	height = (mxGetDimensions(prhs[0]))[0];
	width =	 (mxGetDimensions(prhs[0]))[1];
	depth =  (mxGetDimensions(prhs[0]))[2];

	pI = (char*)mxGetPr(prhs[0]);
	if(nrhs < 2)
		type = 0;
	else
		type = (int)mxGetScalar(prhs[1]);
    
    plhs[0] = mxCreateNumericArray(3, mxGetDimensions(prhs[0]), mxUINT8_CLASS, mxREAL);
	BinaryBoundaryDetection(pI, width, height, depth, type, (char*)mxGetPr(plhs[0]));
}


// Note the function doesn't consider the points on the boundary of the volume for
// the sake of efficiency. 
// If the points on the volume boundary are also needed to be considered, do this 
// in Matlab: embbed the interested volume with dimension N1xN2xN3 in a bigger 
// volume (N1+2)x(N2+2)x(N3+2) whose boundary is filled with 'inside' pixels.

void BinaryBoundaryDetection(char *pI, int width, int height, int depth, int type, 
							 char *pOut)
{
	int inv_type = !type;
	int i, j, k, idx, idx0, count;
	int on_boundary = 0;
	int wh = width*height;
	
	count = 0;
	idx = 1;
	for(i=1; i<depth-1; i++)
	{
		idx0 = wh*i;
		for(j=1; j<width-1; j++)
		{
			idx = idx0 + j*height;
			for(k=1; k<height-1; k++)
			{
				idx++;
				// If the pixel is 'on', check if its neighbors are 'on'
				// if negative, the pixel is considered to be on boundary.
				if(pI[idx] == type)
				{
					if(pI[idx-1] == inv_type) pOut[idx] = 1;
					else
					{
						if(pI[idx+1] == inv_type) pOut[idx] = 1;
						else
						{
							if(pI[idx-height] == inv_type) pOut[idx] = 1;
							else
							{
								if(pI[idx+height] == inv_type) pOut[idx] = 1;
								else
								{
									if(pI[idx-wh] == inv_type) pOut[idx] = 1;
									else
									{
										if(pI[idx+wh] == inv_type) pOut[idx] = 1;
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