#ifndef __MATLABIMAGEADAPTER_H
#define __MATLABIMAGEADAPTER_H

#include "OvImageAdapter.h"

extern "C" {
#include "mex.h"
}

///Provides an interface to Matlab images.
/** 
* The MatlabImageAdapter class is inherited from the OvImageAdapter and 
* provides a wrapper around Matlab's mxArray allowing the OpenVis3D library functions to access the 
* dimensions and datatype of the image, and provides get and set methods to alter image pixels. 
*
* @see OvImageAdapter
*
* @author Abhijit Ogale
*/
class MatlabImageAdapter :	public OvImageAdapter
{
  MatlabImageAdapter(){}; /**< to prevent the default constructor from being used */

public:
  MatlabImageAdapter(mxArray*im);
  virtual ~MatlabImageAdapter();

  virtual double getPixel(int row, int column, int channel) const;
  virtual void   setPixel(double value, int row, int column, int channel);

protected:
  mxArray* mMatlabImage;	/**< saved pointer to Matlab mxArray object */
  void * mImageDataPtr;   /**< saved pointer to the raw data array within the Matlab mxArray object */

  double (MatlabImageAdapter::*getPixelfptr) (int row, int column, int channel) const; /**< function pointer used to store getpixel function appropriate for image datatype */
  void (MatlabImageAdapter::*setPixelfptr) (double value, int row, int column, int channel); /**< function pointer used to store setpixel function appropriate for image datatype */

  template<class T> double getPixelT(int row, int column, int channel) const;
  template<class T> void setPixelT(double value, int row, int column, int channel);

  double getPixeldoNothing(int row, int column, int channel) const;
  void   setPixeldoNothing(double value, int row, int column, int channel);
};

#endif
