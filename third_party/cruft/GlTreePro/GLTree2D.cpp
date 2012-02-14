


#ifndef __GLTree2D_h__
#include "GLTree2D.h"
#endif




//Some macros
#define CurrentDistance (dist=(p[idp].x-pk->x)*(p[idp].x-pk->x)+(p[idp].y-pk->y)*(p[idp].y-pk->y))\


//Perform the search in the current Leaf
#define BoxSearch  id=ny*(idxi+ii)+idyi+jj;\
idp=First[id];\
        while(idp>=0)\
        {   if (CurrentDistance<sqrdist)\
            {*idc=idp;\
                     sqrdist=dist;\
                     *mindist=sqrt(sqrdist);\
            }\
                    idp=Next[idp];\
        }
        
        
#define BoxSearchK id=ny*(idxi+ii)+idyi+jj;\
idp=First[id];\
        while(idp>=0)\
        {if (CurrentDistance<sqrdist)\
         {\
                  dist=sqrt(dist); \
                  count=0; \
                          for (n=1;n<k;n++)\
                          {\
                                   if (dist<=distances[n])\
                                   {count++;}\
                                   else\
                                   {break;}\
                          }\
                                  for (n=0;n<count;n++)\
                                  {\
                                           idc[n]=idc[n+1];\
                                           distances[n]=distances[n+1];\
                                  }\
                                          idc[count]=idp;\
                                          distances[count]=dist;\
                                                  mindist=distances[0];\
                                                  sqrdist=mindist*mindist;\
         }\
                 idp=Next[idp];\
        }
        //   mexPrintf("\n", idp);\
        
        
        
//Perform the search in the current BOx exluding the point sp
#define BoxSearchExclusive  id=ny*(idxi+ii)+idyi+jj;\
idp=First[id];\
        while(idp>=0)\
        {   if (  idp!=sp  && CurrentDistance<sqrdist)\
            {*idc=idp;\
                     sqrdist=dist;\
                     *mindist=sqrt(sqrdist);\
            }\
                    idp=Next[idp];\
        }
        
#define BoxSearchKExclusive  id=ny*(idxi+ii)+idyi+jj;\
idp=First[id];\
        while(idp>=0)\
        {if (idp!=sp && CurrentDistance<sqrdist)\
         {\
                  dist=sqrt(dist); \
                  count=0; \
                          for (n=1;n<k;n++)\
                          {\
                                   if ( dist<=distances[n])\
                                   {count++;}\
                                   else\
                                   {break;}\
                          }\
                                  for (n=0;n<count;n++)\
                                  {\
                                           idc[n]=idc[n+1];\
                                           distances[n]=distances[n+1];\
                                  }\
                                          idc[count]=idp;\
                                          distances[count]=dist;\
                                                  mindist=distances[0];\
                                                  sqrdist=mindist*mindist;\
         }\
                 idp=Next[idp];\
        }
        
        
#define BoxSearchCuboid  id=ny*ii+jj;\
idp=First[id];\
        while(idp>=0)\
        {   if (p[idp].x>=Cuboid[0] && p[idp].x<=Cuboid[1] && p[idp].y>=Cuboid[2] && p[idp].y<=Cuboid[3] )\
            {\
                     idStore[c]=idp;c++;  \
            }\
                    idp=Next[idp];\
        }
        
        
//Constructor
        GLTREE2D::GLTREE2D()//constructor
        {
            //just set default values
            Np=0;//0 maximum number of points
            Minx=0;
            Miny=0;
            step=0;//Sistema di riferimento
            nx=0;ny=0;
            density=1;//default value
            Empty=1;
        }
        
        
        int GLTREE2D::BuildTree(Coord2D*p,  int Np) {
            //function to build the tree with data set in the tree data
            
//            Returns an integer:
//                0:ok
//               -1:not enough memory
//               -2:not enough parameters
            
            
            int i;//counter
            int idxi, idyi;
            double V;
            double Maxx=-HUGE_VAL;
            double Maxy=-HUGE_VAL;
            int id;
            
            
            
            
            
            
            
            
            
            Minx=HUGE_VAL;
            Miny=HUGE_VAL;
            //Determinazione valori max e min
            for (i=0;i<Np;i++) {
                if (p[i].x<Minx)
                {Minx=p[i].x;}
                
                if (p[i].x>Maxx)
                {Maxx=p[i].x;}
                
                if (p[i].y<Miny)
                {Miny=p[i].y;}
                
                if (p[i].y>Maxy)
                {Maxy=p[i].y;}
                
                
                
            }
            
            
            //We have to know whether the user has selected to choose density or step settings
            
            if (density<0 && step>=0) {//We to compute the data iwhtou density
                //numero di boxes in ogni direzione
                nx=(Maxx-Minx)/step+1;
                ny=(Maxy-Miny)/step+1;
                
            }
            else if (density>=0)// we have to compute the number of boxes according to the density
            {
                Nb=(int)((Np/density)+.5);//numero stimato di boxes in base alla densità
                V=(Maxx-Minx)*(Maxy-Miny);//Volume (in 2D è un area)
                step=sqrt(V/Nb);//size of leaf
                
                //numero di boxes in ogni direzione
                nx=(Maxx-Minx)/step+1;
                ny=(Maxy-Miny)/step+1;
                
                
            }
            else {
                return -2;//wrong parameters settings
            }
//Step computation for tollerance
            
            Nb=nx*ny;//real number of boxes
            
            
            
            
            //allocate memory
            First=new int[Nb];//contains the pointers to leaves
            if (First==NULL){return -1;}//memory flag error
            for(i=0;i<Nb;i++){First[i]=-1;}//Get negative values for First
            
            
            
            Next=new int[Np]; if (Next==NULL){return -1;}//memory flag error
            for(i=0;i<Np;i++) {Next[i]=-1;}
            
            
            //store fo search radius
            idStore=new int[Np]; if (idStore==NULL){return -1;}//memory flag error
            
            
            //mexPrintf("Nb= %4.4d\n",Nb);
            
            
            //loop to allocate points in the GLTree Data structure
            for (i=0;i<Np;i++) {
                
                idxi=(p[i].x-Minx)/step;
                idyi=(p[i].y-Miny)/step;
                
                //id=ny*(idx-1)+(ny*nx)*(idz-1)+idy;Matlab
                id=ny*idxi+idyi;
                
                idxi=First[id];//store the previous value (in a temporary idxi)
                First[id]=i;// insert the point
                Next[i]=idxi;// and pop the previous value
                
                
            }
            
            //counting the number of empty boxes
            
            
            return 0;//every thing is all rigth
        }
        
        
        
        
        
        GLTREE2D::~GLTREE2D()//destructor
        {
            //deallocate memory
            delete [] First;
            delete [] Next;
            delete [] idStore;
            
            
        }
        
        
        
        
        
///////////////////////////////////////////////////////////////////////
//             SearchClosest
/////////////////////////////////////////////////////////////////////
        
        void  GLTREE2D::SearchClosest(Coord2D *p, Coord2D *pk, int* idc, double* mindist) {/// Find the closest point using built Leaves
            //p reference point
            //qp query point
            // idc id closest
            // mindist the distance from the closest
            
            
            
            
            int   c;
            
            //volume iterators
            int ic1=0;
            int  ic2=0;
            int  jc1=0;
            int  jc2=0;
            
            
            //integer pointers
            int  id;
            int  idp;
            
            //coordinates
            int idxi, idyi;
            
            bool goon;
            double sqrdist=HUGE_VAL;
            double	dyu, dxd, dyd, dxu;
            double dist;
            
            int ii=0;
            int jj=0;
            
            
            
            
            *mindist=HUGE_VAL;
            
            
            
//Get x coordinate
            idxi=(pk->x-Minx)/step;
            if (idxi<0) {
                idxi=0;
                dxd=Minx-pk->x;
                dxu=dxd+step;
            }
            
            
            else if  (idxi>nx-1) {
                idxi=nx-1;
                dxd=pk->x-(Minx+idxi*step);
                dxu=dxd-step;
            }
            else {
                dxd=pk->x-(Minx+idxi*step);
                dxu=Minx+(idxi+1)*step-pk->x;
            }
            
            
//Get ycoordinate
            idyi=(pk->y-Miny)/step;
            if (idyi<0) {
                idyi=0;
                dyd=Miny-pk->y;
                dyu=dyd+step;//distance up y
                
            }
            
            else if  (idyi>ny-1) {
                idyi=ny-1;
                dyd=pk->y-(Miny+idyi*step);//distance up y
                dyu=dyd-step;
            }
            else{
                dyu=Miny+(idyi+1)*step-pk->y;//distance up y
                dyd=pk->y-(Miny+idyi*step);
            }
            
            
            
            
            //Search the first leaf
            BoxSearch
                    
                    
                    
                    c=1;
            do
            {     goon=false;
                  
                  //xdown
                  if  (dxd<*mindist && idxi-c>-1)
                  {goon=true;
                   ic1=-c;
                   ii=-c;
                   for (jj=jc1;jj<=jc2;jj++)
                       
                       
                   { //leaf search
                       BoxSearch
                               
                               
                   }
                   dxd=dxd+step;
                  }
                  
                  //xup
                  if  (dxu<*mindist && idxi+c<nx)
                  { goon=true;
                    ic2=c;
                    ii=c;
                    for (jj=jc1;jj<=jc2;jj++)
                        
                        
                    { //leaf search
                        BoxSearch
                                
                                
                    }
                    dxu=dxu+step;
                  }
                  
                  //yup
                  if  (dyu<*mindist && idyi+c<ny)
                  {goon=true;
                   jc2=c;
                   
                   jj=c;
                   for (ii=ic1;ii<=ic2;ii++)
                       
                       
                   { //leaf search
                       
                       BoxSearch
                               
                   }
                   
                   dyu=dyu+step;
                  }
                  
                  //ydown
                  if  (dyd<*mindist && idyi-c>-1)
                  {goon=true;
                   jc1=-c;
                   
                   jj=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                       
                       
                   { //leaf search
                       BoxSearch
                               
                               
                   }
                   
                   dyd=dyd+step;
                  }
                  
                  
                  
                  
                  
                  
                  
                  
                  c=c+1;
            }
            while (goon);
            
            
            
            
            return ;
            
            
        }
        
        
        
        
        
        
///////////////////////////////////////////////////////////////////////
//              SearchKClosest
/////////////////////////////////////////////////////////////////////
        void  GLTREE2D::SearchKClosest(Coord2D *p, Coord2D *pk, int* idc, double* distances, int k) {/// Find the closest point using built Leaves
            //p reference point
            //qp query point
            // idc id closest
            // mindist the distance from the closest
            
            
            
            
            int   c;
            
            //volume iterators
            int ic1=0;
            int  ic2=0;
            int  jc1=0;
            int  jc2=0;
            
            
            //integer pointers
            int  id, n, count;
            int  idp;
            
            //coordinates
            int idxi, idyi;
            
            bool goon;
            double sqrdist=HUGE_VAL;
            double mindist=HUGE_VAL;
            double	dyu, dxd, dyd, dxu;
            double dist;
            
            int ii=0;
            int jj=0;
            
            
            
            
            //Set huge the distances value
            for(n=0;n<k;n++) {
                distances[n]=HUGE_VAL;
            }
            
            
            
            
            
//Get x coordinate
            idxi=(pk->x-Minx)/step;
            if (idxi<0) {
                idxi=0;
                dxd=Minx-pk->x;
                dxu=dxd+step;
            }
            
            
            else if  (idxi>nx-1) {
                idxi=nx-1;
                dxd=pk->x-(Minx+idxi*step);
                dxu=dxd-step;
            }
            else {
                dxd=pk->x-(Minx+idxi*step);
                dxu=Minx+(idxi+1)*step-pk->x;
            }
            
            
//Get ycoordinate
            idyi=(pk->y-Miny)/step;
            if (idyi<0) {
                idyi=0;
                dyd=Miny-pk->y;
                dyu=dyd+step;//distance up y
                
            }
            
            else if  (idyi>ny-1) {
                idyi=ny-1;
                dyd=pk->y-(Miny+idyi*step);//distance up y
                dyu=dyd-step;
            }
            else{
                dyu=Miny+(idyi+1)*step-pk->y;//distance up y
                dyd=pk->y-(Miny+idyi*step);
            }
            
            
            
            
//             mexPrintf("Prima della prima foglia");
            
            //Search the first leaf
//             mexPrintf("Inside fuction\n");
            BoxSearchK
                    
//              mexPrintf("Dopo la prima foglia");
                    
                    c=1;
            do
            {     goon=false;
                  
                  //xdown
                  if  (dxd<mindist && idxi-c>-1)
                  {goon=true;
                   ic1=-c;
                   ii=-c;
                   for (jj=jc1;jj<=jc2;jj++)
                       
                       
                   { //leaf search
                       BoxSearchK
                               
                   }
                   
                   dxd=dxd+step;
                  }
                  
                  //xup
                  if  (dxu<mindist && idxi+c<nx)
                  { goon=true;
                    ic2=c;
                    ii=c;
                    for (jj=jc1;jj<=jc2;jj++)
                        
                        
                    { //leaf search
                        BoxSearchK
                                
                    }
                    
                    dxu=dxu+step;
                  }
                  
                  //yup
                  if  (dyu<mindist && idyi+c<ny)
                  {goon=true;
                   jc2=c;
                   
                   jj=c;
                   for (ii=ic1;ii<=ic2;ii++)
                       
                       
                   { //leaf search
                       
                       BoxSearchK
                               
                   }
                   
                   dyu=dyu+step;
                  }
                  
                  //ydown
                  if  (dyd<mindist && idyi-c>-1)
                  {goon=true;
                   jc1=-c;
                   
                   jj=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                       
                       
                   { //leaf search
                       BoxSearchK
                               
                               
                   }
                   
                   dyd=dyd+step;
                  }
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  c=c+1;
            }
            while (goon);
            
            
            
            
            return ;
            
            
        }
        
        
        
        
        
///////////////////////////////////////////////////////////////////////
//              SearchRadius
/////////////////////////////////////////////////////////////////////
        
        
        void  GLTREE2D::SearchRadius(Coord2D* p, Coord2D* pk, double r, int* c)
        
        {/// Finds points inside a given radius using built Leaves
            
            //p reference points
            //pk query point
            // radius
            // number of returned points
            
            
            int ic1;
            int ic2;
            int  jc1;
            int  jc2;
            
            
            int  id;
            int  idp;
            int idxi, idyi;
            double sqrdist=r*r;
            
            
            
            double dist;
            
            //checking point coordinates
            // idxi=(pk->x-Minx+Toll)/step;
            //idyi=(pk->y-Miny+Toll)/step;
            // idzi=(pk->z-Minz+Toll)/step;
            
            //check range for leaves search
            ic1=(pk->x-r-Minx)/step;//plus one so we are sure to check all leaves
            ic2=(pk->x+r-Minx)/step;
            
            jc1=(pk->y-r-Miny)/step;//plus one so we are sure to check all leaves
            jc2=(pk->y+r-Miny)/step;
            
            
            
            //Get idxi idyi inside the bbox
            if (ic1<0) {
                ic1=0;
            }
            else if(ic1>nx-1)
            {ic1=nx-1;}
            
            
            if  (ic2>nx-1) {
                ic2=nx-1;
            }
            else if (ic2<0)
            {ic2=0;}
            
            
            if (jc1<0) {
                jc1=0;
            }
            else if (jc1>ny-1)
            {jc1=ny-1;}
            
            
            if  (jc2>ny-1) {
                jc2=ny-1;
            }
            else if (jc2<0)
            {jc2=0;}
            
            
            
            
            
            *c=0;//counter numbers of points found
            
            //Volume Search
            
            for (idxi=ic1;idxi<=ic2;idxi++) {
                for(idyi=jc1;idyi<=jc2;idyi++) {
                    
                    id=ny*idxi+idyi;
                    
                    //search in the volume
                    idp=First[id];
                    while(idp>=0) {
                        if (CurrentDistance<sqrdist) {
                            idStore[*c]=idp;
                            *c=*c+1;;//attenzione a non usare *c++
                        }
                        idp=Next[idp];
                    }
                    
                }
            }
            
            
        }
        
        
        
        void GLTREE2D::RemovePoint(Coord2D* p, int idp) {
            //remove the point idp from the tree
            int i;
            int idxi, idyi, idb;
            
            //Get points coordinates
            idxi=(p[idp].x-Minx)/step;
            idyi=(p[idp].y-Miny)/step;
            
            
            //get the box id
            idb=ny*idxi+idyi;
            
            //look trouh all points in the box
            
            //first point se trovato aggiorniamo FIrst
            i=First[idb]; if (i==idp){First[idb]=Next[i]; return;}//punto rimosso
            
            
            while (i>0) {
                
                if (Next[i]==idp) {
                    Next[i]=Next[idp];//crea il salto del punto idp
                    return;
                }//punto rimosso
                
                i=Next[i];//go to next point
                
            }
            
            
        }
        
        
        
        void GLTREE2D::SearchClosestExclusive(Coord2D *p, Coord2D *pk, int* idc, double* mindist, int sp) {/// Find the closest point using built Leaves the point id must be different from sp
            //p reference point
            //qp query point
            // idc id closest
            // mindist the distance from the closest
            
            
            
            
            int   c;
            
            //volume iterators
            int ic1=0;
            int  ic2=0;
            int  jc1=0;
            int  jc2=0;
            
            
            //integer pointers
            int  id;
            int  idp;
            
            //coordinates
            int idxi, idyi;
            
            bool goon;
            double sqrdist=HUGE_VAL;
            double	dyu, dxd, dyd, dxu;
            double dist;
            
            int ii=0;
            int jj=0;
            
            
            
            
            *mindist=HUGE_VAL;
            
            
            
//Get x coordinate
            idxi=(pk->x-Minx)/step;
            if (idxi<0) {
                idxi=0;
                dxd=Minx-pk->x;
                dxu=dxd+step;
            }
            
            
            else if  (idxi>nx-1) {
                idxi=nx-1;
                dxd=pk->x-(Minx+idxi*step);
                dxu=dxd-step;
            }
            else {
                dxd=pk->x-(Minx+idxi*step);
                dxu=Minx+(idxi+1)*step-pk->x;
            }
            
            
//Get ycoordinate
            idyi=(pk->y-Miny)/step;
            if (idyi<0) {
                idyi=0;
                dyd=Miny-pk->y;
                dyu=dyd+step;//distance up y
                
            }
            
            else if  (idyi>ny-1) {
                idyi=ny-1;
                dyd=pk->y-(Miny+idyi*step);//distance up y
                dyu=dyd-step;
            }
            else{
                dyu=Miny+(idyi+1)*step-pk->y;//distance up y
                dyd=pk->y-(Miny+idyi*step);
            }
            
            
            
            
            
            //Search the first leaf
            BoxSearchExclusive
                    
                    
                    
                    c=1;
            do
            {     goon=false;
                  
                  //xdown
                  if  (dxd<*mindist && idxi-c>-1)
                  {goon=true;
                   ic1=-c;
                   ii=-c;
                   for (jj=jc1;jj<=jc2;jj++)
                       
                       
                   { //leaf search
                       BoxSearchExclusive
                               
                   }
                   
                   dxd=dxd+step;
                  }
                  
                  //xup
                  if  (dxu<*mindist && idxi+c<nx)
                  { goon=true;
                    ic2=c;
                    ii=c;
                    for (jj=jc1;jj<=jc2;jj++)
                        
                        
                    { //leaf search
                        BoxSearchExclusive
                                
                    }
                    
                    dxu=dxu+step;
                  }
                  
                  //yup
                  if  (dyu<*mindist && idyi+c<ny)
                  {goon=true;
                   jc2=c;
                   
                   jj=c;
                   for (ii=ic1;ii<=ic2;ii++)
                       
                       
                   { //leaf search
                       
                       BoxSearchExclusive
                               
                   }
                   
                   dyu=dyu+step;
                  }
                  
                  //ydown
                  if  (dyd<*mindist && idyi-c>-1)
                  {goon=true;
                   jc1=-c;
                   
                   jj=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                       
                       
                   { //leaf search
                       BoxSearchExclusive
                               
                               
                   }
                   
                   dyd=dyd+step;
                  }
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  c=c+1;
            }
            while (goon);
            
            
            
            
            return ;
            
            
        }
        
        
        
        int GLTREE2D::Dtest(Coord2D* p, Coord2D* pk, double sqrdist)
        
        {/// Verifica che non ci siano punti nel raggio al quadrato definito da sqrdist
            
            //p reference points
            //pk query point
            // sqrdist=radius for the search
            
            //La funzione ritorna -1 se il testo ha successo, altrimenti ritorna l'id del punto che viola il test.
            
            
            
            int ic1;
            int ic2;
            int  jc1;
            int  jc2;
            
            
            int  id;
            int  idp;
            int idxi, idyi;
            double r=sqrt(sqrdist);
            
            double dist;
            int test=-1;
            
            //checking point coordinates
            //idxi=(pk->x-Minx+Toll)/PX;
            //idyi=(pk->y-Miny+Toll)/PY;
            //idzi=(pk->z-Minz+Toll)/PZ;
            
            //check range for leaves search
            ic1=(pk->x-r-Minx)/step;//plus one so we are sure to check all leaves
            ic2=(pk->x+r-Minx)/step;
            
            jc1=(pk->y-r-Miny)/step;//plus one so we are sure to check all leaves
            jc2=(pk->y+r-Miny)/step;
            
            
            //Get idxi idyi inside the bbox
            if (ic1<0) {
                ic1=0;
            }
            else if(ic1>nx-1)
            {ic1=nx-1;}
            
            
            if  (ic2>nx-1) {
                ic2=nx-1;
            }
            else if (ic2<0)
            {ic2=0;}
            
            
            if (jc1<0) {
                jc1=0;
            }
            else if (jc1>ny-1)
            {jc1=ny-1;}
            
            
            if  (jc2>ny-1) {
                jc2=ny-1;
            }
            else if (jc2<0)
            {jc2=0;}
            
            
            
            
            
            
            
            //Volume Search
            
            for (idxi=ic1;idxi<=ic2;idxi++) {
                for(idyi=jc1;idyi<=jc2;idyi++) {
                    
                    id=ny*idxi+idyi;
                    
                    //search in the vlume
                    idp=First[id];
                    while (idp>=0) {
                        if (CurrentDistance<=sqrdist) {
                            return test=idp;
                        }
                        idp=Next[idp];
                        
                    }
                    
                }
            }
            
            return test;
        }
        
        
        
///////////////////////////////////////////////////////////////////////
//              SearchKClosestExclusive
/////////////////////////////////////////////////////////////////////
        void  GLTREE2D::SearchKClosestExclusive(Coord2D *p, Coord2D *pk, int* idc, double* distances, int k, int sp) {/// Find the closest point using built Leaves
            //p reference point
            //qp query point
            // idc id closest
            // mindist the distance from the closest
            
            
            
            
            int   c;
            
            //volume iterators
            int ic1=0;
            int  ic2=0;
            int  jc1=0;
            int  jc2=0;
            
            //integer pointers
            int  id, n, count;
            int  idp;
            
            //coordinates
            int idxi, idyi;
            
            bool goon;
            double sqrdist=HUGE_VAL;
            double mindist=HUGE_VAL;
            double	dyu, dxd, dyd, dxu;
            double dist;
            
            int ii=0;
            int jj=0;
            
            
            
            
            //Set huge the distances value
            for(n=0;n<k;n++) {
                distances[n]=HUGE_VAL;
            }
            
            
            
            
            
//Get x coordinate
            idxi=(pk->x-Minx)/step;
            if (idxi<0) {
                idxi=0;
                dxd=Minx-pk->x;
                dxu=dxd+step;
            }
            
            
            else if  (idxi>nx-1) {
                idxi=nx-1;
                dxd=pk->x-(Minx+idxi*step);
                dxu=dxd-step;
            }
            else {
                dxd=pk->x-(Minx+idxi*step);
                dxu=Minx+(idxi+1)*step-pk->x;
            }
            
            
//Get ycoordinate
            idyi=(pk->y-Miny)/step;
            if (idyi<0) {
                idyi=0;
                dyd=Miny-pk->y;
                dyu=dyd+step;//distance up y
                
            }
            
            else if  (idyi>ny-1) {
                idyi=ny-1;
                dyd=pk->y-(Miny+idyi*step);//distance up y
                dyu=dyd-step;
            }
            else{
                dyu=Miny+(idyi+1)*step-pk->y;//distance up y
                dyd=pk->y-(Miny+idyi*step);
            }
            
            
            
            
//             mexPrintf("Prima della prima foglia");
            
            //Search the first leaf
//             mexPrintf("Inside fuction\n");
            BoxSearchKExclusive
                    
//              mexPrintf("Dopo la prima foglia");
                    
                    c=1;
            do
            {     goon=false;
                  
                  //xdown
                  if  (dxd<mindist && idxi-c>-1)
                  {goon=true;
                   ic1=-c;
                   ii=-c;
                   for (jj=jc1;jj<=jc2;jj++)
                       
                       
                   { //leaf search
                       BoxSearchKExclusive
                               
                   }
                   
                   dxd=dxd+step;
                  }
                  
                  //xup
                  if  (dxu<mindist && idxi+c<nx)
                  { goon=true;
                    ic2=c;
                    ii=c;
                    for (jj=jc1;jj<=jc2;jj++)
                        
                        
                    { //leaf search
                        BoxSearchKExclusive
                                
                    }
                    
                    dxu=dxu+step;
                  }
                  
                  //yup
                  if  (dyu<mindist && idyi+c<ny)
                  {goon=true;
                   jc2=c;
                   
                   jj=c;
                   for (ii=ic1;ii<=ic2;ii++)
                       
                       
                   { //leaf search
                       
                       BoxSearchKExclusive
                               
                   }
                   
                   dyu=dyu+step;
                  }
                  
                  //ydown
                  if  (dyd<mindist && idyi-c>-1)
                  {goon=true;
                   jc1=-c;
                   
                   jj=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                       
                       
                   { //leaf search
                       BoxSearchKExclusive
                               
                               
                   }
                   
                   dyd=dyd+step;
                  }
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  c=c+1;
            }
            while (goon);
            
            
            
            
            return ;
            
            
        }
        
        
        
        void GLTREE2D::SearchCuboid(Coord2D *p, double* Cuboid, int* npts) {
            /// FInds points inside the cuboid defined by Cuboid=[xmin,xmax,ymin,ymax...]
            
            
            
            
            
            //volume iterators
            int ic1=0;
            int  ic2=0;
            int  jc1=0;
            int  jc2=0;
            
            
            //integer pointers
            int  id;
            int  idp;
            
            
            
            
            
            
            
            int ii=0;
            int jj=0;
            
            
            
            
            
            
            int   c;
            
            
//Get xmin coordinate
            ic1=(Cuboid[0]-Minx)/step;
            if (ic1<0) {
                ic1=0;
            }
            else if  ( ic1>nx-1) {
                ic1=nx-1;
            }
            
//Get xmax coordinate
            //   mexPrintf("Cuboid[1]\n");
            ic2=(Cuboid[1]-Minx)/step;
            if (ic2<0) {
                ic2=0;
            }
            else if  ( ic2>nx-1) {
                ic2=nx-1;
            }
            
            //Get ymin coordinate
            //     mexPrintf("Cuboid[2]\n");
            jc1=(Cuboid[2]-Miny)/step;
            if (jc1<0) {
                jc1=0;
            }
            else if  ( jc1>ny-1) {
                jc1=ny-1;
            }
            
//Get ymax coordinate
            jc2=(Cuboid[3]-Miny)/step;
            if (jc2<0) {
                jc2=0;
            }
            else if  ( jc2>ny-1) {
                jc2=ny-1;
            }
            
            
            
            
//include without test points inside the cuboid
            
            //Volume Search
            
            //   mexPrintf("Volume Search\n");
            
            c=0;
            for (ii=ic1+1;ii<ic2;ii++) {
                for(jj=jc1+1;jj<jc2;jj++) {
                    
                    id=ny*ii+jj;
                    
                    //search in the vlume
                    idp=First[id];
                    while (idp>=0) {
                        idStore[c]=idp;c++;
                        idp=Next[idp];
                        
                    }
                    
                }
            }
            
            
            //   Search Trough the boundary of the cuboid
            
            //xdown
            //   mexPrintf("xdown\n");
            ii=ic1;
            for (jj=jc1;jj<=jc2;jj++)
                
                
            { //leaf search
                BoxSearchCuboid
                        
            }
            
            
            
            
            //xup
            //    mexPrintf("xup\n");
            ii=ic2;
            for (jj=jc1;jj<=jc2;jj++)
                
                
            { //leaf search
                BoxSearchCuboid
                        
            }
            
            
            //ydown
            //   mexPrintf("ydown\n");
            jj=jc1;
            for (ii=ic1+1;ii<ic2;ii++)
                
                
            { //leaf search
                BoxSearchCuboid
                        
            }
            
            
            
            
            //yup
            //    mexPrintf("yup\n");
            jj=jc2;
            for (ii=ic1+1;ii<ic2;ii++)
                
                
            { //leaf search
                BoxSearchCuboid
                        
            }
            
            
            
            
            
            //  mexPrintf("FInito\n");
            
            
            *npts=c;//set the number of found points
            
            return ;
        }


		///////////////////////////////////////////////////////////////////////
//              SearchRadius
/////////////////////////////////////////////////////////////////////
        
        
        void  GLTREE2D::SearchRadiusExclusive(Coord2D* p, Coord2D* pk, double r, int* c,int sp)
        
        {/// Finds points inside a given radius using built Leaves
            
            //p reference points
            //pk query point
            // radius
            // number of returned points
            
            
            int ic1;
            int ic2;
            int  jc1;
            int  jc2;
            
            
            int  id;
            int  idp;
            int idxi, idyi;
            double sqrdist=r*r;
            
            
            
            double dist;
            
            //checking point coordinates
            // idxi=(pk->x-Minx+Toll)/step;
            //idyi=(pk->y-Miny+Toll)/step;
            // idzi=(pk->z-Minz+Toll)/step;
            
            //check range for leaves search
            ic1=(pk->x-r-Minx)/step;//plus one so we are sure to check all leaves
            ic2=(pk->x+r-Minx)/step;
            
            jc1=(pk->y-r-Miny)/step;//plus one so we are sure to check all leaves
            jc2=(pk->y+r-Miny)/step;
            
            
            
            //Get idxi idyi inside the bbox
            if (ic1<0) {
                ic1=0;
            }
            else if(ic1>nx-1)
            {ic1=nx-1;}
            
            
            if  (ic2>nx-1) {
                ic2=nx-1;
            }
            else if (ic2<0)
            {ic2=0;}
            
            
            if (jc1<0) {
                jc1=0;
            }
            else if (jc1>ny-1)
            {jc1=ny-1;}
            
            
            if  (jc2>ny-1) {
                jc2=ny-1;
            }
            else if (jc2<0)
            {jc2=0;}
            
            
            
            
            
            *c=0;//counter numbers of points found
            
            //Volume Search
            
            for (idxi=ic1;idxi<=ic2;idxi++) {
                for(idyi=jc1;idyi<=jc2;idyi++) {
                    
                    id=ny*idxi+idyi;
                    
                    //search in the volume
                    idp=First[id];
                    while(idp>=0) {
                        if (idp!=sp && CurrentDistance<sqrdist) {
                            idStore[*c]=idp;
                            *c=*c+1;;//attenzione a non usare *c++
                        }
                        idp=Next[idp];
                    }
                    
                }
            }
            
            
        }


		