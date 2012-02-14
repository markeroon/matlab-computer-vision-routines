#ifndef __GLTree2D_h__
#define __GLTree2D_h__
#endif


//GLTreePro (2D version)
#include <math.h>
#include <stdlib.h>


//The structure used for internal points calculation
struct Coord2D
{
	    double x;
		double y;
};



class GLTREE2D
{
    
	

private:
  int *First;//Access table
  int *Next;//next point into the box
  double Minx,Miny;
  int nx,ny;
 
  
  

  public:
      
      int Np;//max number of points
    //int np;// current nunmber of points
    int Nb;//number of boxes
    double Empty;//Fraction of empty boxes
    double density;//(number of point)/(number of boxes) default=.5
    double step;//dimensioni delle boxes
    int* idStore;
	
	
	

//funzioni membro
    GLTREE2D();//constructor
	~GLTREE2D();//destructor
    int BuildTree(Coord2D*p, int Np);  
    void SearchClosest(Coord2D *p,Coord2D *pk,int* idc,double* mindist);
    void SearchClosestExclusive(Coord2D *p,Coord2D *pk,int* idc,double* mindist,int sp);
	void SearchKClosest(Coord2D *p,Coord2D *pk,int* idc,double* mindist,int k);
      void SearchRadius(Coord2D* p, Coord2D* pk, double r, int* c);
     int Dtest(Coord2D* p,Coord2D* pk,double sqrdist);
	  void RemovePoint(Coord2D* p,int idp);
	  void SearchKClosestExclusive(Coord2D *p, Coord2D *pk, int* idc, double* distances, int k,int sp);
	  void SearchCuboid(Coord2D *p, double* Cuboid,int*npts);
	  void SearchRadiusExclusive(Coord2D* p, Coord2D* pk, double r, int* c,int sp);
      //void addpoint
      
};

