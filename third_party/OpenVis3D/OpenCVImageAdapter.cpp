#include "OpenCVImageAdapter.h"

/**
* Creates a wrapper around an OpenCV image to allow OpenVis3D to easily access it.
* @param im a pointer to an IplImage object
*/
OpenCVImageAdapter::OpenCVImageAdapter(IplImage*im)
: OvImageAdapter(), mIplImage(im)
{
  if(mIplImage != 0)
  {
    mHeight = mIplImage->height;
    mWidth  = mIplImage->width;
    mChannels = mIplImage->nChannels;

    switch(mIplImage->depth)
    {
    case IPL_DEPTH_8U:
      mDataType = OV_DATA_UINT8;
      getPixelfptr = &OpenCVImageAdapter::getPixelT<unsigned char>; 
      setPixelfptr = &OpenCVImageAdapter::setPixelT<unsigned char>;
      break;
    case IPL_DEPTH_16U:
      mDataType = OV_DATA_UINT16;
      getPixelfptr = &OpenCVImageAdapter::getPixelT<unsigned short>; 
      setPixelfptr = &OpenCVImageAdapter::setPixelT<unsigned short>;
      break;
    case IPL_DEPTH_8S:
      mDataType = OV_DATA_INT8;
      getPixelfptr = &OpenCVImageAdapter::getPixelT<char>; 
      setPixelfptr = &OpenCVImageAdapter::setPixelT<char>;
      break;
    case IPL_DEPTH_16S:
      mDataType = OV_DATA_INT16;
      getPixelfptr = &OpenCVImageAdapter::getPixelT<short>; 
      setPixelfptr = &OpenCVImageAdapter::setPixelT<short>;
      break;
    case IPL_DEPTH_32S:
      mDataType = OV_DATA_INT32;
      getPixelfptr = &OpenCVImageAdapter::getPixelT<int>; 
      setPixelfptr = &OpenCVImageAdapter::setPixelT<int>;
      break;
    case IPL_DEPTH_32F:
      mDataType = OV_DATA_FLOAT32;
      getPixelfptr = &OpenCVImageAdapter::getPixelT<float>; 
      setPixelfptr = &OpenCVImageAdapter::setPixelT<float>;
      break;
    case IPL_DEPTH_64F:
      mDataType = OV_DATA_DOUBLE64;
      getPixelfptr = &OpenCVImageAdapter::getPixelT<double>; 
      setPixelfptr = &OpenCVImageAdapter::setPixelT<double>;
      break;
    default:
      mDataType = OV_DATA_UNKNOWN;
      getPixelfptr = &OpenCVImageAdapter::getPixeldoNothing;
      setPixelfptr = &OpenCVImageAdapter::setPixeldoNothing;
      break;
    }
  }
  else
  {
    getPixelfptr = &OpenCVImageAdapter::getPixeldoNothing;
    setPixelfptr = &OpenCVImageAdapter::setPixeldoNothing;
    mHeight = 0;
    mWidth  = 0;
    mChannels = 0;
    mDataType = OV_DATA_UNKNOWN;
  }
}

/**
* Destructor.
*/
OpenCVImageAdapter::~OpenCVImageAdapter()
{
}


/**
* Returns a pixel value at a particular row, column and color channel.
* @param row row of the image
* @param column column of the image
* @param channel channel of the image
* @return pixel value (type double)
*/
double OpenCVImageAdapter::getPixel(int row, int column, int channel) const
{	
  return (double) (this->*getPixelfptr)(row, column, channel);	
}

/**
* Sets a pixel value at a particular row, column and color channel.
* @param value value to be set
* @param row row of the image
* @param column column of the image
* @param channel channel of the image	
*/
void OpenCVImageAdapter::setPixel(double value, int row, int column, int channel)
{	
  (this->*setPixelfptr)(value, row, column, channel);
}

/**
* Internal template function to handle any image datatype. Returns a pixel value at a particular row, column and color channel.
* @param row row of the image
* @param column column of the image
* @param channel channel of the image
* @return pixel value (type double)
*/
template<class T> double OpenCVImageAdapter::getPixelT(int row, int column, int channel) const
{
  if((row<0)||(row>=mHeight)) return 0;
  if((column<0)||(column>=mWidth)) return 0;
  if((channel<0)||(channel>=mChannels)) return 0;

  T*temp = &((T*)(mIplImage->imageData + mIplImage->widthStep*row))[column*mChannels];
  return (double) temp[channel];
}

/**
* Internal template function to handle any image datatype. Sets a pixel value at a particular row, column and color channel.
* @param value value to be set
* @param row row of the image
* @param column column of the image
* @param channel channel of the image	
*/
template<class T> void OpenCVImageAdapter::setPixelT(double value, int row, int column, int channel)
{
  if((row<0)||(row>=mHeight)) return;
  if((column<0)||(column>=mWidth)) return;
  if((channel<0)||(channel>=mChannels)) return;

  T*temp = &((T*)(mIplImage->imageData + mIplImage->widthStep*row))[column*mChannels];
  temp[channel] = (T) value;
}

/**
* Dummy function for use when internal IplImage pointer is null or data type unknown.
* @param row row of the image
* @param column column of the image
* @param channel channel of the image
* @return pixel value (type double)
*/
double OpenCVImageAdapter::getPixeldoNothing(int row, int column, int channel) const
{	
  return (double) 0;
}

/**
* Dummy function for use when internal IplImage pointer is null or data type unknown.
* @param value value to be set
* @param row row of the image
* @param column column of the image
* @param channel channel of the image
*/
void OpenCVImageAdapter::setPixeldoNothing(double value, int row, int column, int channel)
{
  return;
}
