#include "GLTree3DFEX.h"





//Some macros
#define CurrentDistance (dist=(p[idp].x-pk->x)*(p[idp].x-pk->x)+(p[idp].y-pk->y)*(p[idp].y-pk->y)+(p[idp].z-pk->z)*(p[idp].z-pk->z))\


//Perform the search in the current Leaf
#define LeafSearch  id=nyint*(idxi+ii)+nxint*nyint*(idzi+kk)+idyi+jj;\
ptr=First[id];\
        while(ptr>=0)\
        {idp=Leaves[ptr].idpoint;\
                 if (CurrentDistance<sqrdist)\
                 {*idc=idp;\
                          sqrdist=dist;\
                          *mindist=sqrt(sqrdist);\
                 }\
                         ptr=Leaves[ptr].next;\
        }\
                
                

                
                
                
                
//Constructor
                GLTREE::GLTREE(Coord3D*p, int Np)//constructor
        {
            
            
            const double npbox=.5;//number of exitimated point each leaf
            
            int i;//counter
            int idxi, idyi, idzi;
            double V;
            double Maxx=-HUGE_VAL;
            double Maxy=-HUGE_VAL;
            double Maxz=-HUGE_VAL;
            double step;
            double nxdouble, nydouble, nzdouble;
            int Nb;
            int id;
            
            IdStore=new int[Np];//store fo serach radisu
            
            
            
            N=Np;
            
            
            
            Minx=HUGE_VAL;
            Miny=HUGE_VAL;
            Minz=HUGE_VAL;
            //Determinazione valori max e min
            for (i=0;i<N;i++) {
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
            
            Nb=(int)((N/npbox)+.5);
            V=(Maxx-Minx)*(Maxy-Miny)*(Maxz-Minz);//Volume
            step=pow(V/Nb, .33333333333333333);//size of leaf
            
            nxdouble=(Maxx-Minx)/step;
            nydouble=(Maxy-Miny)/step;
            nzdouble=(Maxz-Minz)/step;
            
            nxdouble=(int)(nxdouble+.5);//numero di foglie x , intero double
            nydouble=(int)(nydouble+.5);//numero di foglie y ,  intero double
            nzdouble=(int)(nzdouble+.5);//numero di foglie z ,  intero double
            
//Step computation for tollerance
            
            if((Maxx-Minx)>(Maxy-Miny))//compare dx and dy
            {if((Maxx-Minx)>(Maxz-Minz))//compare dx and dz
             {step=Maxx-Minx;}
             else
             { {step=Maxz-Minz;}}
            }
            else
            {if((Maxy-Miny)>(Maxz-Minz))//compare dy and dz
             {step=Maxy-Miny;}
             else
             { {step=Maxz-Minz;}}
            }
            
            
            
//Quasi square dimensione delle boxes
            
            Toll=1e-9*step;
            PX=(Maxx-Minx+1e4*Toll)/(nxdouble);//passo
            PY=(Maxy-Miny+1e4*Toll)/(nydouble);//1e-9 per aumentare il passo
            PZ=(Maxz-Minz+1e4*Toll)/(nzdouble);//1e-9 per aumentare il passo
            
            
            //convert coordinates to integer type
            nxint=nxdouble;
            nyint=nydouble;
            nzint=nzdouble;
            
            Nb=nxint*nyint*nzint;//real number of leaves
            
            
            //allocate memory
            First=new int[Nb];//contains the pointers to leaves
            //Get negative values for First
            for(i=0;i<Nb;i++)
            {First[i]=-1;}
            
            Leaves=new GLNode[N];
            int counter=0;
            
            //mexPrintf("Nb= %4.4d\n",Nb);
            
            
            //loop to allocate points in the GLTree Data structure
            for (i=0;i<N;i++) {
                
                idxi=(p[i].x-Minx+Toll)/PX;
                idyi=(p[i].y-Miny+Toll)/PY;
                idzi=(p[i].z-Minz+Toll)/PZ;
                
                //id=ny*(idx-1)+(ny*nx)*(idz-1)+idy;Matlab
                id=nyint*idxi+nxint*nyint*idzi+idyi;
                
                
                //vedere se a counter si può sostituire i
                
                Leaves[counter].idpoint=i;
                Leaves[counter].next=First[id];//store the bos id
                First[id]=counter;
                counter++;
//                 mexPrintf(" %4.0d \n ", counter);
                
            }
////            Debug (PLot the tree)
//            int ptr, idp;
//            for (id=0;id<Nb;id++)
//            {   ptr=First[id];
//                mexPrintf("Leaf %4.1d : ", id);
//                while(ptr>=0)
//                {idp=Leaves[ptr].idpoint;
//                 ptr=Leaves[ptr].next;
//                 mexPrintf(" %4.1d ", idp);
//                }
//                mexPrintf(" \n");
//            }
        }
        
        
        
        
        
        GLTREE::~GLTREE()//destructor
        {
            delete [] First;
            delete [] Leaves;
            delete [] IdStore;
            
            
        }
        
        
        
        
        
        
        
        
        void GLTREE::SearchClosest(Coord3D *p, Coord3D *pk, int* idc, double* mindist) {/// Find the closest point using built Leaves
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
            int ptr;
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
            idxi=(pk->x-Minx+Toll)/PX;
            if (idxi<0) {
                idxi=0;
                dxd=Minx-pk->x;
                dxu=dxd+PX;
            }
            
            
            else if  (idxi>nxint-1) {
                idxi=nxint-1;
                dxd=pk->x-(Minx+idxi*PX);
                dxu=dxd-PX;
            }
            else {
                dxd=pk->x-(Minx+idxi*PX);
                dxu=Minx+(idxi+1)*PX-pk->x;
            }
            
            
//Get ycoordinate
            idyi=(pk->y-Miny+Toll)/PY;
            if (idyi<0) {
                idyi=0;
                dyd=Miny-pk->y;
                dyu=dyd+PY;//distance up y
                
            }
            
            else if  (idyi>nyint-1) {
                idyi=nyint-1;
                dyd=pk->y-(Miny+idyi*PY);//distance up y
                dyu=dyd-PY;
            }
            else{
                dyu=Miny+(idyi+1)*PY-pk->y;//distance up y
                dyd=pk->y-(Miny+idyi*PY);
            }
            
            
//Get z coordinate
            
            idzi=(pk->z-Minz+Toll)/PZ;
            if (idzi<0) {
                idzi=0;
                dzd=Minz-pk->z;
                dzu=dzd+PZ;//distance up z
                
            }
            
            else if  (idzi>nzint-1) {
                idzi=nzint-1;
                dzd=pk->z-(Minz+idzi*PZ);//distance up y
                dzu=dzd-PZ;
            }
            else{
                dzu=Minz+(idzi+1)*PZ-pk->z;//distance up y
                dzd=pk->z-(Minz+idzi*PZ);
            }
            
            
            //Search the first leaf
            LeafSearch
                    
                    
                    
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
                        LeafSearch
                                
                    }
                   }
                   dxd=dxd+PX;
                  }
                  
                  //xup
                  if  (dxu<*mindist && idxi+c<nxint)
                  { goon=true;
                    ic2=c;
                    ii=c;
                    for (jj=jc1;jj<=jc2;jj++)
                    { for (kk=kc1;kk<=kc2;kk++)
                          
                      { //leaf search
                          LeafSearch
                                  
                      }
                    }
                    dxu=dxu+PX;
                  }
                  
                  //yup
                  if  (dyu<*mindist && idyi+c<nyint)
                  {goon=true;
                   jc2=c;
                   
                   jj=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         
                         LeafSearch
                                 
                     }
                   }
                   dyu=dyu+PY;
                  }
                  
                  //ydown
                  if  (dyd<*mindist && idyi-c>-1)
                  {goon=true;
                   jc1=-c;
                   
                   jj=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (kk=kc1;kk<=kc2;kk++)
                         
                     { //leaf search
                         LeafSearch
                                 
                                 
                     }
                   }
                   dyd=dyd+PY;
                  }
                  
                  //zdown
                  if  (dzd<*mindist && idzi-c>-1)
                  {goon=true;
                   kc1=-c;
                   
                   kk=-c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         LeafSearch
                                 
                                 
                     }
                   }
                   dzd=dzd+PZ;
                  }
                  
                  //zup
                  if  (dzu<*mindist && idzi+c<nzint)
                  {goon=true;
                   kc2=c;
                   
                   kk=c;
                   for (ii=ic1;ii<=ic2;ii++)
                   { for (jj=jc1;jj<=jc2;jj++)
                         
                     { //leaf search
                         
                         LeafSearch
                                 
                     }
                   }
                   dzu=dzu+PZ;
                  }
                  
                  
                  
                  
                  
                  
                  
                  c=c+1;
            }
            while (goon);
            
            
            
            
            return ;
            
            
        }
        
        
        
        
        
        
        
        
     