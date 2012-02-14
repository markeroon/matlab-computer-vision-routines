#ifndef __OVIMAGEPAIRPREPROCESSORT_H
#define __OVIMAGEPAIRPREPROCESSORT_H

#include "OvImageT.h"

///Abstract Base Class Template for preprocessing a pair of images.
/** 
* The OvImagePairPreprocessorT class defines a basic interface for preprocessing a pair of images.
* Subclasses can implement the interface to provide a variety of preprocessors 
* (e.g., contrast alignment, color to gray, median filtering, etc.)
*
* @author Abhijit Ogale
*/
template<typename T>
class OvImagePairPreprocessorT
{
public:

  OvImagePairPreprocessorT(); /**< Default constructor with no parameters */

  virtual ~OvImagePairPreprocessorT(); /**< Destructor */

  /**
  * Main method for preprocessing an image pair.
  * Note: This method modifies the input images, so be careful.
  * @param i1 the first image
  * @param i2 the second image
  * @return true if successful.
  */
  virtual bool preProcessImagePair(OvImageT<T> & i1, OvImageT<T> & i2) = 0;

  /**
  * Used for specifying any parameters required.
  * @param nparams number of parameters which are being passed
  * @param params the values of the parameters
  * @return true if successful.
  */
  virtual bool setParams(int nparams, double*params) = 0;
};

template<typename T>
OvImagePairPreprocessorT<T>::OvImagePairPreprocessorT()
{
}

template<typename T>
OvImagePairPreprocessorT<T>::~OvImagePairPreprocessorT()
{
}

#endif //__OVIMAGEPAIRPREPROCESSORT_H
