#include "GLTree.h"
#include "hr_time.h"
#include <stdio.h>
#include <iostream>




int main()
{//La vecchia versione impiegava 0.8 secondi per la riceraca con nq=1000000 ref=100

	

	CStopWatch  Timer;//High resolution timer class
  long double  duration1,duration2;
   Coord3D *p; //pointer to reference point
   
Coord3D *qp; //pointer to query point


char choice;
double ExtimatedTime;
 
__int32  i,j;//counters
 int N;//reference points
 int Nq;//query points
 int *results;


//prototipe declarations
   void GenerateRandom3D(Coord3D* ,int n) ;
   void PrintVector(vector<int> vect);
   void BruteRSearch(Coord3D *p,Coord3D* qp ,double r,int N,vector<int>* idcv);
   int BruteSearch3D(Coord3D *p ,int N,Coord3D* qp);

   srand( (unsigned)time( NULL ) );//seed the random generator

    printf( "Program Started\n\n");
  
     cout<<"How many reference points?"<<endl;
   cin>>N;
    cout<<"How many query points?"<<endl;
   cin>>Nq;

   results=new int[Nq];//vector of results

    ExtimatedTime=N*Nq/100000000;

    printf( "You choose %4.1d reference point and  %4.1d query point\n",N,Nq);
	



   /*
   //print generated points
   for (i=0;i<N;i++)
   {   printf("%4.4f %4.4f\n",p.X[i],p.Y[i]);}
   */

    qp=new Coord3D[Nq];
	
	
   Timer.startTimer();
// Random Query point generation
   GenerateRandom3D(qp,Nq);
   Timer.stopTimer() ;
    duration1=Timer.getElapsedTime();
   printf( "Generating %d 3D query points took %4.4f ms\n",Nq,duration1);

   
   //print generated points
   //for (i=0;i<Nq;i++)
   //{   printf("%4.4f %4.4f\n",qp.X[i],qp.Y[i]);}
   

    p=new Coord3D[N];
	
	
Timer.startTimer();
// Random Reference point generation
   GenerateRandom3D(p,N);
  Timer.stopTimer() ;
    duration1=Timer.getElapsedTime();
   printf( "Generating %d 3D reference points took %4.4f ms\n",N,duration1);

 printf("\n\nStart Searching!!\n\n");


// Build Boxes
        Timer.startTimer();

     GLTREE3D Tree;//declaration and building of Gltree class
     Tree.BuildTree(p,N);

	  Timer.stopTimer() ;
    duration1=Timer.getElapsedTime();
   printf( "Building the Tree took %4.4f ms\n",duration1);

 

  


/*

  ///////////////////////////////////////////
   //GLtree Range Search
   //////////////////////////////////////////////
 
   vector<int> idcr;

  double  r=0.0001;
    for (i=0;i<Nq;i++)
	{
	
//Gltree Radius search

		 Tree.SearchRadius( p,&qp[i],r,&idcr);
	
			// PrintVector(idcr);

			idcr.erase (idcr.begin(),idcr.end());//cancella il contenuto del vector
	

//Brute test
	// BruteRSearch(p,&qp[i],r,N,&idcr);
    
	// PrintVector(idcr);

      // idcr.erase (idcr.begin(),idcr.end());//cancella il contenuto del vector
	}


*/
		
	//Gltree CLosest search	

      int k=1;
      double* distances=new double[k];
	  int idc1;
      int idc2;

         Timer.startTimer();
		for (j=0;j<Nq;j++)
		{

          Tree.SearchKClosest(p,&qp[j],&idc1,&distances[0],k);
            
		  /*
          idc2=BruteSearch3D(p ,N,&qp[j]);

		  if(idc1!=idc2)
		  {
             printf( "Bug Found\n");
             system("PAUSE");
		  }
		  */
		  
		  
		}
        Timer.stopTimer() ;
    duration1=Timer.getElapsedTime();
   printf( "Search of %4.0d query points took %4.4f ms\n",Nq,duration1);



	 printf( "\nProgram Ended\n\n");
   ////////////////////////////////////////  
     

	system("PAUSE");

	delete [] distances;

	return 0;
}


void PrintVector(vector<int> vect)
{
	unsigned int j;
	printf("start\n");
      if (vect.size()>0)
	  { for (j=0;j<vect.size();j++)
		{ 
			printf("%4.1d ",vect[j]);
		}
		printf("\n");
	   }
	  else 
	  {printf("empty\n");}
	  printf("end\n");
}





int BruteSearch3D(Coord3D *p ,int N,Coord3D* qp)
{  
	

	 int i;
	 int idc;
	  double mindist=HUGE_VAL;
	  double dist=HUGE_VAL;
    
	 

     for (i=0;i<N;i++)
		{  
		   if ((dist=(p[i].x-qp->x)*(p[i].x-qp->x)+(p[i].y-qp->y)*(p[i].y-qp->y)+(p[i].z-qp->z)*(p[i].z-qp->z))<mindist)
		   {mindist=dist;
		   idc=i;}
	   }

	return idc;
}




void BruteRSearch(Coord3D *p,Coord3D* qp ,double r,int N,vector<int>* idcv)
{ 
	
    //p reference point
	//qp query point
	// radius
	// number of reference points
	// vector for results storage

	 int i,j;
	 double mindist=r*r;
	 double dist;


     for (i=0;i<N;i++)
		{  

		   if (dist=(p[i].x-qp->x)*(p[i].x-qp->x)+(p[i].y-qp->y)*(p[i].y-qp->y)+(p[i].z-qp->z)*(p[i].z-qp->z)<mindist)
		   {
		   idcv->push_back(i);
		   }
	   }
     
}




void GenerateRandom3D(Coord3D* p,int n) 
{//function to generate random points in 0-1 range



// loop to generate random points not normalized
    int i;//counter;
	int tempmax=0;//temporary integer maximum random point;
	
    
	

    for( i = 0;   i <n;i++ )
	{	
		//X
		p[i].x=rand();
		if (p[i].x>tempmax)
		{tempmax=p[i].x;}
		
		//Y
		p[i].y=rand();
		if (p[i].y>tempmax)
		{tempmax=p[i].y;}
		
		//Z
		p[i].z=rand();
		if (p[i].z>tempmax)
		{tempmax=p[i].z;}
		
		

	}
	

    //loop to normalize
    for( i = 0;   i <n;i++ )
	{
		p[i].x=p[i].x/tempmax;
	
		p[i].y=p[i].y/tempmax;

		p[i].z=p[i].z/tempmax;
	}
}



