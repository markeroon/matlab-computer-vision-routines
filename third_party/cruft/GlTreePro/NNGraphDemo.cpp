#include "mex.h"




#include "GLTree2D.cpp"
#include "GLTree3D.cpp"
//#include "FunctionsLib.h"


/* the gateway function */
// In matlab la funzione deve essere
//[NNG,dist]=KNNGraphDemo(p)

void mexFunction( int nlhs, mxArray *plhs[2],
int nrhs,  const mxArray *prhs[1])
{
    
    double       *p;
    double  *ptrtree;
    double * idcdouble;
    int N,dim,i,j,idc;
    double* outdistances;
    

    // Errors check

    if(nrhs!=1)
        mexErrMsgTxt("only 1 inputs required.");
    
      if(nlhs>2)
    {  mexErrMsgTxt("Maximum two outputs supported");}
    
    
    

   
 dim=mxGetM(prhs[0]);

 
//  mexPrintf("N= %4.4f Nq=%4.4f\n",N,Nq);
 if(dim!=2 && dim!=3)
  { mexErrMsgTxt("Only 2D & 3D points supported ");
         } 
  
  if( !mxIsDouble(prhs[0]))
 { mexErrMsgTxt("Inputs must be double vectors ");
         } 
    
    
    
    p = mxGetPr(prhs[0]);//puntatore all'array dei punti

     N=mxGetN(prhs[0]);//dimensione reference

    plhs[0] = mxCreateDoubleMatrix(N,1,mxREAL);//costruisce l'output array
    idcdouble = mxGetPr(plhs[0]);//appicicaci il puntatore 
   
     plhs[1] = mxCreateDoubleMatrix(N,1,mxREAL);//costruisce l'output array
     outdistances = mxGetPr(plhs[1]);//appicicaci il puntatore
    
    //   mexPrintf("Dopo aver settato gli output\n");
     
    //Build the tree
    if (dim==2)
    {
	
        Coord2D* p2D=(Coord2D*) p; 
       GLTREE2D* Tree2D=new GLTREE2D;
		Tree2D->BuildTree(&p2D[0],N);
        for (i=0;i<N;i++)
        {
            
             Tree2D->SearchClosestExclusive(&p2D[0],&p2D[i],&idc,&outdistances[i],i);//lancio la routine per la ricerca del pi� vicino
             idcdouble[i]=idc+1; 
        }
		delete Tree2D;
    }
    else
    {
      Coord3D* p3D=(Coord3D*) p; 
      GLTREE3D* Tree3D=new GLTREE3D;  
	  Tree3D->BuildTree(&p3D[0],N);
        for (i=0;i<N;i++)
        {
             Tree3D->SearchClosestExclusive(&p3D[0],&p3D[i],&idc,&outdistances[i],i);//lancio la routine per la ricerca del pi� vicino
             idcdouble[i]=idc+1; 
        } 
		delete Tree3D;  
    }

}





