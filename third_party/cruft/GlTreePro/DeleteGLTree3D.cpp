#include "mex.h"
#include "GLTree3D.cpp"
/* the gateway function */
//la chiamata deve essere DeleteGLtree(Tree)

//void mexFunction( int nlhs,const mxArray *plhs[0], 
//        int nrhs, const mxArray *prhs[1]) 
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )

{
    
    
    //dichiarazione variabili
    GLTREE3D* Tree;
    double *ptrtree;
    
    
    
     if(nrhs!=1){ mexErrMsgTxt("Only one input supported.");}
    
    
    
    
    ptrtree = mxGetPr(prhs[0]);//puntatore all'albero precedentemente fornito
    
    
    Tree=(GLTREE3D*)((long)(ptrtree[0]));//ritrasformo il puntatore passato
    
    //controllo se il puntatore � valido, purtroppo questo controllo non funziona
    if(Tree==NULL)
    { mexErrMsgTxt("Invalid tree pointer");
    }
    
    
    //chiamo il distruttore
    
     delete Tree;
//    Tree.~GLTREE();
    
   
   
    
    
    
    
    
    //trying to remake it a tree pointer
    // verifico se la conversione riporta al puntatore originario
    //ptr=(GLTREE*)(long(ptrtree[0]));
    // mexPrintf("puntatore= %4.4x\n",ptr);
    
    
    
}





