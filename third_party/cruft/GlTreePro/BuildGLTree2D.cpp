#include "mex.h"
#include "GLTree2D.cpp"
/* the gateway function */
//la chiamata deve essere ptr=BuildGLtree(p)

//p must be 3xN

void mexFunction( int nlhs, mxArray *plhs[1],
                  int nrhs, const mxArray *prhs[1])
{
 
 //dichiarazioni variabili   
 double *p;

 int N,i;
 int out;
 GLTREE2D* ptr;
 
  
 
  if(nrhs!=1) 
    mexErrMsgTxt("One Input required.");

  
    if( !mxIsDouble(prhs[0]))
 { mexErrMsgTxt("Input must be double arrays ");
         } 


    
    //Check whetehr points are 2D
       N=mxGetM(prhs[0]);//dimensione dei punti

      if(N!=2) 
    mexErrMsgTxt("Only 2D input supported");
     
    //How many points 
     N=mxGetN(prhs[0]);//dimensione dell'array
    

      
       p = mxGetPr(prhs[0]);//puntatore all'array dei punti
    
      Coord2D* pstruct=(Coord2D*) p;//CHange data type 
       
    
       
     ptr=new GLTREE2D();//chiamata al costruttore
     out=ptr->BuildTree(pstruct,N);
//       ptr=&Tree;//creo il puntatore all'albero
     // mexPrintf("puntatore= %4.4x\n",ptr);//stampa il puntatore
      
        
        
     //return the program a pointer to the created tree
     plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);//crea il puntatore all'output
     double* ptrtree = mxGetPr(plhs[0]);//rendi double* GLTREE* 
     ptrtree[0]=(long) ptr;//copia il puntatore 
     
     
     
     //trying to remake it a tree pointer
     // verifico se la conversione riporta al puntatore originario
     //ptr=(GLTREE*)(long(ptrtree[0]));
    // mexPrintf("puntatore= %4.4x\n",ptr);
  
     
     
}




        
