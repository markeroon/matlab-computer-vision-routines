#ifndef __OVSTEREODIFFUSEMATCHERT_H
#define __OVSTEREODIFFUSEMATCHERT_H

#include "OvImageT.h"
#include "OvStereoGlobalMatcherT.h"
#include "OvLocalMatcherT.h"

///Global stereo matching algorithm based on fast diffusion (see Ogale et al. ICRA April 05, IJCV July 06).
/**
* The OvStereoDiffuseMatcherT implements the fast diffusion based stereo matching discussed in
* Ogale and Aloimonos, ICRA April 2005 and IJCV July 2006.
* @see http://www.cs.umd.edu/users/ogale/publist.htm
*
* @author Abhijit Ogale
*/
template<typename T>
class OvStereoDiffuseMatcherT : public OvStereoGlobalMatcherT<T>
{
public:

  OvStereoDiffuseMatcherT(); /**< Default constructor with no parameters */

  virtual ~OvStereoDiffuseMatcherT(); /**< Destructor */

  /**
  * Main method for stereo matching an image pair.
  * Note: This method modifies the input images, so be careful.
  * @param i1 the first image
  * @param i2 the second image
  * @param minshift method searches for disparities from minshift to maxshift
  * @param maxshift method searches for disparities from minshift to maxshift
  * @param leftDisparityMap the disparity map for the left image. (method sets this).
  * @param rightDisparityMap the disparity map for the right image. (method sets this).
  * @param leftOcclusions the occlusion map for the left image. (method sets this).
  * @param rightOcclusions the occlusion map for the right image. (method sets this).
  * @return true if successful.
  */
  virtual bool doMatching(OvImageT<T> & i1, OvImageT<T> & i2, double minshift, double maxshift, OvImageT<double> & leftDisparityMap, OvImageT<double> & rightDisparityMap, OvImageT<double> & leftOcclusions, OvImageT<double> & rightOcclusions);

  /**
  * Used for specifying any parameters required.
  * @param nparams number of parameters which are being passed
  * @param params the values of the parameters
  * @return true if successful.
  */
  virtual bool setParams(int nparams, double*params);

  /**
  * Specifies the local image matcher to be used by the algorithm.
  * @param localImageMatcher this is an OvLocalMatcherT<T> object which matches a pair of images.
  */
  virtual void setLocalImageMatcher(OvLocalMatcherT<T> & localImageMatcher);

protected:
  OvLocalMatcherT<T> * mLocalMatcher;

  virtual void computeGoodnessHoriz (const OvImageT<double> & iMatch, const OvImageT<double> & iConductivity, OvImageT<double> & iGoodness);
  virtual void computeGoodnessVert  (const OvImageT<double> & iMatch, const OvImageT<double> & iConductivity, OvImageT<double> & iGoodness);

};


template<typename T>
OvStereoDiffuseMatcherT<T>::OvStereoDiffuseMatcherT()
{
}

template<typename T>
OvStereoDiffuseMatcherT<T>::~OvStereoDiffuseMatcherT()
{
}

template<typename T>
bool OvStereoDiffuseMatcherT<T>::doMatching(OvImageT<T> & i1, OvImageT<T> & i2, double minshift, double maxshift, OvImageT<double> & leftDisparityMap, OvImageT<double> & rightDisparityMap, OvImageT<double> & leftOcclusions, OvImageT<double> & rightOcclusions)
{
  int height, width, channels;
  int i,j,jproj;

  OvImageT<double> iMatch, iGoodnessVert, iGoodnessHoriz, iGoodnessL, iGoodnessR, bestprobabL, bestprobabR, bestprobabRshifted;
  OvImageT<bool> maskL, maskR;

  i1.getDimensions(height,width,channels);
  iMatch.resetDimensions(height,width);
  iGoodnessHoriz.resetDimensions(height,width);
  iGoodnessVert.resetDimensions(height,width);
  iGoodnessL.resetDimensions(height,width);
  iGoodnessR.resetDimensions(height,width);
  bestprobabL.resetDimensions(height,width);
  bestprobabR.resetDimensions(height,width);
  bestprobabRshifted.resetDimensions(height,width);

  mLocalMatcher->setImagePair(i1, i2);

  leftDisparityMap = minshift;
  rightDisparityMap = -minshift;
  leftOcclusions = 0;
  rightOcclusions = 0;

  for(int shift=static_cast<int>(minshift); shift<=maxshift; shift++)
  {
    iMatch = mLocalMatcher->getMatch(shift,0);
    computeGoodnessHoriz(iMatch, iMatch, iGoodnessHoriz);
    computeGoodnessVert(iMatch, iMatch, iGoodnessVert);

    iGoodnessL = iGoodnessHoriz*iGoodnessVert;
    iGoodnessR = shiftImageXY(iGoodnessL, shift, 0);

    bestprobabRshifted = shiftImageXY(bestprobabR, -shift, 0);
    maskL = (iGoodnessL>bestprobabL) && (iGoodnessL>bestprobabRshifted);
    maskR = shiftImageXY(maskL, shift, 0);

    leftDisparityMap.copyMasked(maskL,shift);
    bestprobabL.copyMasked(maskL, iGoodnessL);
    rightDisparityMap.copyMasked(maskR,-shift);
    bestprobabR.copyMasked(maskR, iGoodnessR);
  }

  leftDisparityMap  = medianFilter2D(leftDisparityMap,3,3);
  rightDisparityMap = medianFilter2D(rightDisparityMap,3,3);

  //find left occlusions using LR consistency
  for(i=0; i<height; i++)
    for(j=0; j<width; j++)
    {
      jproj = j + static_cast<int>(leftDisparityMap(i,j));
      if((jproj>=0)&&(jproj<width))
      {
        jproj = jproj + static_cast<int>(rightDisparityMap(i,jproj));
        if(jproj!=j) leftOcclusions(i,j) = 1;
      }
      else leftOcclusions(i,j) = 1;
    }

    //find right occlusions using LR consistency
    for(i=0; i<height; i++)
      for(j=0; j<width; j++)
      {
        jproj = j + static_cast<int>(rightDisparityMap(i,j));
        if((jproj>=0)&&(jproj<width))
        {
          jproj = jproj + static_cast<int>(leftDisparityMap(i,jproj));
          if(jproj!=j) rightOcclusions(i,j) = 1;
        }
        else rightOcclusions(i,j) = 1;
      }

      leftOcclusions = medianFilter2D(leftOcclusions,3,3);
      rightOcclusions = medianFilter2D(rightOcclusions,3,3);

      return true;
}

template<typename T>
bool OvStereoDiffuseMatcherT<T>::setParams(int nparams, double*params)
{
  return true;
}

template<typename T>
void OvStereoDiffuseMatcherT<T>::setLocalImageMatcher(OvLocalMatcherT<T> & localImageMatcher)
{
  mLocalMatcher = &localImageMatcher;
}

template<typename T>
void OvStereoDiffuseMatcherT<T>::computeGoodnessHoriz(const OvImageT<double> & iMatch, const OvImageT<double> & iConductivity, OvImageT<double> & iGoodness)
{
  int i, j, height, width, channels;
  double temp, leftval, rightval;

  iMatch.getDimensions(height, width, channels);

  //left to right
  for(i=0;i<height;i++)
  {
    leftval = 0;
    for(j=0;j<width;j++)
    {
      temp = iMatch(i,j) + leftval*iConductivity(i,j);
      iGoodness(i,j) = temp;
      leftval = temp;
    }
  }

  //now right to left
  for(i=0;i<height;i++)
  {
    rightval = 0;
    for(j=(width-1);j>=0;j--)
    {
      temp = rightval*iConductivity(i,j);
      iGoodness(i,j) += temp; //we are not including iMatch here since we would only subtract it later
      rightval = temp + iMatch(i,j); //but we have to include it here before propagation
    }
  }
}

template<typename T>
void OvStereoDiffuseMatcherT<T>::computeGoodnessVert(const OvImageT<double> & iMatch, const OvImageT<double> & iConductivity, OvImageT<double> & iGoodness)
{
  int i, j, height, width, channels;
  double temp, topval, bottomval;

  iMatch.getDimensions(height, width, channels);

  //top to bottom
  for(j=0;j<width;j++)
  {
    topval = 0;
    for(i=0;i<height;i++)
    {
      temp = iMatch(i,j) + topval*iConductivity(i,j);
      iGoodness(i,j) = temp;
      topval = temp;
    }
  }

  //now bottom to top
  for(j=0;j<width;j++)
  {
    bottomval = 0;
    for(i=(height-1);i>=0;i--)
    {
      temp = bottomval*iConductivity(i,j);
      iGoodness(i,j) += temp; //we are not including iMatch here since we would only subtract it later
      bottomval = temp + iMatch(i,j); //but we have to include it here before propagation
    }
  }
}

#endif //__OVSTEREODIFFUSEMATCHERT_H
