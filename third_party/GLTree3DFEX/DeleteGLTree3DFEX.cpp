#include "mex.h"
#include "GLtree3DFEX.cpp"
/* the gateway function */
//la chiamata deve essere DeleteGLtree(Tree)

void mexFunction( int nlhs,const mxArray *plhs[], 
        int nrhs, const mxArray *prhs[1]) {
    
    
    //dichiarazione variabili
    GLTREE* Tree;
    double *ptrtree;
    
    
    
     if(nrhs!=1){ mexErrMsgTxt("Only one input supported.");}
    
    
    
    
    ptrtree = mxGetPr(prhs[0]);//puntatore all'albero precedentemente fornito
    
    
    Tree=(GLTREE*)((long)(ptrtree[0]));//ritrasformo il puntatore passato
    
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





