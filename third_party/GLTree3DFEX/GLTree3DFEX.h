#include <math.h>
#include <time.h>
#include <stdlib.h>
#include <vector>
using namespace std;// per usare i vector


struct Coord3D
{
	    double x;
		double y;
		double z;
};

struct GLNode
{
	 int idpoint;
	int next;
};

class GLTREE
{
    private:
	int N;//number of points
  GLNode *Leaves;
  int *First;
  double Toll;
  double Minx,Miny,Minz,PX,PY,PZ;//Sistema di riferimento
  int nxint,nyint,nzint;
 
  
  

  public:

     int* IdStore;
	GLTREE( Coord3D * p,int Np);//constructor
	~GLTREE();//destructor
	
	

//funzioni membro
	//void GLTREE::SearchRadius(Coord3D* p,Coord3D* pk,double r,vector<int>* idcv);
    void GLTREE::SearchClosest(Coord3D *p,Coord3D *pk,int* idc,double* mindist);
    void GLTREE::SearchKClosest(Coord3D *p,Coord3D *pk,int* idc,double* mindist,int k);
      void GLTREE::SearchRadius(Coord3D* p, Coord3D* pk, double r, int* c);
};

