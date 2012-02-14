#include "mex.h"




#include "GLTree3D.cpp"
//#include "FunctionsLib.h"




/* the gateway function */
// In matlab la funzione deve essere
//[cutdist,ndel,idel]=KNNFilter3D(p,ptrtree,'r',r)
//[cutdist,ndel,idel]=KNNFilter3D(p,ptrtree,'f',f)
void mexFunction( int nlhs, mxArray *plhs[3],
        int nrhs,  const mxArray *prhs[4]) {
    
    double       *p;
    
    
    double  *ptrtree;
    int N, i, j,n,idp;
    double meandist=0;
    double* cutdist;
    double* F;
     char*        String;//Input String
    int String_Leng;//length of the input String
    double* Ndel=0;//number of deleted points
    
    // Errors check
    
    if(nrhs!=4)
        mexErrMsgTxt("Four inputs required.");
    
    if(nlhs>3)
    {  mexErrMsgTxt("Maximum two outputs supported");}
    
    N=mxGetM(prhs[0]);
    
//  mexPrintf("N= %4.4f Nq=%4.4f\n",N,Nq);
    if(N!=3)
    { mexErrMsgTxt("Only 3D points supported ");
    }
    
    if( !mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1]) || !mxIsDouble(prhs[3]))
    { mexErrMsgTxt("Inputs number 1,2 and 3 must be doubles ");
    }
    
     String_Leng=mxGetN(prhs[2]);//StringLength
        
        if (String_Leng>1)//Check if string is correct
        {
            mexErrMsgTxt("Input 3 must be only one String.");
        }

        String =mxArrayToString (prhs[2]);//get the string
        
        if(String == NULL)
        {
            mexErrMsgTxt("Could not convert input 3 to string.");
        }
  
        if (String[0]!='r' && String[0]!='f')
             {
            mexErrMsgTxt("Invalid mode, check input number 3");
        }
    
//reading inputs
    p = mxGetPr(prhs[0]);//puntatore all'array dei punti
    ptrtree = mxGetPr(prhs[1]);//puntatore all'albero precedentemente fornito
    
    
    N=mxGetN(prhs[0]);//numero di punti
    
    
  //alloca memoria per i primi due output
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);//costruisce l'output array
    cutdist = mxGetPr(plhs[0]);//output cutdistance
    
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);//costruisce l'output array
    Ndel = mxGetPr(plhs[1]);//output cutdistance         
    
//richiama la struttura dati
    
    GLTREE3D *Tree;//dichiaro il puntatore l'oggetto
    
    Tree=(GLTREE3D*)((long)(ptrtree[0]));//ritrasformo il puntatore passato
    
    //  mexPrintf("puntatore= %4.4x\n",Tree);
    
    
    int* idc=new int[N];
    double* dist=new double[N];
    
    
    //converto la struttura dati
    Coord3D* pstruct=(Coord3D*) p;
    
    
   //    mexPrintf("Prima della ricerca di tutti i punti pi� vicini r/f \n");
    
           
    
  //  mexPrintf("Prima dell'assegnazione parmatro r/f \n");
    
    if (String[0]=='r')
    {cutdist=mxGetPr(prhs[3]);}//user defined a rdius as cutdistance
    else //let's compute the meandistance
    {
        F=mxGetPr(prhs[3]);
        if(*F<=0)
        {
            mexErrMsgTxt("F must be > 0");
        }
       // mexPrintf("F=%4.4f\n",*F);
        //Getting the mean value of the distances
       
        //get the NN for each point
       for(i=0;i<N;i++) {
        Tree->SearchClosestExclusive(&pstruct[0], &pstruct[i], &idc[i], &dist[i], i);
      }
        
        for(i=0;i<N;i++) {
            meandist+=dist[i];
        }
        meandist/=N;//mean distance
        *cutdist=meandist/(*F);// cut distance points closer than cutdist will be discarded
        // mexPrintf("Cutdist=%4.4f\n",*cutdist);
    }
    
   //    mexPrintf("Prima dell'assegnazione degli output\n");
    
   
    
    //remove bad points
    bool* removed=new bool[N];//flag if points has been removed
    for(i=0;i<N;i++){removed[i]=false;}//initialize to false
    
    
    
    
  //  mexPrintf("Prima del filtro\n");
    for(i=0;i<N;i++) {
       if (!removed[i] && dist[i]<=*cutdist)//only if points is not removed and if the points has a NNinside the cutradius
       {
         
      
       Tree->SearchRadiusExclusive(&pstruct[0],&pstruct[i],*cutdist,&n, i);
      
       //delete all n points found in range
          for(j=0;j<n;j++)
          {
           idp=Tree->idStore[j];
           if (!removed[idp])
           {//if not removed remove
              removed[idp]=true;//flag as removed
              Tree->RemovePoint(&pstruct[0],idp);
           }
          } 
           
            
        }
    }
  
   // mexPrintf("Dopo il filtro\n");
    
    if (nlhs>2) //also return the id of the deleted points
    {
        
         //counting the number of deleted points
       for(i=0;i<N;i++) {
           if(removed[i]){*Ndel=*Ndel+1;}
       } 
        
        // mexPrintf("%4.4f\n",*Ndel);
      if(*Ndel>=1)
      {plhs[2] = mxCreateDoubleMatrix(*Ndel, 1, mxREAL);//costruisce l'output array
       double *IdDel= mxGetPr(plhs[2]);//output cutdistance
       j=0;
       for(i=0;i<N;i++) {
    
          // mexPrintf("%4.0d\n",i);
    
           if(removed[i]){IdDel[j]=i+1;j++;}
       }
      }
      else//retun an empty matrix
      {
          plhs[2] = mxCreateDoubleMatrix(0, 0, mxREAL);   
      }
    }
    
    //Free aloocated memory
    delete [] idc;
    delete [] dist;
    delete [] removed;
            
}





