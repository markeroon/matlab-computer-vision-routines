#include "mex.h"




#include "GLTree2D.cpp"
//#include "FunctionsLib.h"


// In Matlab la funzione deve essere idc=NNSearch(x,y,pk,ptrtree)

/* the gateway function */
//In Matlab deve essere idc=RSearch(px,py,qx,qy,ptrtree,r) 

void mexFunction( int nlhs, mxArray *plhs[1],
int nrhs,  const mxArray *prhs[5])
{
    
    double       *p;
    double       *qp;
    double  *ptrtree,*idcdouble;
    int N,Nq,i;
    
    
    
    
    // Errors check
    
    if(nrhs!=4)
    { mexErrMsgTxt("Four inputs required.");}
    
     if(nlhs>1)
    { mexErrMsgTxt("Only one output supported.");}
    
    
   N=mxGetM(prhs[0]);
 Nq=mxGetM(prhs[1]);
 if ( Nq!=2 || N!=2)
  {
      mexErrMsgTxt("Rsearch only supports 2D points");
         }  

   
 N=mxGetN(prhs[0]);
 Nq=mxGetN(prhs[1]);
 if ( Nq >1)
  {
      mexErrMsgTxt("Rsearch only supports a single query point");
         }
  
  if( !mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1]) || !mxIsDouble(prhs[2] ))
 { 
     mexErrMsgTxt("Inputs must be double array ");
         } 
    
    
    
    p = mxGetPr(prhs[0]);//puntatore all'array dei punti
   
    qp = mxGetPr(prhs[1]);//puntatore all'array dei punti query
  
    ptrtree = mxGetPr(prhs[2]);//puntatore all'albero precedentemente fornito
    double * r= mxGetPr(prhs[3]);//Radius
     
    if( ptrtree == NULL )
    { mexErrMsgTxt("ptrtree must be a valid pointer");}
    

    
    
 
       

    
    
    GLTREE2D *Tree;//dichiaro il puntatore l'oggetto
    
    Tree=(GLTREE2D*)((long)(ptrtree[0]));//ritrasformo il puntatore passato
    
//     mexPrintf("puntatore= %4.4x\n",Tree);
    
    
    //x e y sono i vettori dei reference points passati
    //pk è un array [2x1] con x e y del query point
    //idc double è l'id del più vicino, sarebbe un integer ma per ridare il puntatore a double
    
    
    //Run all the queries
   int nr;

     //  mexPrintf("Copy data structure\n");
    Coord2D* pstruct=(Coord2D*) p; 
   Coord2D* pk=(Coord2D*) qp; 
   
    
    
    //mexPrintf("Function Call\n");
    
   Tree->SearchRadius(pstruct,pk,*r,&nr);
  
     // mexPrintf("Function exit\n");
      
     plhs[0] = mxCreateDoubleMatrix(nr, 1,mxREAL);//costruisce l'output array
    idcdouble = mxGetPr(plhs[0]);//appicicaci il puntatore 
    
    for (i=0;i<nr;i++)//copy the results in the output array
    {
        idcdouble[i]=Tree->idStore[i]+1;
     }
}




