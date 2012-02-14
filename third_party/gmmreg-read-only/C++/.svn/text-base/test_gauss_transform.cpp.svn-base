/*=========================================================================
$Author$
$Date$
$Revision$
=========================================================================*/


/**
 * \file test_gauss_transform.cpp
 * \brief  testing the Gauss transform
 */


#include <assert.h>

#include <ctime>
#include <iostream>
#include <fstream>

#include "gmmreg_utils.h"


int main(int argc, char* argv[])
{

    if (argc<4)
    {
        std::cerr<<"Usage: "<< argv[0]<<" pts1 pts2 scale [gradient]" << std::endl;
        std::cerr<<"  pts1, pts2, gradient(optional) -- ascii text files " << std::endl;
        std::cerr<<"  scale -- numerical scalar value" << std::endl;
        std::cerr<<"Example: " << argv[0] << " pts1.txt pts2.txt 1.0 gradient.txt"<<std::endl;
        return -1;
    }
    vnl_matrix<double> A;
    vnl_matrix<double> B;


    std::ifstream file1(argv[1]);
    A.read_ascii(file1);

    std::ifstream file2(argv[2]);
    B.read_ascii(file2);

    int m = A.rows();
    int n = B.rows();
    int d = A.cols();
    assert(m>0&&n>0&&d>0&&B.cols()==d);

    vnl_matrix<double> gradient;
    gradient.set_size(m,d);
    gradient.fill(0);
    double scale = atof(argv[3]);
    double cost = 0;



    clock_t start, end;
    double elapsed;

    start = clock();

    cost = GaussTransform(A, B, scale, gradient);
    end = clock();
    elapsed = 1000*((double) (end - start)) / CLOCKS_PER_SEC;

    std::cout << "Evaluate Gauss Transform: " << cost << " in " <<  elapsed << " ms." << std::endl;

    if (argc>4)
    {
        std::ofstream outfile(argv[4],std::ios_base::out);
        gradient.print(outfile);
    }

    //    system("pause");
    return 0;
}
