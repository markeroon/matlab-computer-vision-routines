#ifndef __GLTree3D_h__
#define __GLTree3D_h__
#endif


//GLTreePro (3D version)
#include <math.h>
#include <stdlib.h>


//The structure used for internal points calculation
struct Coord3D
{
	    double x;
		double y;
		double z;
};



class GLTREE3D
{
    
	

private:
  int *First;//Access table
  int *Next;//next point into the box
  double Minx,Miny,Minz;
  int nx,ny,nz;
 
  
  

  public:
      
      int Np;//max number of points
    //int np;// current nunmber of points
    int Nb;//number of boxes
    double Empty;//Fraction of empty boxes
    double density;//(number of point)/(number of boxes) default=.5
    double step;//dimensioni delle boxes
    int* idStore;
	
	
	

//funzioni membro
    GLTREE3D();//constructor
	~GLTREE3D();//destructor
    int BuildTree(Coord3D*p, int Np);  
    void SearchClosest(Coord3D *p,Coord3D *pk,int* idc,double* mindist);
    void SearchClosestExclusive(Coord3D *p,Coord3D *pk,int* idc,double* mindist,int sp);
	void SearchKClosest(Coord3D *p,Coord3D *pk,int* idc,double* mindist,int k);
      void SearchRadius(Coord3D* p, Coord3D* pk, double r, int* c);
     int Dtest(Coord3D* p,Coord3D* pk,double sqrdist);
	  void RemovePoint(Coord3D* p,int idp);
	  void SearchKClosestExclusive(Coord3D *p, Coord3D *pk, int* idc, double* distances, int k,int sp);
	  void SearchCuboid(Coord3D *p, double* Cuboid,int*npts);
        void SearchRadiusExclusive(Coord3D* p, Coord3D* pk, double r, int* c,int sp);
      //void addpoint
      
};

