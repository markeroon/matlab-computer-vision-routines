/*=========================================================================
$Author: bing.jian $
$Date: 2009-02-10 02:13:49 -0500 (Tue, 10 Feb 2009) $
$Revision: 121 $
=========================================================================*/

/** 
 * \file gmmreg_api.h
 * \brief  The interface of calling gmmreg_api
 */

#ifndef gmmreg_api_h
#define gmmreg_api_h

#ifdef __cplusplus
extern "C"
#endif
int gmmreg_api(const char* f_config, const char* method);

#ifdef __cplusplus
extern "C"
#endif
void print_usage();

#endif //#ifndef gmmreg_api_h


