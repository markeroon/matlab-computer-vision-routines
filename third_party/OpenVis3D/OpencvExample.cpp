#include "Openvis3d.h"
#include "OpenCVImageAdapter.h"
#include <cv.h>
#include <highgui.h>
#include <cstdio>

void testStereo(char*imgfilename1, char*imgfilename2, double minshift, double maxshift)
{
  //read input images
  IplImage*img1 = cvLoadImage(imgfilename1);
  IplImage*img2 = cvLoadImage(imgfilename2);

  //create output images
  CvSize sz;
  sz.height = img1->height;
  sz.width  = img1->width;
  IplImage*imgLeftDisparity = cvCreateImage(sz,IPL_DEPTH_64F,1);
  IplImage*imgRightDisparity = cvCreateImage(sz,IPL_DEPTH_64F,1);
  IplImage*imgLeftOcclusions = cvCreateImage(sz,IPL_DEPTH_64F,1);
  IplImage*imgRightOcclusions = cvCreateImage(sz,IPL_DEPTH_64F,1);

  //if all images are properly allocated, then proceed
  if(img1 && img2 && imgLeftDisparity && imgRightDisparity && imgLeftOcclusions && imgRightOcclusions)
  {
    //wrap all the input and output images in OpenCVImageAdapter, so that they can be
    //accessed by OpenVis3D
    OpenCVImageAdapter*ovaImg1 = new OpenCVImageAdapter(img1);
    OpenCVImageAdapter*ovaImg2 = new OpenCVImageAdapter(img2);
    OpenCVImageAdapter*ovaLeftDisp = new OpenCVImageAdapter(imgLeftDisparity);
    OpenCVImageAdapter*ovaRightDisp = new OpenCVImageAdapter(imgRightDisparity);
    OpenCVImageAdapter*ovaLeftOcc = new OpenCVImageAdapter(imgLeftOcclusions);
    OpenCVImageAdapter*ovaRightOcc = new OpenCVImageAdapter(imgRightOcclusions);

    //create Birchfield-Tomasi local matcher and set its default parameter alpha to 20.0
    BTLocalMatcherT<double> btmatcher;
    double alpha[] = {20.0};
    btmatcher.setParams(1,alpha);

    //create global diffusion-based stereo algorithm instance
    OvStereoDiffuseMatcherT<double> stereoDiffuseMatcher;

    //create general stereo algorithm execution manager instance
    OvStereoT<double> stereoManager;
    stereoManager.setLocalImageMatcher(btmatcher); //set local matcher to Birchfield-Tomasi
    stereoManager.setGlobalMatcher(stereoDiffuseMatcher); //set global stereo algorithm

    printf("\nRunning stereo ...\n");

    //EXECUTE stereo matching
    stereoManager.doStereoMatching(*ovaImg1, *ovaImg2, minshift, maxshift, *ovaLeftDisp, *ovaRightDisp, *ovaLeftOcc, *ovaRightOcc);

    //DISPLAY RESULTS

    //BEGIN: rescale disparity maps to range (0,1) so that they can be displayed by OpenCV
    OvImageT<double> ovtleftDisp, ovtrightDisp;
    ovtleftDisp.copyFromAdapter(*ovaLeftDisp);
    ovtrightDisp.copyFromAdapter(*ovaRightDisp);

    ovtleftDisp = (ovtleftDisp-minshift)/(maxshift-minshift);
    ovtrightDisp = (ovtrightDisp+maxshift)/(-minshift+maxshift);

    ovtleftDisp.copyToAdapter(*ovaLeftDisp);
    ovtrightDisp.copyToAdapter(*ovaRightDisp);
    //END: rescale disparity maps to range (0,1) so that they can be displayed by OpenCV

    cvNamedWindow("Left Disparity", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("Left Occlusions", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("Right Disparity", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("Right Occlusions", CV_WINDOW_AUTOSIZE);

    cvShowImage("Left Disparity", imgLeftDisparity);
    cvShowImage("Left Occlusions", imgLeftOcclusions);
    cvShowImage("Right Disparity", imgRightDisparity);
    cvShowImage("Right Occlusions", imgRightOcclusions);

    //WAIT FOR KEYPRESS
    printf("\nDone, press any key to continue ...\n");
    cvWaitKey(0);

    //release adaptors
    if(ovaImg1) delete ovaImg1;
    if(ovaImg2) delete ovaImg2;
    if(ovaLeftDisp) delete ovaLeftDisp;
    if(ovaRightDisp) delete ovaRightDisp;
    if(ovaLeftOcc) delete ovaLeftOcc;
    if(ovaRightOcc) delete ovaRightOcc;
  }

  //release opencv images
  if(img1) cvReleaseImage(&img1);
  if(img2) cvReleaseImage(&img2);
  if(imgLeftDisparity) cvReleaseImage(&imgLeftDisparity);
  if(imgRightDisparity) cvReleaseImage(&imgRightDisparity);
  if(imgLeftOcclusions) cvReleaseImage(&imgLeftOcclusions);
  if(imgRightOcclusions) cvReleaseImage(&imgRightOcclusions);
}

void testOpticalFlow(char*imgfilename1, char*imgfilename2, double minshiftX, double maxshiftX, double minshiftY, double maxshiftY)
{
  //read input images
  IplImage*img1 = cvLoadImage(imgfilename1);
  IplImage*img2 = cvLoadImage(imgfilename2);

  //create output images
  CvSize sz;
  sz.height = img1->height;
  sz.width  = img1->width;
  IplImage*imgU1 = cvCreateImage(sz,IPL_DEPTH_64F,1);
  IplImage*imgV1 = cvCreateImage(sz,IPL_DEPTH_64F,1);
  IplImage*imgO1 = cvCreateImage(sz,IPL_DEPTH_64F,1);
  IplImage*imgU2 = cvCreateImage(sz,IPL_DEPTH_64F,1);
  IplImage*imgV2 = cvCreateImage(sz,IPL_DEPTH_64F,1);
  IplImage*imgO2 = cvCreateImage(sz,IPL_DEPTH_64F,1);

  if(img1 && img2 && imgU1 && imgV1 && imgO1 && imgU2 && imgV2 && imgO2)
  {
    //wrap all the input and output images in OpenCVImageAdapter, so that they can be
    //accessed by OpenVis3D
    OpenCVImageAdapter*ovaImg1 = new OpenCVImageAdapter(img1);
    OpenCVImageAdapter*ovaImg2 = new OpenCVImageAdapter(img2);
    OpenCVImageAdapter*ovaImgU1 = new OpenCVImageAdapter(imgU1);
    OpenCVImageAdapter*ovaImgV1 = new OpenCVImageAdapter(imgV1);
    OpenCVImageAdapter*ovaImgO1 = new OpenCVImageAdapter(imgO1);
    OpenCVImageAdapter*ovaImgU2 = new OpenCVImageAdapter(imgU2);
    OpenCVImageAdapter*ovaImgV2 = new OpenCVImageAdapter(imgV2);
    OpenCVImageAdapter*ovaImgO2 = new OpenCVImageAdapter(imgO2);

    //create Birchfield-Tomasi local matcher and set its default parameter alpha to 20.0
    BTLocalMatcherT<double> btmatcher;
    double alpha[] = {20.0};
    btmatcher.setParams(1,alpha);

    //create global diffusion-based optical flow algorithm instance
    OvFlowDiffuseMatcherT<double> flowDiffuseMatcher;

    //create general optical flow algorithm execution manager instance
    OvFlowT<double> flowManager;
    flowManager.setLocalImageMatcher(btmatcher);
    flowManager.setGlobalMatcher(flowDiffuseMatcher);

    printf("\nRunning optical flow ...\n");

    //EXECUTE optical flow estimation
    flowManager.doOpticalFlow(*ovaImg1, *ovaImg2, minshiftX, maxshiftX, minshiftY, maxshiftY, *ovaImgU1, *ovaImgV1, *ovaImgO1, *ovaImgU2, *ovaImgV2, *ovaImgO2);


    //DISPLAY RESULTS

    //BEGIN: rescale flow maps to range (0,1) so that they can be displayed by OpenCV
    OvImageT<double> ovtU1, ovtV1, ovtU2, ovtV2;

    ovtU1.copyFromAdapter(*ovaImgU1);
    ovtV1.copyFromAdapter(*ovaImgV1);
    ovtU2.copyFromAdapter(*ovaImgU2);
    ovtV2.copyFromAdapter(*ovaImgV2);

    ovtU1 = (ovtU1-minshiftX)/(maxshiftX-minshiftX);
    ovtV1 = (ovtV1-minshiftY)/(maxshiftY-minshiftY);
    ovtU2 = (ovtU2+maxshiftX)/(-minshiftX+maxshiftX);
    ovtV2 = (ovtV2+maxshiftY)/(-minshiftY+maxshiftY);

    ovtU1.copyToAdapter(*ovaImgU1);
    ovtV1.copyToAdapter(*ovaImgV1);
    ovtU2.copyToAdapter(*ovaImgU2);
    ovtV2.copyToAdapter(*ovaImgV2);
    //END: rescale flow maps to range (0,1) so that they can be displayed by OpenCV

    cvNamedWindow("U1", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("V1", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("O1", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("U2", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("V2", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("O2", CV_WINDOW_AUTOSIZE);

    cvShowImage("U1", imgU1);
    cvShowImage("V1", imgV1);
    cvShowImage("O1", imgO1);
    cvShowImage("U2", imgU2);
    cvShowImage("V2", imgV2);
    cvShowImage("O2", imgO2);

    //WAIT FOR KEYPRESS
    printf("\nDone, press any key to continue ...\n");
    cvWaitKey(0);

    //release adaptors
    if(ovaImg1) delete ovaImg1;
    if(ovaImg2) delete ovaImg2;
    if(ovaImgU1) delete ovaImgU1;
    if(ovaImgV1) delete ovaImgV1;
    if(ovaImgO1) delete ovaImgO1;
    if(ovaImgU2) delete ovaImgU2;
    if(ovaImgV2) delete ovaImgV2;
    if(ovaImgO2) delete ovaImgO2;
  }

  //release opencv images
  if(img1) cvReleaseImage(&img1);
  if(img2) cvReleaseImage(&img2);
  if(imgU1) cvReleaseImage(&imgU1);
  if(imgV1) cvReleaseImage(&imgV1);
  if(imgO1) cvReleaseImage(&imgO1);
  if(imgU2) cvReleaseImage(&imgU2);
  if(imgV2) cvReleaseImage(&imgV2);
  if(imgO2) cvReleaseImage(&imgO2);
}


int main()
{
  testStereo("tsukuba1color.png", "tsukuba2color.png", 5, 15);

  testOpticalFlow("car1.png", "car0.png", 0, 18, -3, 0);

  return 0;
}

