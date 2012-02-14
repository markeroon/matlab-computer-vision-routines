#ifndef __OVIMAGEADAPTER_H
#define __OVIMAGEADAPTER_H

///Abstract Base Class for creating interfaces to import unknown image formats.
/** 
* The OvImageAdapter base class defines a very basic interface to an image which
* provides access to the dimensions and datatype of the image, and provides get and
* set methods to alter image pixels. A class derived from OvImageAdapter must implement
* the pixel get/set and information methods. Using OvImageAdapter objects, the library 
* allows the user to interface with any image model. See the OpenCVImageAdapter or
* MatlabImageAdapter subclasses for interfacing examples.
*
* @see OpenCVImageAdapter
* @see MatlabImageAdapter
*
* @author Abhijit Ogale
*/
class OvImageAdapter
{
public:
  OvImageAdapter(); /**< Default constructor with no parameters */
  virtual ~OvImageAdapter(); /**< Destructor */

  /** 
  * Enumeration of allowed data types.
  * @see mDataType
  */
  enum OvDataType {
    OV_DATA_UNKNOWN, /**< unknown */
    OV_DATA_UINT8,   /**< unsigned char */
    OV_DATA_INT8,	 /**< char */
    OV_DATA_UINT16,  /**< short */
    OV_DATA_INT16,   /**< unsigned short */
    OV_DATA_UINT32,  /**< int */
    OV_DATA_INT32,   /**< unsigned int */
    OV_DATA_UINT64,  /**< unsigned long long */
    OV_DATA_INT64,   /**< long long */
    OV_DATA_FLOAT32, /**< float */
    OV_DATA_DOUBLE64 /**< double */
  };

  /**
  * Returns height, width and number of color channels of image.
  * @param height height of image
  * @param width width of image
  * @param nColorChannels number of color channels of image
  */
  virtual void getSize(int & height, int & width, int & nColorChannels) const; 

  /**
  * Returns data type of image.
  * @param dataType data type of image (from enum OvDataType)
  * @see OvDataType
  */
  virtual void getDataType(OvImageAdapter::OvDataType & dataType) const;

  /**
  * Returns a pixel value at a particular row, column and color channel.
  * This is a pure virtual function.
  * @param row row of the image
  * @param column column of the image
  * @param channel channel of the image
  * @return pixel value (type double)
  */
  virtual double getPixel(int row, int column, int channel) const = 0;

  /**
  * Sets a pixel value at a particular row, column and color channel.
  * This is a pure virtual function.
  * @param value value to be set
  * @param row row of the image
  * @param column column of the image
  * @param channel channel of the image	
  */
  virtual void   setPixel(double value, int row, int column, int channel) = 0;

protected:
  int  mHeight;			/**< height of the image */
  int  mWidth;			/**< width of the image */
  int  mChannels;			/**< number of color channels (e.g., 1 for grayscale, 3 for RGB) */

  /**
  * Data format of a pixel channel
  * @see OvDataType
  */
  OvDataType mDataType;   
};

#endif
