#ifndef __OVSTEREOGLOBALMATCHERT_H
#define __OVSTEREOGLOBALMATCHERT_H

#include "OvImageT.h"
#include "OvLocalMatcherT.h"

///Abstract Base Class Template for defining a global matching stereo algorithm.
/** 
* The OvStereoGlobalMatcherT class defines a basic interface for a global matching stereo algorithm.
* Subclasses can implement the interface to provide a variety of global matching methods.
*
* @author Abhijit Ogale
*/
template<typename T>
class OvStereoGlobalMatcherT
{
public:

  OvStereoGlobalMatcherT(); /**< Default constructor with no parameters */

  virtual ~OvStereoGlobalMatcherT(); /**< Destructor */

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
  virtual bool doMatching(OvImageT<T> & i1, OvImageT<T> & i2, double minshift, double maxshift, OvImageT<double> & leftDisparityMap, OvImageT<double> & rightDisparityMap, OvImageT<double> & leftOcclusions, OvImageT<double> & rightOcclusions) = 0;

  /**
  * Used for specifying any parameters required.
  * @param nparams number of parameters which are being passed
  * @param params the values of the parameters
  * @return true if successful.
  */
  virtual bool setParams(int nparams, double*params) = 0;

  /**
  * Specifies the local image matcher to be used by the algorithm.
  * @param localImageMatcher this is an OvLocalMatcherT<T> object which matches a pair of images.
  */
  virtual void setLocalImageMatcher(OvLocalMatcherT<T> & localImageMatcher) = 0;
};

template<typename T>
OvStereoGlobalMatcherT<T>::OvStereoGlobalMatcherT()
{
}

template<typename T>
OvStereoGlobalMatcherT<T>::~OvStereoGlobalMatcherT()
{
}

#endif //__OVSTEREOGLOBALMATCHERT_H
