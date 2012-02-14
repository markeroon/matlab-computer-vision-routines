#ifndef __PROBABILISTICEGOMOTION_H
#define __PROBABILISTICEGOMOTION_H

/** 
* @file ProbabilisticEgomotion.h
* @brief Declarations for functions used for 3D egomotion estimation.
* Code for computing Egomotion from correspondence probability distributions.
* the function compute3Dmotion provides the entire public interface.
* print3Dmotion is a trivial function which prints out the motion parameters in a
* MotionParameters struct.
*
* @author Justin Domke
*/


///structure for storing 3D egomotion parameters.
/**
@see compute3Dmotion(OvImageAdapter & image1, OvImageAdapter & image2, float f, float pp_x, float pp_y, int numpoints, int numsearches)
*/
typedef struct 
{
  float tx;  /**< X-component of translation */
  float ty;  /**< Y-component of translation */
  float tz;  /**< Z-component of translation */
  float r_x; /**< X-component of rotation */
  float r_y; /**< Y-component of rotation */
  float r_z; /**< Z-component of rotation */
  float score; /**< motion score */
} MotionParameters;

/**
* Print out the motion parameters for this particular estimate. i.e.
* <pre>
*    print3Dmotion(egomotion);
* </pre>
* @param egomotion is a MotionParameters struct containing the motion parameters
* @see compute3Dmotion
*/
void print3Dmotion(MotionParameters egomotion);

/**
* @fn MotionParameters compute3Dmotion(OvImageAdapter & image1, OvImageAdapter & image2, float f, float pp_x, float pp_y, int numpoints=500, int numsearches=100);
* Get the egomotion from two calibrated images.
* <pre>
*    MotionParameters egomotion = compute3Dmotion(image1, image2, f, pp_x, pp_y, numpoints, numsearches);
* </pre>
* @param image1 the first image
* @param image2 the second image
* @param f the focal length, in pixels
* @param pp_x the x component of the focal length, in pixels, from the left side of the image
* @param pp_y the y component of the focal length, in pixels, from the left side of the image
* @param numpoints how many correspondence probability distributions to use (default 500) -- more is both slower and more accurate
* @param numsearches how many nonlinear searches to use when attempting to maximize egomotion probability (default 100) -- more is both slower and more robust
* @return a MotionParameters structure containing computed 3D motion
*/
MotionParameters compute3Dmotion(OvImageAdapter & image1, OvImageAdapter & image2, float f, float pp_x, float pp_y, int numpoints=500, int numsearches=100);

#endif //__PROBABILISTICEGOMOTION_H