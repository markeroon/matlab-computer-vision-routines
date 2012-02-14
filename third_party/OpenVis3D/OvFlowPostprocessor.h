#ifndef __OVFLOWPOSTPROCESSOR_H
#define __OVFLOWPOSTPROCESSOR_H

#include "OvImageT.h"

///Abstract Base Class for postprocessing optical flow results.
/** 
* The OvFlowPostprocessor class defines a basic interface for postprocessing optical flow results.
* Subclasses can implement the interface to provide a variety of preprocessors 
* (e.g., occlusion filling, median filtering, plane fitting, etc.)
*
* @author Abhijit Ogale
*/

class OvFlowPostprocessor
{
public:

  OvFlowPostprocessor(); /**< Default constructor with no parameters */

  virtual ~OvFlowPostprocessor(); /**< Destructor */

  /**
  * Main method for postprocessing flow results.
  * Note: This method modifies the inputs, so be careful.
  * @param u1 the horizontal flow for image 1. (method sets this).
  * @param v1 the vertical flow for image 1. (method sets this).
  * @param o1 the occlusion map for image 1. (method sets this).
  * @param u2 the horizontal flow for image 2. (method sets this).
  * @param v2 the vertical flow for image 2. (method sets this).
  * @param o2 the occlusion map for image 2. (method sets this).
  * @return true if successful.
  */
  virtual bool postProcessFlow(OvImageT<double> & u1, OvImageT<double> & v1, OvImageT<double> & o1, OvImageT<double> & u2, OvImageT<double> & v2,  OvImageT<double> & o2) = 0;

  /**
  * Used for specifying any parameters required.
  * @param nparams number of parameters which are being passed
  * @param params the values of the parameters
  * @return true if successful.
  */
  virtual bool setParams(int nparams, double*params) = 0;
};

OvFlowPostprocessor::OvFlowPostprocessor()
{
}

OvFlowPostprocessor::~OvFlowPostprocessor()
{
}

#endif //__OVFLOWPOSTPROCESSOR_H
