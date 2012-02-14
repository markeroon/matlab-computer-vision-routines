#ifndef __BTLOCALMATCHERT_H
#define __BTLOCALMATCHERT_H

#include "OvLocalMatcherT.h"

///Birchfield-Tomasi sampling-insensitive intensity local matcher.
/** 
* The BTLocalMatcherT class is a subclass of OvLocalMatcherT and implements the Birchfield-Tomasi 
* method for intensity matching.
*
* @author Abhijit Ogale
*/
template<typename T>
class BTLocalMatcherT : public OvLocalMatcherT<T>
{
public:

  BTLocalMatcherT(); /**< Default constructor with no parameters */
  virtual ~BTLocalMatcherT(); /**< Destructor */
  virtual bool setImagePair(const OvImageT<T> & i1, const OvImageT<T> & i2);
  virtual bool setParams(int nparams, double*params);
  virtual const OvImageT<double> getMatch(int shiftx, int shifty);
  virtual const OvImageT<double> getRawMatch(int shiftx, int shifty);

protected:
  OvImageT<double> mImage1; /**< copy of input image 1. */
  OvImageT<double> mImage2; /**< copy of input image 2 */

  OvImageT<double> mMin1; /**< precomputed minimum image from i1 for speeding up Birchfield Tomasi matching. */
  OvImageT<double> mMax1; /**< precomputed maximum image from i1 for speeding up Birchfield Tomasi matching. */
  OvImageT<double> mMin2; /**< precomputed minimum image from i2 for speeding up Birchfield Tomasi matching. */
  OvImageT<double> mMax2; /**< precomputed maximum image from i2 for speeding up Birchfield Tomasi matching. */


  /**
  * Alpha is a constant used to convert
  * raw pixel intensity matches dI into the range 0 to 1 using exp(-alpha*dI/255), 
  * where alpha is specified by the user as follows:
  * <pre> 
  *   double params[] = {20.0};
  *	btmatcher.setMatchingParams(1,params);
  * </pre>
  * In this example, alpha is set to 20. Smaller values of alpha cause more smoothing.
  * @see setMatchingParams(int nparams, double*params)
  */
  double alpha; 

};

template<typename T>
BTLocalMatcherT<T>::BTLocalMatcherT()
: OvLocalMatcherT<T>(), alpha(20.0)
{
}

template<typename T>
BTLocalMatcherT<T>::~BTLocalMatcherT()
{
}

/**
* Method used for specifying the image pair to be matched.
* This method precomputes stuff needed for Birchfield-Tomasi matching.
* @param i1 the first image
* @param i2 the second image
* @return true if successful (both images are of the same dimensions).
*/
template<typename T>
bool BTLocalMatcherT<T>::setImagePair(const OvImageT<T> & i1, const OvImageT<T> & i2)
{
  int h1,w1,nc1,h2,w2,nc2;
  i1.getDimensions(h1,w1,nc1);
  i2.getDimensions(h2,w2,nc2);

  if((h1!=h2)||(w1!=w2)||(nc1!=nc2)) return false; //if the two images have different dimensions, signal error
  mImage1 = i1;
  mImage2 = i2;

  mMin1 = (mImage1 + minFilter2D(mImage1, 3, 3))/2;
  mMax1 = (mImage1 + maxFilter2D(mImage1, 3, 3))/2;
  mMin2 = (mImage2 + minFilter2D(mImage2, 3, 3))/2;
  mMax2 = (mImage2 + maxFilter2D(mImage2, 3, 3))/2;

  return true;
}

/**
* Used for specifying any parameters required by the matcher.
* @param nparams number of parameters which are being passed
* @param params the values of the parameters
* @return true if successful.
*/
template<typename T>
bool BTLocalMatcherT<T>::setParams(int nparams, double*params)
{
  if(nparams<1) return false;
  alpha = params[0];
  if(alpha<=0) alpha = 20.0; //prevent negative or zero alpha
  return true;
}

/**
* Used to retrieve results of matching the two images with a relative 2D translation. 
* Note: Values of the result are between 0 to 1 always. Parameter alpha is used, and can
* be set using setParams.
* @param shiftx horizontal relative shift
* @param shifty vertical relative shift
* @return resulting single channel image if sucessful (values between 0 (no match) and 1 (match)).
* @see getRawMatch(int shiftx, int shifty)
* @see setParams(int nparams, double*params)
*/

template<typename T>
const OvImageT<double> BTLocalMatcherT<T>::getMatch(int shiftx, int shifty=0)
{
  double tempAlpha;
  tempAlpha = alpha/255.0;
  return exp(-tempAlpha*mean(abs(getRawMatch(shiftx,shifty)),3));
}

/**
* Used to retrieve raw results of matching the two images with a relative 2D translation. 
* Note: The range of values of the result and their interpretation depends on the particular matcher being used.
* @param shiftx horizontal relative shift
* @param shifty vertical relative shift
* @return result image if sucessful, which has same number of channels as the input images.
* @see getMatch(int shiftx, int shifty)
*/
template<typename T>
const OvImageT<double> BTLocalMatcherT<T>::getRawMatch(int shiftx, int shifty=0)
{
  int height, width, nchannels;
  int i1,j1,k,i2,j2,jlo,jhi,ilo,ihi;
  double matchvalue1, matchvalue2, temp;

  OvImageT<double> result(mImage1,false);

  result = 255.0;
  mImage1.getDimensions(height,width,nchannels);
  jlo = (shiftx>=0)?0:-shiftx;
  jhi = (shiftx<=0)?width:(width-shiftx);
  ilo = (shifty>=0)?0:-shifty;
  ihi = (shifty<=0)?height:(height-shifty);

  for(k=0;k<nchannels;k++)
    for(j1=jlo;j1<jhi;j1++)
    {
      j2 = j1 + shiftx;
      for(i1=ilo;i1<ihi;i1++)
      {
        i2 = i1 + shifty;

        temp = mImage1(i1,j1,k);
        matchvalue1 = mMin2(i2,j2,k)-temp;
        if(matchvalue1<0)
        {
          matchvalue1 = temp-mMax2(i2,j2,k);
          if(matchvalue1<0) matchvalue1 = 0;
        }

        temp = mImage2(i2,j2,k);
        matchvalue2 = mMin1(i1,j1,k)-temp;
        if(matchvalue2<0)
        {
          matchvalue2 = temp-mMax1(i1,j1,k);
          if(matchvalue2<0) matchvalue2 = 0;
        }

        //result(i1,j1,k) = (matchvalue1<matchvalue2)?matchvalue1:matchvalue2; 
        result(i1,j1,k) = (matchvalue1+matchvalue2)/2; //changed min to mean: seems to give better results
      }
    }

    return result;

}

#endif //__BTLOCALMATCHERT_H
