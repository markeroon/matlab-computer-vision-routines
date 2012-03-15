/*=========================================================================
$Author: bingjian $
$Date: 2011-09-06 01:51:56 -0400 (Tue, 06 Sep 2011) $
$Revision: 141 $
=========================================================================*/

/**
 * \file gmmreg_demo.cpp
 * \brief  testing the gmmreg method
 */

#include <iostream>
#include "gmmreg_api.h"

int main(int argc, char* argv[]) {
  if (argc<3) {
    std::cerr << "Usage: " << argv[0] << " configfile method" << std::endl;
    print_usage();
    return -1;
  }
  gmmreg_api(argv[1], argv[2]);
  return 0;
}


