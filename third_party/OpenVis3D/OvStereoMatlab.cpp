#include "Openvis3d.h"
#include "MatlabImageAdapter.h"

extern "C" {
#include "mex.h"
}

void OvStereoMatlab(int nlhs, mxArray *plhs[], int nrhs, const mxArray  *prhs[] )
{
  if((nrhs<4)||(nlhs<4)) mexErrMsgTxt("Usage:\n [bestshiftsL, occlL, bestshiftsR, occlR] = OvStereoMatlab(iL, iR, minshift, maxshift, <optional: alpha>);");

  //find size of input images
  int tmpNumDims = mxGetNumberOfDimensions(prhs[0]);
  const int *tmpDimSizes = mxGetDimensions(prhs[0]);
  int mrows = tmpDimSizes[0];
  int ncols = tmpDimSizes[1];

  //read input parameters
  double minshift = *mxGetPr(prhs[2]);
  double maxshift = *mxGetPr(prhs[3]);

  //lower alpha means smoother depth map
  double alpha[] = {20.0};
  if(nrhs>=5) {
    alpha[0] = *mxGetPr(prhs[4]); //read in alpha if supplied, else use default.
  }

  //allocate outputs
  plhs[0] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[2] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[3] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);

  //wrap with Matlab Image Adapters
  MatlabImageAdapter *imgLeft = 0, *imgRight = 0,
    *bestshiftsL = 0, *occlL = 0,
    *bestshiftsR = 0, *occlR = 0;

  imgLeft  = new MatlabImageAdapter(const_cast<mxArray*>(prhs[0]));
  imgRight = new MatlabImageAdapter(const_cast<mxArray*>(prhs[1]));

  bestshiftsL = new MatlabImageAdapter(plhs[0]);
  occlL = new MatlabImageAdapter(plhs[1]);
  bestshiftsR = new MatlabImageAdapter(plhs[2]);
  occlR = new MatlabImageAdapter(plhs[3]);

  BTLocalMatcherT<double> btmatcher; //birchfield-tomasi local matcher
  OvStereoDiffuseMatcherT<double> stereoDiffuseMatcher; //diffuse stereo global matcher
  OvStereoT<double> stereoManager; //general stereo algorithm execution manager

  btmatcher.setParams(1,alpha);
  stereoManager.setLocalImageMatcher(btmatcher); //set to use birchfield-tomasi matcher
  stereoManager.setGlobalMatcher(stereoDiffuseMatcher); //set global algo to diffuse matching

  //execute stereo algorithm
  stereoManager.doStereoMatching(*imgLeft, *imgRight, minshift, maxshift, *bestshiftsL, *bestshiftsR, *occlL, *occlR);

  //deallocate image adaptors (not images) for inputs and outputs
  if(imgLeft) delete imgLeft;
  if(imgRight) delete imgRight;
  if(bestshiftsL) delete bestshiftsL;
  if(occlL) delete occlL;
  if(bestshiftsR) delete bestshiftsR;
  if(occlR) delete occlR;
}

extern "C" {
  void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray  *prhs[] )
  {
    OvStereoMatlab(nlhs, plhs, nrhs, prhs);
  }
}


