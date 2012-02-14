/*=========================================================================
$Author: bing.jian $
$Date: 2009-02-10 02:13:49 -0500 (Tue, 10 Feb 2009) $
$Revision: 121 $
=========================================================================*/

/**
 * \file gmmreg_demo.cpp
 * \brief  testing the gmmreg method
 */


#include <iostream>
#include "gmmreg_api.h"


int main(int argc, char* argv[])
{
    if (argc<3)
    {
        std::cerr << "Usage: " << argv[0] << " configfile method" << std::endl;
        print_usage();
        return -1;
    }
    gmmreg_api(argv[1], argv[2]);
    return 0;
}


