#ifndef __OPENCVIMAGEADAPTER_H
#define __OPENCVIMAGEADAPTER_H

#include <cv.h>
#include "OvImageAdapter.h"

///Provides an interface to images from the OpenCV library.
/** 
* The OpenCVImageAdapter class is inherited from the OvImageAdapter and 
* provides a wrapper around OpenCV's IplImage allowing the OpenVis3D library functions to access the 
* dimensions and datatype of the image, and provides get and
* set methods to alter image pixels. 
*
* @see OvImageAdapter
*
* @author Abhijit Ogale
*/
class OpenCVImageAdapter :	public OvImageAdapter
{
  OpenCVImageAdapter(){}; /**< to prevent the default constructor from being used */

public:
  OpenCVImageAdapter(IplImage*im);
  virtual ~OpenCVImageAdapter();

  virtual double getPixel(int row, int column, int channel) const;
  virtual void   setPixel(double value, int row, int column, int channel);

protected:
  IplImage*mIplImage;	/**< saved pointer to OpenCV IplImage object */

  double (OpenCVImageAdapter::*getPixelfptr) (int row, int column, int channel) const; /**< function pointer used to store getpixel function appropriate for image datatype */
  void   (OpenCVImageAdapter::*setPixelfptr) (double value, int row, int column, int channel); /**< function pointer used to store setpixel function appropriate for image datatype */

  template<typename T> double getPixelT(int row, int column, int channel) const;
  template<typename T> void   setPixelT(double value, int row, int column, int channel);

  double getPixeldoNothing(int row, int column, int channel) const;
  void   setPixeldoNothing(double value, int row, int column, int channel);
};

#endif
