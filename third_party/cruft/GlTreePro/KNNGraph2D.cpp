#include "mex.h"




#include "GLTree2D.cpp"
//#include "FunctionsLib.h"


/* the gateway function */
// In matlab la funzione deve essere
//[NNG,dist]=KNNGraph(p,ptrtree,k)

void mexFunction( int nlhs, mxArray *plhs[2],
int nrhs,  const mxArray *prhs[3])
{
    
    double       *p;

    
    double  *ptrtree;
    double * idcdouble;
    int N,i,j;
    double* outdistances;
    
    
    
    // Errors check
    
    if(nrhs!=3)
        mexErrMsgTxt("3 inputs required.");
    
      if(nlhs>2)
    {  mexErrMsgTxt("Maximum two outputs supported");}
    
    
    
  
   
 N=mxGetM(prhs[0]);

 
//  mexPrintf("N= %4.4f Nq=%4.4f\n",N,Nq);
 if(N!=2)
  { mexErrMsgTxt("Only 2D points supported ");
         } 
  
  if( !mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1]))
 { mexErrMsgTxt("Inputs must be double vectors ");
         } 
    
    
    
    p = mxGetPr(prhs[0]);//puntatore all'array dei punti
   
   
    ptrtree = mxGetPr(prhs[1]);//puntatore all'albero precedentemente fornito
    double *k=mxGetPr(prhs[2]);
    
 
    
    
    
     int kint=*k;//numberof neighbours
     
     N=mxGetN(prhs[0]);//dimensione reference
     
  //   mexPrintf("N= %4.4f Nq=%4.4f\n",N,Nq); 
         if (*k>N)
  {
      mexErrMsgTxt("Can not run search, reference points are less than k");
         }
    
    plhs[0] = mxCreateDoubleMatrix(N, kint,mxREAL);//costruisce l'output array
    idcdouble = mxGetPr(plhs[0]);//appicicaci il puntatore 
    
    
    GLTREE2D *Tree;//dichiaro il puntatore l'oggetto
    
    Tree=(GLTREE2D*)((long)(ptrtree[0]));//ritrasformo il puntatore passato
    
 // mexPrintf("puntatore= %4.4x\n",Tree);
    
    
    int* idc=new int[kint];
    double* distances=new double[kint];
   
    
    //converto la struttura dati
     Coord2D* pstruct=(Coord2D*) p; 

        plhs[1] = mxCreateDoubleMatrix(N, kint,mxREAL);//costruisce l'output array
        outdistances = mxGetPr(plhs[1]);//appicicaci il puntatore
        for (i=0;i<N;i++)
        {
           //  mexPrintf("Prima della ricerca\n");          
            Tree->SearchKClosestExclusive(pstruct,&pstruct[i],idc,distances,kint,i);//lancio la routine per la ricerca del pi� vicino
           // mexPrintf("Dopo la ricerca\n");
            for (j=0;j<kint;j++)
            {
                idcdouble[N*(j)+i]=idc[j]+1;//convert to matlab notation
                outdistances[N*(j)+i]=distances[j];
            }
        }
   
    //Free aloocated memory
    delete [] idc;
    delete [] distances;
    
    
        // mexEvalString("disp('<a href = \"http://www.mathworks.com\">The MathWorks Web Site</a>')"); 


}





