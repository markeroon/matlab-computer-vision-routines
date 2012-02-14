#include <iostream>
#include <fstream>
#include <cv.h>
#include <highgui.h>
#include "FileReader.h"
#include <sstream>
#include "mex.h"

void mexFunction( int nlhs, mxArray *plhs[],
		  int nrhs, const mxArray *prhs[] )  {
	
	//FileReader* fileRead = new FileReader( "dino/dino_par.txt" );		
	//for( int i=1; i<=363; i++ ) {
	//	plhs[i] = mxCreateNumericArray(NDIM, data_array_dims_out, mxDOUBLE_CLASS, mxREAL);

	//}
	mexPrintf( "number of arrays %d\n", nlhs );

}

FileReader::FileReader( std::string configFile ) {
	
	this->configFile = configFile;
	getInfo( );
}

FileReader::~FileReader( ) {
	for( int i=0; i<numLines; i++ ) {
		cvReleaseMat( &K[i] );
		cvReleaseMat( &R[i] );
		cvReleaseMat( &t[i] );
		cvReleaseMat( &P[i] );
		cvReleaseMat( &projMat[i] );
	}

}
/**
 * Return a pointer to an array of pointers to CvMats (that store projection
 * matrices).
 **/
CvMat** FileReader::getProjectionMatrixArray( ) {
	return projMat;	
}


int FileReader::getNumImages( ) {
	return numLines;
}

std::string FileReader::getImageFilename( int index ) {
	std::stringstream ss;
	// HACK!!!!!	
	//ss << "dinoSparseRing/" << filename[index];
	ss << "dino/" << filename[index];
	return ss.str( );
}

void FileReader::printProjectionMatrix( int index ) {
	std::cout << "projection matrix #" << index << std::endl;
	for( int i=0; i<3; i++ ) {
		for( int j=0; j<4; j++ ) {
			std::cout << cvmGet( projMat[index], i, j ) << " ";
		}
		std::cout << std::endl;
	}
}

CvMat* FileReader::getProjectionMatrix( int index ) {
	return projMat[index];
}
void FileReader::getInfo( ) {
	char* str = NULL;
	str = new char[2000];
	//char* token;
	std::fstream inFile( configFile.c_str() );
	inFile.getline( str, 2000 );
	
	// first line give the number of images in the sequence
	numLines = atoi( str );
	if( numLines > MAX_NUM_IMAGES ) {
		std::cerr << "Too many images in this sequence!" << std::endl;
		exit( 1 );
	}
	
	int index = 0;
	while( ( index < numLines ) && ( !inFile.eof( ) ) ) {
		inFile.getline( str, 2000 );
		extractFilenameAndProjectionMat( str, index );
		std::cout << str << std::endl;
		index++;	
	}
	std::cout << "exits loop" << std::endl;
	inFile.close( );
	// deallocate string
	delete [] str;
}

void FileReader::extractFilenameAndProjectionMat( char* line, int i ) {
	char* token;
	token = strtok( line, " " );
	filename[i] = std::string( token );
	//std::cout << "filename: " << filename[i];

	K[i] = cvCreateMat( 3, 3, CV_32F );
	R[i] = cvCreateMat( 3, 3, CV_32F );
	t[i] = cvCreateMat( 3, 1, CV_32F );               

	// the projection matrix
	P[i] = cvCreateMat( 3, 4, CV_32F );
	projMat[i] = cvCreateMat( 3, 4, CV_32F );

	// fill K
	token = strtok( NULL, " " );
	CV_MAT_ELEM( *K[i], float, 0, 0 ) = atof( token );  
	
	token = strtok( NULL, " " );
	CV_MAT_ELEM( *K[i], float, 0, 1 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *K[i], float, 0, 2 ) = atof( token );

        token = strtok( NULL, " " );
	CV_MAT_ELEM( *K[i], float, 1, 0 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *K[i], float, 1, 1 ) = atof( token );
					        
	token = strtok( NULL, " " );
	CV_MAT_ELEM( *K[i], float, 1, 2 ) = atof( token );

        token = strtok( NULL, " " );
	CV_MAT_ELEM( *K[i], float, 2, 0 ) = atof( token );
		        
	token = strtok( NULL, " " );
	CV_MAT_ELEM( *K[i], float, 2, 1 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *K[i], float, 2, 2 ) = atof( token );

	// fill R
        token = strtok( NULL, " " );
	CV_MAT_ELEM( *R[i], float, 0, 0 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *R[i], float, 0, 1 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *R[i], float, 0, 2 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *R[i], float, 1, 0 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *R[i], float, 1, 1 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *R[i], float, 1, 2 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *R[i], float, 2, 0 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *R[i], float, 2, 1 ) = atof( token );

	token = strtok( NULL, " " );
	CV_MAT_ELEM( *R[i], float, 2, 2 ) = atof( token );

	
	// fill T
	token = strtok( NULL, " " );
	CV_MAT_ELEM( *t[i], float, 0, 0 ) = atof( token );
			 
	token = strtok( NULL, " " );
	CV_MAT_ELEM( *t[i], float, 1, 0 ) = atof( token );

	token = strtok( NULL, " " );            
	CV_MAT_ELEM( *t[i], float, 2, 0 ) = atof( token );

	// fill P
	for( int j=0; j<3; j++ ) {
		for( int k=0; k<3; k++ ) {
			CV_MAT_ELEM( *P[i], float, j, k ) = cvmGet( R[i], j, k );
		}
		CV_MAT_ELEM( *P[i], float, j, 3 ) = cvmGet( t[i], j, 0 );
	}

	cvMatMul( K[i], P[i], projMat[i] );
	if( i < 20 ) {
		printProjectionMatrix( i );
	}
}
