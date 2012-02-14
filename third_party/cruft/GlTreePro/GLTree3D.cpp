


#ifndef __GLTree3D_h__
#include "GLTree3D.h"
#endif





//Some macros
#define CurrentDistance (dist=(p[idp].x-pk->x)*(p[idp].x-pk->x)+(p[idp].y-pk->y)*(p[idp].y-pk->y)+(p[idp].z-pk->z)*(p[idp].z-pk->z))\


//Perform the search in the current Leaf
#define BoxSearch  id=ny*(idxi+ii)+nx*ny*(idzi+kk)+idyi+jj;\
idp=First[id];\
        while(idp>=0)\
        {   if (CurrentDistance<sqrdist)\
            {*idc=idp;\
                     sqrdist=dist;\
                     *mindist=sqrt(sqrdist);\
            }\
                    idp=Next[idp];\
        }
        
        
#define BoxSearchK id=ny*(idxi+ii)+nx*ny*(idzi+kk)+idyi+jj;\
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
#define BoxSearchExclusive  id=ny*(idxi+ii)+nx*ny*(idzi+kk)+idyi+jj;\
idp=First[id];\
        while(idp>=0)\
        {   if (  idp!=sp  && CurrentDistance<sqrdist)\
            {*idc=idp;\
                     sqrdist=dist;\
                     *mindist=sqrt(sqrdist);\
            }\
                    idp=Next[idp];\
        }
        
#define BoxSearchKExclusive id=ny*(idxi+ii)+nx*ny*(idzi+kk)+idyi+jj;\
idp=First[id];\
        while(idp>=0)\
        {if ( idp!=sp && CurrentDistance<sqrdist )\
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
        
   
#define BoxSearchCuboid  id=ny*ii+nx*ny*kk+jj;\
idp=First[id];\
        while(idp>=0)\
        {   if (p[idp].x>=Cuboid[0] && p[idp].x<=Cuboid[1] && p[idp].y>=Cuboid[2] && p[idp].y<=Cuboid[3]  && p[idp].z>=Cuboid[4] && p[idp].z<=Cuboid[5])\
            {\
              idStore[c]=idp;c++;  \
            }\
                    idp=Next[idp];\
        }      
        
        
//Constructor
        GLTREE3D::GLTREE3D()//constructor
        {
            //just set default values
            Np=0;//0 maximum number of points
            Minx=0;
            Miny=0;
            Minz=0;
            step=0;//Sistema di riferimento
            nx=0;ny=0;nz=0;
            density=.5;//default value
            Empty=1;
        }
        
        
        int GLTREE3D::BuildTree(Coord3D*p,  int Np) {
            //function to build the tree with data set in the tree data
            
//            Returns an integer:
//                0:ok
//               -1:not enough memory
//               -2:not enough parameters
            
            
            int i;//counter
            int idxi, idyi, idzi;
            double V;
            double Maxx=-HUGE_VAL;
            double Maxy=-HUGE_VAL;
            double Maxz=-HUGE_VAL;
            int id;
            
            
            
            
            
            
            
            
            
            Minx=HUGE_VAL;
            Miny=HUGE_VAL;
            Minz=HUGE_VAL;
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
                
                
                if (p[i].z<Minz)
                {Minz=p[i].z;}
                
                if (p[i].z>Maxz)
                {Maxz=p[i].z;}
            }
            
            
            //We have to know whether the user has selected to choose density or step settings
            
            if (density<0 && step>=0) {//We to compute the data iwhtou density
                //numero di boxes in ogni direzione
                nx=(Maxx-Minx)/step+1;
                ny=(Maxy-Miny)/step+1;
                nz=(Maxz-Minz)/step+1;
                
            }
            else if (density>=0)// we have to compute the number of boxes according to the density
            {
                Nb=(int)((Np/density)+.5);//numero stimato di boxes in base alla densit�
                V=(Maxx-Minx)*(Maxy-Miny)*(Maxz-Minz);//Volume
                step=pow(V/Nb, .33333333333333333);//size of leaf
                
                //numero di boxes in ogni direzione
                nx=(Maxx-Minx)/step+1;
                ny=(Maxy-Miny)/step+1;
                nz=(Maxz-Minz)/step+1;
                
                
            }
            else {
                return -2;//wrong parameters settings
            }
//Step computation for tollerance
            
            Nb=nx*ny*nz;//real number of boxes
            
            
            
            
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
                idzi=(p[i].z-Minz)/step;
                
                //id=ny*(idx-1)+(ny*nx)*(idz-1)+idy;Matlab
                id=ny*idxi+nx*ny*idzi+idyi;
                
                idxi=First[id];//store the previous value (in a temporary idxi)
                First[id]=i;// insert the point
                Next[i]=idxi;// and pop the previous value
                
                
            }
            
            //counting the number of empty boxes
            
            
            return 0;//every thing is all rigth
        }
        
        
        
        
        
        GLTREE3D::~GLTREE3D()//destructor
        {
            //deallocate memory
            delete [] First;
            delete [] Next;
            delete [] idStore;
            
            
        }
        
        
        
        
        
///////////////////////////////////////////////////////////////////////
//             SearchClosest
/////////////////////////////////////////////////////////////////////
        
        void  GLTREE3D::SearchClosest(Coord3D *p, Coord3D *pk, int* idc, double* mindist) {/// Find the closest point using built Leaves
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
            int kc1=0;
            int kc2=0;
            
            //integer pointers
            int  id;
            int  idp;
            
            //coordinates
            int idxi, idyi, idzi;
            
            bool goon;
            double sqrdist=HUGE_VAL;
            double	dyu, dxd, dyd, dxu, dzu, dzd;
            double dist;
            
            int ii=0;
            int jj=0;
            int kk=0;
            
            
            
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
            
            
//Get z coordinate
            
            idzi=(pk->z-Minz)/step;
            if (idzi<0) {
                idzi=0;
                dzd=Minz-pk->z;
                dzu=dzd+step;//distance up z
                
            }
            
            else if  (idzi>nz-1) {
                idzi=nz-1;
                dzd=pk->z-(Minz+idzi*step);//distance up y
                dzu=dzd-step;
            }
            else{
                dzu=Minz+(idzi+1)*step-pk->z;//distance up y
                dzd=pk->z-(Minz+idzi*step);
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
                   {for (kk=kc1;kk<=kc2;kk++)
                        
                    { //leaf search
                        BoxSearch
                                
                    }
                   }
                   dxd=dxd+step;
                  }
                  
                  //xup
                  if  (dxu<*mindist && idxi+c<nx)
                  { goon=true;
                    ic2=c;
                    ii=c;
                    for (jj=jc1;jj<=jc2;jj++)
                    { for (kk=kc1;kk<=kc2;kk++)
                          
                      { //leaf search
                          BoxSearch
                                  
                      }
                    }
                    dxu=dxu+step;
                  }
                  
                  //yup
                  if  (dyu<*mindist && idyi+c<ny)
                  {goon=true;
                   jc2=c;
                   
                   jj=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         
                         BoxSearch
                                 
                     }
                   }
                   dyu=dyu+step;
                  }
                  
                  //ydown
                  if  (dyd<*mindist && idyi-c>-1)
                  {goon=true;
                   jc1=-c;
                   
                   jj=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         BoxSearch
                                 
                                 
                     }
                   }
                   dyd=dyd+step;
                  }
                  
                  //zdown
                  if  (dzd<*mindist && idzi-c>-1)
                  {goon=true;
                   kc1=-c;
                   
                   kk=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         BoxSearch
                                 
                                 
                     }
                   }
                   dzd=dzd+step;
                  }
                  
                  //zup
                  if  (dzu<*mindist && idzi+c<nz)
                  {goon=true;
                   kc2=c;
                   
                   kk=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         
                         BoxSearch
                                 
                     }
                   }
                   dzu=dzu+step;
                  }
                  
                  
                  
                  
                  
                  
                  
                  c=c+1;
            }
            while (goon);
            
            
            
            
            return ;
            
            
        }
        
        
        
        
        
        
///////////////////////////////////////////////////////////////////////
//              SearchKClosest
/////////////////////////////////////////////////////////////////////
        void  GLTREE3D::SearchKClosest(Coord3D *p, Coord3D *pk, int* idc, double* distances, int k) {/// Find the closest point using built Leaves
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
            int kc1=0;
            int kc2=0;
            
            //integer pointers
            int  id, n, count;
            int  idp;
            
            //coordinates
            int idxi, idyi, idzi;
            
            bool goon;
            double sqrdist=HUGE_VAL;
            double mindist=HUGE_VAL;
            double	dyu, dxd, dyd, dxu, dzu, dzd;
            double dist;
            
            int ii=0;
            int jj=0;
            int kk=0;
            
            
            
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
            
            
//Get z coordinate
            
            idzi=(pk->z-Minz)/step;
            if (idzi<0) {
                idzi=0;
                dzd=Minz-pk->z;
                dzu=dzd+step;//distance up z
                
            }
            
            else if  (idzi>nz-1) {
                idzi=nz-1;
                dzd=pk->z-(Minz+idzi*step);//distance up y
                dzu=dzd-step;
            }
            else{
                dzu=Minz+(idzi+1)*step-pk->z;//distance up y
                dzd=pk->z-(Minz+idzi*step);
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
                   {for (kk=kc1;kk<=kc2;kk++)
                        
                    { //leaf search
                        BoxSearchK
                                
                    }
                   }
                   dxd=dxd+step;
                  }
                  
                  //xup
                  if  (dxu<mindist && idxi+c<nx)
                  { goon=true;
                    ic2=c;
                    ii=c;
                    for (jj=jc1;jj<=jc2;jj++)
                    { for (kk=kc1;kk<=kc2;kk++)
                          
                      { //leaf search
                          BoxSearchK
                                  
                      }
                    }
                    dxu=dxu+step;
                  }
                  
                  //yup
                  if  (dyu<mindist && idyi+c<ny)
                  {goon=true;
                   jc2=c;
                   
                   jj=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         
                         BoxSearchK
                                 
                     }
                   }
                   dyu=dyu+step;
                  }
                  
                  //ydown
                  if  (dyd<mindist && idyi-c>-1)
                  {goon=true;
                   jc1=-c;
                   
                   jj=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         BoxSearchK
                                 
                                 
                     }
                   }
                   dyd=dyd+step;
                  }
                  
                  //zdown
                  if  (dzd<mindist && idzi-c>-1)
                  {goon=true;
                   kc1=-c;
                   
                   kk=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         BoxSearchK
                                 
                                 
                     }
                   }
                   dzd=dzd+step;
                  }
                  
                  //zup
                  if  (dzu<mindist && idzi+c<nz)
                  {goon=true;
                   kc2=c;
                   
                   kk=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         
                         BoxSearchK
                                 
                     }
                   }
                   dzu=dzu+step;
                  }
                  
                  
                  
                  
                  
                  
                  
                  c=c+1;
            }
            while (goon);
            
            
            
            
            return ;
            
            
        }
        
        
        
        
        
///////////////////////////////////////////////////////////////////////
//              SearchRadius
/////////////////////////////////////////////////////////////////////
        
        
        void  GLTREE3D::SearchRadius(Coord3D* p, Coord3D* pk, double r, int* c)
        
        {/// Finds points inside a given radius using built Leaves
            
            //p reference points
            //pk query point
            // radius
            // number of returned points
            
            
            int ic1;
            int ic2;
            int  jc1;
            int  jc2;
            int  kc1;
            int  kc2;
            
            int  id;
            int  idp;
            int idxi, idyi, idzi;
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
            
            kc1=(pk->z-r-Minz)/step;
            kc2=(pk->z+r-Minz)/step;;
            
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
            
            
            if (kc1<0) {
                kc1=0;
            }
            else if (kc1>nz-1)
            {kc1=nz-1;}
            
            
            if  (kc2>nz-1) {
                kc2=nz-1;
            }
            else if (kc2<0)
            {kc2=0;}
            
            
            *c=0;//counter numbers of points found
            
            //Volume Search
            
            for (idxi=ic1;idxi<=ic2;idxi++) {
                for(idyi=jc1;idyi<=jc2;idyi++) {
                    for(idzi=kc1;idzi<=kc2;idzi++) {
                        id=ny*idxi+nx*ny*idzi+idyi;
                        
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
            
            
        }
        
        
        
        void GLTREE3D::RemovePoint(Coord3D* p, int idp) {
            //remove the point idp from the tree
            int i;
            int idxi, idyi, idzi, idb;
            
            //Get points coordinates
            idxi=(p[idp].x-Minx)/step;
            idyi=(p[idp].y-Miny)/step;
            idzi=(p[idp].z-Minz)/step;
            
            //get the box id
            idb=ny*idxi+nx*ny*idzi+idyi;
            
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
        
        
        
        void GLTREE3D::SearchClosestExclusive(Coord3D *p, Coord3D *pk, int* idc, double* mindist, int sp) {/// Find the closest point using built Leaves the point id must be different from sp
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
            int kc1=0;
            int kc2=0;
            
            //integer pointers
            int  id;
            int  idp;
            
            //coordinates
            int idxi, idyi, idzi;
            
            bool goon;
            double sqrdist=HUGE_VAL;
            double	dyu, dxd, dyd, dxu, dzu, dzd;
            double dist;
            
            int ii=0;
            int jj=0;
            int kk=0;
            
            
            
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
            
            
//Get z coordinate
            
            idzi=(pk->z-Minz)/step;
            if (idzi<0) {
                idzi=0;
                dzd=Minz-pk->z;
                dzu=dzd+step;//distance up z
                
            }
            
            else if  (idzi>nz-1) {
                idzi=nz-1;
                dzd=pk->z-(Minz+idzi*step);//distance up y
                dzu=dzd-step;
            }
            else{
                dzu=Minz+(idzi+1)*step-pk->z;//distance up y
                dzd=pk->z-(Minz+idzi*step);
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
                   {for (kk=kc1;kk<=kc2;kk++)
                        
                    { //leaf search
                        BoxSearchExclusive
                                
                    }
                   }
                   dxd=dxd+step;
                  }
                  
                  //xup
                  if  (dxu<*mindist && idxi+c<nx)
                  { goon=true;
                    ic2=c;
                    ii=c;
                    for (jj=jc1;jj<=jc2;jj++)
                    { for (kk=kc1;kk<=kc2;kk++)
                          
                      { //leaf search
                          BoxSearchExclusive
                                  
                      }
                    }
                    dxu=dxu+step;
                  }
                  
                  //yup
                  if  (dyu<*mindist && idyi+c<ny)
                  {goon=true;
                   jc2=c;
                   
                   jj=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         
                         BoxSearchExclusive
                                 
                     }
                   }
                   dyu=dyu+step;
                  }
                  
                  //ydown
                  if  (dyd<*mindist && idyi-c>-1)
                  {goon=true;
                   jc1=-c;
                   
                   jj=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         BoxSearchExclusive
                                 
                                 
                     }
                   }
                   dyd=dyd+step;
                  }
                  
                  //zdown
                  if  (dzd<*mindist && idzi-c>-1)
                  {goon=true;
                   kc1=-c;
                   
                   kk=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         BoxSearchExclusive
                                 
                                 
                     }
                   }
                   dzd=dzd+step;
                  }
                  
                  //zup
                  if  (dzu<*mindist && idzi+c<nz)
                  {goon=true;
                   kc2=c;
                   
                   kk=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         
                         BoxSearchExclusive
                                 
                     }
                   }
                   dzu=dzu+step;
                  }
                  
                  
                  
                  
                  
                  
                  
                  c=c+1;
            }
            while (goon);
            
            
            
            
            return ;
            
            
        }
        
        
        
        int GLTREE3D::Dtest(Coord3D* p, Coord3D* pk, double sqrdist)
        
        {/// Verifica che non ci siano punti nel raggio al quadrato definito da sqrdist
            
            //p reference points
            //pk query point
            // sqrdist=radius for the search
            
            //La funzione ritorna -1 se il testo ha successo, altrimenti ritorna l'id del punto che viola il test.
            
            
            
            int ic1;
            int ic2;
            int  jc1;
            int  jc2;
            int  kc1;
            int  kc2;
            
            int  id;
            int  idp;
            int idxi, idyi, idzi;
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
            
            kc1=(pk->z-r-Minz)/step;
            kc2=(pk->z+r-Minz)/step;;
            
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
            
            
            if (kc1<0) {
                kc1=0;
            }
            else if (kc1>nz-1)
            {kc1=nz-1;}
            
            
            if  (kc2>nz-1) {
                kc2=nz-1;
            }
            else if (kc2<0)
            {kc2=0;}
            
            
            
            
            //Volume Search
            
            for (idxi=ic1;idxi<=ic2;idxi++) {
                for(idyi=jc1;idyi<=jc2;idyi++) {
                    for(idzi=kc1;idzi<=kc2;idzi++) {
                        id=ny*idxi+nx*ny*idzi+idyi;
                        
                        //search in the vlume
                        idp=First[id];
                        while (idp>=0) {
                            if (CurrentDistance<sqrdist) {
                                return test=idp;
                            }
                            idp=Next[idp];
                            
                        }
                    }
                }
            }
            
            return test;
        }
        
        
        
///////////////////////////////////////////////////////////////////////
//              SearchKClosestExclusive
/////////////////////////////////////////////////////////////////////
        void  GLTREE3D::SearchKClosestExclusive(Coord3D *p, Coord3D *pk, int* idc, double* distances, int k, int sp) {/// Find the closest point using built Leaves
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
            int kc1=0;
            int kc2=0;
            
            //integer pointers
            int  id, n, count;
            int  idp;
            
            //coordinates
            int idxi, idyi, idzi;
            
            bool goon;
            double sqrdist=HUGE_VAL;
            double mindist=HUGE_VAL;
            double	dyu, dxd, dyd, dxu, dzu, dzd;
            double dist;
            
            int ii=0;
            int jj=0;
            int kk=0;
            
            
            
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
            
            
//Get z coordinate
            
            idzi=(pk->z-Minz)/step;
            if (idzi<0) {
                idzi=0;
                dzd=Minz-pk->z;
                dzu=dzd+step;//distance up z
                
            }
            
            else if  (idzi>nz-1) {
                idzi=nz-1;
                dzd=pk->z-(Minz+idzi*step);//distance up y
                dzu=dzd-step;
            }
            else{
                dzu=Minz+(idzi+1)*step-pk->z;//distance up y
                dzd=pk->z-(Minz+idzi*step);
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
                   {for (kk=kc1;kk<=kc2;kk++)
                        
                    { //leaf search
                        BoxSearchKExclusive
                                
                    }
                   }
                   dxd=dxd+step;
                  }
                  
                  //xup
                  if  (dxu<mindist && idxi+c<nx)
                  { goon=true;
                    ic2=c;
                    ii=c;
                    for (jj=jc1;jj<=jc2;jj++)
                    { for (kk=kc1;kk<=kc2;kk++)
                          
                      { //leaf search
                          BoxSearchKExclusive
                                  
                      }
                    }
                    dxu=dxu+step;
                  }
                  
                  //yup
                  if  (dyu<mindist && idyi+c<ny)
                  {goon=true;
                   jc2=c;
                   
                   jj=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         
                         BoxSearchKExclusive
                                 
                     }
                   }
                   dyu=dyu+step;
                  }
                  
                  //ydown
                  if  (dyd<mindist && idyi-c>-1)
                  {goon=true;
                   jc1=-c;
                   
                   jj=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         BoxSearchKExclusive
                                 
                                 
                     }
                   }
                   dyd=dyd+step;
                  }
                  
                  //zdown
                  if  (dzd<mindist && idzi-c>-1)
                  {goon=true;
                   kc1=-c;
                   
                   kk=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         BoxSearchKExclusive
                                 
                                 
                     }
                   }
                   dzd=dzd+step;
                  }
                  
                  //zup
                  if  (dzu<mindist && idzi+c<nz)
                  {goon=true;
                   kc2=c;
                   
                   kk=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         
                         BoxSearchKExclusive
                                 
                     }
                   }
                   dzu=dzu+step;
                  }
                  
                  
                  
                  
                  
                  
                  
                  c=c+1;
            }
            while (goon);
            
            
            
            
            return ;
            
            
        }
        
        
        
        void GLTREE3D::SearchCuboid(Coord3D *p, double* Cuboid,int* npts) {
            /// FInds points inside the cuboid defined by Cuboid=[xmin,xmax,ymin,ymax...]
                
                
                
                      
            
            //volume iterators
            int ic1=0;
            int  ic2=0;
            int  jc1=0;
            int  jc2=0;
            int kc1=0;
            int kc2=0;
            
            //integer pointers
            int  id;
            int  idp;
            
       
            



            
            int ii=0;
            int jj=0;
            int kk=0;
            
            

            
           
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
            
  //Get zmin coordinate
            kc1=(Cuboid[4]-Minz)/step;
            if (kc1<0) {
                kc1=0;
            }
            else if  ( kc1>nz-1) {
                kc1=nz-1;
            }

//Get zmax coordinate
            kc2=(Cuboid[5]-Minz)/step;
            if (kc2<0) {
                kc2=0;
            }
            else if  ( kc2>nz-1) {
                kc2=nz-1;
            }            
                       
            
//include without test points inside the cuboid
            
             //Volume Search
            
             //   mexPrintf("Volume Search\n");
            
            c=0;
            for (ii=ic1+1;ii<ic2;ii++) {
                for(jj=jc1+1;jj<jc2;jj++) {
                    for(kk=kc1+1;kk<kc2;kk++) {
                        id=ny*ii+nx*ny*kk+jj;
                        
                        //search in the vlume
                        idp=First[id];
                        while (idp>=0) {
                            idStore[c]=idp;c++;
                            idp=Next[idp];
                            
                        }
                    }
                }
            }
             
            
         //   Search Trough the boundary of the cuboid
            
                  //xdown
            //   mexPrintf("xdown\n");
                   ii=ic1;
                   for (jj=jc1;jj<=jc2;jj++)
                   {for (kk=kc1;kk<=kc2;kk++)
                        
                    { //leaf search
                        BoxSearchCuboid
                                
                    }
                   }

                 
                  
                  //xup
                   //    mexPrintf("xup\n");
                     ii=ic2;
                   for (jj=jc1;jj<=jc2;jj++)
                   {for (kk=kc1;kk<=kc2;kk++)
                        
                    { //leaf search
                        BoxSearchCuboid
                                
                    }
                   }
                  
                  //ydown
                 //   mexPrintf("ydown\n");
                  jj=jc1;
                   for (ii=ic1+1;ii<ic2;ii++)
                   {for (kk=kc1;kk<=kc2;kk++)
                        
                    { //leaf search
                        BoxSearchCuboid
                                
                    }
                   }

                 
                  
                  //yup
                  //    mexPrintf("yup\n");
                  jj=jc2;
                   for (ii=ic1+1;ii<ic2;ii++)
                   {for (kk=kc1;kk<=kc2;kk++)
                        
                    { //leaf search
                        BoxSearchCuboid
                                
                    }
                   }
                  
                  //zdown
                   //       mexPrintf("zdown\n");
                   kk=kc1;
                   for (ii=ic1+1;ii<ic2;ii++)
                   { for (jj=jc1+1;jj<jc2;jj++)
                         
                     { //leaf search
                           BoxSearchCuboid
                                 
                                 
                     }
                   }
 
                  
                  //zup
            //      mexPrintf("zup\n");
                   kk=kc2;
                   for (ii=ic1+1;ii<ic2;ii++)
                   { for (jj=jc1+1;jj<jc2;jj++)
                         
                     { //leaf search
                         
                         BoxSearchCuboid
                                 
                     }
                   }
 
  
          //  mexPrintf("FInito\n");
            
            
            *npts=c;//set the number of found points
            
            return ;
        }
        
        
        
        ///////////////////////////////////////////////////////////////////////
//              SearchRadiusExlcusive
/////////////////////////////////////////////////////////////////////
        
        
        void  GLTREE3D::SearchRadiusExclusive(Coord3D* p, Coord3D* pk, double r, int* c,int sp)
        
        {/// Finds points inside a given radius using built Leaves
            
            //p reference points
            //pk query point
            // radius
            // number of returned points
            
            
            int ic1;
            int ic2;
            int  jc1;
            int  jc2;
            int  kc1;
            int  kc2;
            
            int  id;
            int  idp;
            int idxi, idyi, idzi;
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
            
            kc1=(pk->z-r-Minz)/step;
            kc2=(pk->z+r-Minz)/step;;
            
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
            
            
            if (kc1<0) {
                kc1=0;
            }
            else if (kc1>nz-1)
            {kc1=nz-1;}
            
            
            if  (kc2>nz-1) {
                kc2=nz-1;
            }
            else if (kc2<0)
            {kc2=0;}
            
            
            *c=0;//counter numbers of points found
            
            //Volume Search
            
            for (idxi=ic1;idxi<=ic2;idxi++) {
                for(idyi=jc1;idyi<=jc2;idyi++) {
                    for(idzi=kc1;idzi<=kc2;idzi++) {
                        id=ny*idxi+nx*ny*idzi+idyi;
                        
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
            
            
        }
        
