#ifndef __OVFLOWDIFFUSEMATCHERT_H
#define __OVFLOWDIFFUSEMATCHERT_H

#include "OvImageT.h"
#include "OvFlowGlobalMatcherT.h"
#include "OvLocalMatcherT.h"

///Global optical flow algorithm based on fast diffusion (see Ogale et al. ICRA April 05, IJCV July 06).
/** 
* The OvFlowDiffuseMatcherT implements the fast diffusion based optical flow based on
* Ogale and Aloimonos, ICRA April 2005 and IJCV July 2006.
* @see http://www.cs.umd.edu/users/ogale/publist.htm
*
* @author Abhijit Ogale
*/
template<typename T>
class OvFlowDiffuseMatcherT : public OvFlowGlobalMatcherT<T>
{
public:

  OvFlowDiffuseMatcherT(); /**< Default constructor with no parameters */

  virtual ~OvFlowDiffuseMatcherT(); /**< Destructor */

  /**
  * Main method for computing optical flow on an image pair.
  * Note: This method modifies the input images, so be careful.
  * @param i1 the first image
  * @param i2 the second image
  * @param minshiftX method searches for horizontal flow values from minshiftX to maxshiftX
  * @param maxshiftX method searches for horizontal flow values from minshiftX to maxshiftX
  * @param minshiftY method searches for vertical flow values from minshiftY to maxshiftY
  * @param maxshiftY method searches for vertical flow values from minshiftY to maxshiftY
  * @param u1 the horizontal flow for image 1. (method sets this).
  * @param v1 the vertical flow for image 1. (method sets this).
  * @param o1 the occlusion map for image 1. (method sets this).
  * @param u2 the horizontal flow for image 2. (method sets this).
  * @param v2 the vertical flow for image 2. (method sets this).
  * @param o2 the occlusion map for image 2. (method sets this).
  * @return true if successful.
  */
  virtual bool doMatching(OvImageT<T> & i1, OvImageT<T> & i2, double minshiftX, double maxshiftX, double minshiftY, double maxshiftY, OvImageT<double> & u1, OvImageT<double> & v1, OvImageT<double> & o1, OvImageT<double> & u2, OvImageT<double> & v2,  OvImageT<double> & o2);

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
OvFlowDiffuseMatcherT<T>::OvFlowDiffuseMatcherT()
{
}

template<typename T>
OvFlowDiffuseMatcherT<T>::~OvFlowDiffuseMatcherT()
{
}

template<typename T>
bool OvFlowDiffuseMatcherT<T>::doMatching(OvImageT<T> & i1, OvImageT<T> & i2, double minshiftX, double maxshiftX, double minshiftY, double maxshiftY, OvImageT<double> & u1, OvImageT<double> & v1, OvImageT<double> & o1, OvImageT<double> & u2, OvImageT<double> & v2,  OvImageT<double> & o2)
{
  int height, width, channels;
  int i,j,iproj,jproj;

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

  u1 = minshiftX;
  v1 = minshiftY;
  o1 = 0;
  u2 = -minshiftX;
  v2 = -minshiftY;
  o2 = 0;

  for(int shiftX=static_cast<int>(minshiftX); shiftX<=maxshiftX; shiftX++)
  {
    for(int shiftY=static_cast<int>(minshiftY); shiftY<=maxshiftY; shiftY++)
    {
      iMatch = mLocalMatcher->getMatch(shiftX,shiftY);
      computeGoodnessHoriz(iMatch, iMatch, iGoodnessHoriz);
      computeGoodnessVert(iMatch, iMatch, iGoodnessVert);

      iGoodnessL = iGoodnessHoriz*iGoodnessVert;
      iGoodnessR = shiftImageXY(iGoodnessL, shiftX, shiftY); 

      bestprobabRshifted = shiftImageXY(bestprobabR, -shiftX, -shiftY);
      maskL = (iGoodnessL>bestprobabL) && (iGoodnessL>bestprobabRshifted);
      maskR = shiftImageXY(maskL, shiftX, shiftY); 

      u1.copyMasked(maskL, shiftX);
      v1.copyMasked(maskL, shiftY);
      bestprobabL.copyMasked(maskL, iGoodnessL);

      u2.copyMasked(maskR, -shiftX);
      v2.copyMasked(maskR, -shiftY);
      bestprobabR.copyMasked(maskR, iGoodnessR);
    }
  }

  //find left occlusions using LR consistency
  for(i=0; i<height; i++)
    for(j=0; j<width; j++)
    {
      iproj = i + static_cast<int>(v1(i,j));
      jproj = j + static_cast<int>(u1(i,j));
      if((iproj>=0)&&(iproj<height)&&(jproj>=0)&&(jproj<width))
      {
        iproj = iproj + static_cast<int>(v2(iproj,jproj));
        jproj = jproj + static_cast<int>(u2(iproj,jproj));
        if((iproj!=i)&&(jproj!=j)) o1(i,j) = 1;
      }
      else o1(i,j) = 1;
    }

    //find right occlusions using LR consistency
    for(i=0; i<height; i++)
      for(j=0; j<width; j++)
      {
        iproj = i + static_cast<int>(v2(i,j));
        jproj = j + static_cast<int>(u2(i,j));
        if((iproj>=0)&&(iproj<height)&&(jproj>=0)&&(jproj<width))
        {
          iproj = iproj + static_cast<int>(v1(iproj,jproj));
          jproj = jproj + static_cast<int>(u1(iproj,jproj));
          if((iproj!=i)&&(jproj!=j)) o2(i,j) = 1;
        }
        else o2(i,j) = 1;
      }

      o1 = medianFilter2D(o1,3,3);
      o2 = medianFilter2D(o2,3,3);

      return true;
}

template<typename T>
bool OvFlowDiffuseMatcherT<T>::setParams(int nparams, double*params)
{
  return true;
}

template<typename T>
void OvFlowDiffuseMatcherT<T>::setLocalImageMatcher(OvLocalMatcherT<T> & localImageMatcher)
{
  mLocalMatcher = &localImageMatcher;
}

template<typename T>
void OvFlowDiffuseMatcherT<T>::computeGoodnessHoriz(const OvImageT<double> & iMatch, const OvImageT<double> & iConductivity, OvImageT<double> & iGoodness)
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
void OvFlowDiffuseMatcherT<T>::computeGoodnessVert(const OvImageT<double> & iMatch, const OvImageT<double> & iConductivity, OvImageT<double> & iGoodness)
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

#endif //__OVFLOWDIFFUSEMATCHERT_H
