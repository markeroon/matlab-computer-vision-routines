#include "OvImageAdapter.h"

OvImageAdapter::OvImageAdapter()
: mHeight(0), mWidth(0), mChannels(0), mDataType(OV_DATA_UNKNOWN)
{
}

OvImageAdapter::~OvImageAdapter()
{
}

void OvImageAdapter::getSize(int & height, int & width, int & nColorChannels) const
{
  height = mHeight;
  width = mWidth;
  nColorChannels = mChannels;
}

void OvImageAdapter::getDataType(OvImageAdapter::OvDataType & dataType) const
{
  dataType = mDataType;
}

