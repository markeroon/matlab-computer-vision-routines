#include "MatlabImageAdapter.h"

/**
* Creates a wrapper around a Matlab image (i.e., mxArray) to allow OpenVis3D to easily access it.
* @param im a pointer to an Matlab mxArray object
*/
MatlabImageAdapter::MatlabImageAdapter(mxArray*im)
: OvImageAdapter(), mMatlabImage(im), mImageDataPtr(0)
{
  int tmpNumDims;
  const int *tmpDimSizes;
  mxClassID imageDataType;

  if(mMatlabImage != 0)
  {
    tmpNumDims = mxGetNumberOfDimensions(mMatlabImage);
    tmpDimSizes = mxGetDimensions(mMatlabImage);

    mHeight = tmpDimSizes[0];
    mWidth  = tmpDimSizes[1];
    if(tmpNumDims>2) mChannels = tmpDimSizes[2];
    else mChannels = 1;

    imageDataType = mxGetClassID(mMatlabImage);
    mImageDataPtr = mxGetData(mMatlabImage);

    switch(imageDataType)
    {
    case mxUINT8_CLASS:
      mDataType = OV_DATA_UINT8;
      getPixelfptr = &MatlabImageAdapter::getPixelT<unsigned char>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<unsigned char>;
      break;
    case mxUINT16_CLASS:
      mDataType = OV_DATA_UINT16;
      getPixelfptr = &MatlabImageAdapter::getPixelT<unsigned short>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<unsigned short>;
      break;
    case mxUINT32_CLASS:
      mDataType = OV_DATA_UINT32;
      getPixelfptr = &MatlabImageAdapter::getPixelT<unsigned int>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<unsigned int>;
      break;
    case mxUINT64_CLASS:
      mDataType = OV_DATA_UINT64;
      getPixelfptr = &MatlabImageAdapter::getPixelT<unsigned long long>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<unsigned long long>;
      break;
    case mxINT8_CLASS:
      mDataType = OV_DATA_INT8;
      getPixelfptr = &MatlabImageAdapter::getPixelT<char>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<char>;
      break;
    case mxINT16_CLASS:
      mDataType = OV_DATA_INT16;
      getPixelfptr = &MatlabImageAdapter::getPixelT<short>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<short>;
      break;
    case mxINT32_CLASS:
      mDataType = OV_DATA_INT32;
      getPixelfptr = &MatlabImageAdapter::getPixelT<int>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<int>;
      break;
    case mxINT64_CLASS:
      mDataType = OV_DATA_INT64;
      getPixelfptr = &MatlabImageAdapter::getPixelT<long long>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<long long>;
      break;
    case mxSINGLE_CLASS:
      mDataType = OV_DATA_FLOAT32;
      getPixelfptr = &MatlabImageAdapter::getPixelT<float>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<float>;
      break;
    case mxDOUBLE_CLASS :
      mDataType = OV_DATA_DOUBLE64;
      getPixelfptr = &MatlabImageAdapter::getPixelT<double>; 
      setPixelfptr = &MatlabImageAdapter::setPixelT<double>;
      break;
    default:
      mDataType = OV_DATA_UNKNOWN;
      getPixelfptr = &MatlabImageAdapter::getPixeldoNothing;
      setPixelfptr = &MatlabImageAdapter::setPixeldoNothing;
      break;
    }
  }
  else
  {
    mDataType = OV_DATA_UNKNOWN;
    mHeight = 0;
    mWidth  = 0;
    mChannels = 0;
    getPixelfptr = &MatlabImageAdapter::getPixeldoNothing;
    setPixelfptr = &MatlabImageAdapter::setPixeldoNothing;
  }
}

/**
* Destructor.
*/
MatlabImageAdapter::~MatlabImageAdapter()
{
}

/**
* Returns a pixel value at a particular row, column and color channel.
* @param row row of the image
* @param column column of the image
* @param channel channel of the image
* @return pixel value (type double)
*/
double MatlabImageAdapter::getPixel(int row, int column, int channel) const
{
  if((row<0)||(row>=mHeight)) return 0;
  if((column<0)||(column>=mWidth)) return 0;
  if((channel<0)||(channel>=mChannels)) return 0;

  return (this->*getPixelfptr)(row, column, channel);	
}

/**
* Sets a pixel value at a particular row, column and color channel.
* @param value value to be set
* @param row row of the image
* @param column column of the image
* @param channel channel of the image	
*/
void MatlabImageAdapter::setPixel(double value, int row, int column, int channel)
{
  if((row<0)||(row>=mHeight)) return;
  if((column<0)||(column>=mWidth)) return;
  if((channel<0)||(channel>=mChannels)) return;

  (this->*setPixelfptr)(value, row, column, channel);
}

/**
* Internal template function to handle any image datatype. Returns a pixel value at a particular row, column and color channel.
* @param row row of the image
* @param column column of the image
* @param channel channel of the image
* @return pixel value (type double)
*/
template<class T> double MatlabImageAdapter::getPixelT(int row, int column, int channel) const
{
  T*temp = ((T*)mImageDataPtr) + mHeight*mWidth*channel + column*mHeight + row;
  return (double) *temp;
}

/**
* Internal template function to handle any image datatype. Sets a pixel value at a particular row, column and color channel.
* @param value value to be set
* @param row row of the image
* @param column column of the image
* @param channel channel of the image	
*/
template<class T> void MatlabImageAdapter::setPixelT(double value, int row, int column, int channel)
{
  T*temp = ((T*)mImageDataPtr) + mHeight*mWidth*channel + column*mHeight + row;
  *temp = (T)value;
}

/**
* Dummy function for use when internal mxArray pointer is null or data type unknown.
* @param row row of the image
* @param column column of the image
* @param channel channel of the image
* @return pixel value (type double)
*/
double MatlabImageAdapter::getPixeldoNothing(int row, int column, int channel) const
{	
  return (double) 0;
}

/**
* Dummy function for use when internal mxArray pointer is null or data type unknown.
* @param value value to be set
* @param row row of the image
* @param column column of the image
* @param channel channel of the image
*/
void MatlabImageAdapter::setPixeldoNothing(double value, int row, int column, int channel)
{
  return;
}
