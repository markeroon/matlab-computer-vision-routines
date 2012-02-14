#include "Openvis3d.h"
#include "MatlabImageAdapter.h"

extern "C" {
#include "mex.h"
}

void OvFlowMatlab(int nlhs, mxArray *plhs[], int nrhs, const mxArray  *prhs[] )
{
  if((nrhs<6)||(nlhs<6))
    mexErrMsgTxt("Usage:\n[bestshiftsLX, bestshiftsLY, occlL, bestshiftsRX, bestshiftsRY, occlR] = OvFlowMatlab(iL, iR, minshiftX, maxshiftX, minshiftY, maxshiftY, <optional: alpha>);");

  //find size of input images
  int tmpNumDims = mxGetNumberOfDimensions(prhs[0]);
  const int *tmpDimSizes = mxGetDimensions(prhs[0]);
  int mrows = tmpDimSizes[0];
  int ncols = tmpDimSizes[1];

  //read input parameters
  double minshiftX = *mxGetPr(prhs[2]);
  double maxshiftX = *mxGetPr(prhs[3]);
  double minshiftY = *mxGetPr(prhs[4]);
  double maxshiftY = *mxGetPr(prhs[5]);

  //lower alpha means smoother depth map
  double alpha[] = {20.0};
  if(nrhs>=7) {
    alpha[0] = *mxGetPr(prhs[6]); //read in alpha if supplied, else use default.
  }

  //allocate outputs
  plhs[0] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[2] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[3] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[4] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[5] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);

  //wrap with Matlab Image Adapters
  MatlabImageAdapter *imgLeft = 0, *imgRight = 0,
    *bestshiftsLX = 0, *bestshiftsLY = 0, *occlL = 0,
    *bestshiftsRX = 0, *bestshiftsRY = 0, *occlR = 0;

  imgLeft  = new MatlabImageAdapter(const_cast<mxArray*>(prhs[0]));
  imgRight = new MatlabImageAdapter(const_cast<mxArray*>(prhs[1]));

  bestshiftsLX = new MatlabImageAdapter(plhs[0]);
  bestshiftsLY = new MatlabImageAdapter(plhs[1]);
  occlL = new MatlabImageAdapter(plhs[2]);
  bestshiftsRX = new MatlabImageAdapter(plhs[3]);
  bestshiftsRY = new MatlabImageAdapter(plhs[4]);
  occlR = new MatlabImageAdapter(plhs[5]);

  BTLocalMatcherT<double> btmatcher; //birchfield-tomasi local matcher
  OvFlowDiffuseMatcherT<double> flowDiffuseMatcher; //diffuse flow global matcher
  OvFlowT<double> flowManager; //general optical flow algorithm execution manager

  btmatcher.setParams(1,alpha);
  flowManager.setLocalImageMatcher(btmatcher); //set to use birchfield-tomasi matcher
  flowManager.setGlobalMatcher(flowDiffuseMatcher); //set global algo to diffuse matching

  //execute optical flow algorithm
  flowManager.doOpticalFlow(*imgLeft, *imgRight, minshiftX, maxshiftX, minshiftY, maxshiftY, *bestshiftsLX, *bestshiftsLY, *occlL, *bestshiftsRX, *bestshiftsRY, *occlR);

  //deallocate image adaptors (not images) for inputs and outputs
  if(imgLeft) delete imgLeft;
  if(imgRight) delete imgRight;
  if(bestshiftsLX) delete bestshiftsLX;
  if(bestshiftsLY) delete bestshiftsLY;
  if(occlL) delete occlL;
  if(bestshiftsRX) delete bestshiftsRX;
  if(bestshiftsRY) delete bestshiftsRY;
  if(occlR) delete occlR;
}

extern "C" {
  void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray  *prhs[] )
  {
    OvFlowMatlab(nlhs, plhs, nrhs, prhs);
  }
}


