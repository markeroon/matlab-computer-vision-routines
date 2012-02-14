#include <iostream>
#include <cv.h> 

#ifndef FILEREADER_H
#define FILEREADER_H
class FileReader {
	public :
		FileReader( std::string configFile );
		~FileReader( );
		CvMat** getProjectionMatrixArray( );
		std::string getImageFilename( int index );
		CvMat* getProjectionMatrix( int index );
		int getNumImages( );
	private :
		static const int MAX_NUM_IMAGES = 600;
		void printProjectionMatrix( int index );
		CvMat* K[MAX_NUM_IMAGES];
		CvMat* R[MAX_NUM_IMAGES];
		CvMat* t[MAX_NUM_IMAGES];
		CvMat* P[MAX_NUM_IMAGES];
		CvMat* projMat[MAX_NUM_IMAGES];
		std::string filename[MAX_NUM_IMAGES];
		int numLines;
		void extractFilenameAndProjectionMat( char* line, int i );
		std::string configFile;
		void getInfo( );
};
#endif
