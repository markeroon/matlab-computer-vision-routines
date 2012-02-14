#include "OvImageAdapter.h"
#include "OvImageT.h"
#include <cstdlib> 
#include <iomanip>
#include "ProbabilisticEgomotion.h"

typedef struct {
  OvImageT<float> g;
  OvImageT<float> pt1_x;
  OvImageT<float> pt1_y;
  OvImageT<float> pt2_x;
  OvImageT<float> pt2_y;
} ProbabilityDistributions;


void print3Dmotion(MotionParameters egomotion)
{
  using namespace std;

  cout << " score: " << egomotion.score
    << "  tx : " << egomotion.tx << "  ty: " << egomotion.ty << "  tz: " << egomotion.tz
    << "  r_x: " << egomotion.r_x << "  r_y: " << egomotion.r_y << "  r_z: "
    << egomotion.r_z << endl;
}


OvImageT<float> getProbDist(OvImageT<float> phases1, OvImageT<float> phases2, int i0, int j0, int lb_i, int lb_j, int ub_i, int ub_j)
{
  int pad = 20;

  int height, width, channels;
  phases1.getDimensions(height,width,channels);

  OvImageT<float> result = OvImageT<float>(ub_i-lb_i, ub_j-lb_j, 1);

  for(int i=lb_i; i<ub_i; i++){
    for(int j=lb_j; j<ub_j; j++){
      result(i-lb_i,j-lb_j) = 1;
      for(int c=0; c<channels; c++){
        float diff  = abs(phases1(i0,j0,c) - phases2(i,j,c));
        float diff2 = abs(phases1(i0,j0,c) - phases2(i,j,c)+3.141592);
        float diff3 = abs(phases1(i0,j0,c) - phases2(i,j,c)-3.141592);
        if(diff2 < diff)
          diff = diff2;
        if(diff3 < diff)
          diff = diff3;
        // need to unwrap phase of diff here
        result(i-lb_i,j-lb_j) *= .5 + exp(-2*diff*diff);
      }
    }
  }
  result /= L1Norm(result);  // normalize the distribution
  return result;
}

ProbabilityDistributions getProbDists(OvImageT<float> phases1, OvImageT<float> phases2, int numpoints)
{
  int maxrez    = 300;
  float minprob = 1/(float)maxrez;

  OvImageT<float> g     = OvImageT<float>(numpoints,maxrez,1);
  OvImageT<float> pt1_x = OvImageT<float>(numpoints,1,1);
  OvImageT<float> pt1_y = OvImageT<float>(numpoints,1,1);
  OvImageT<float> pt2_x = OvImageT<float>(numpoints,maxrez,1);
  OvImageT<float> pt2_y = OvImageT<float>(numpoints,maxrez,1);

  int height, width, channels;
  phases1.getDimensions(height,width,channels);

  // doesn't take pixels from pad around the edge
  int pad = 20;

  for(int n=0; n<numpoints; n++){
    float myheight = pad + rand() % (height - 2*pad) ;
    float mywidth  = pad + rand() % (width  - 2*pad) ;

    int i0   = myheight;
    int j0   = mywidth;
    int lb_i = myheight-pad;
    int lb_j = mywidth -pad;
    int ub_i = myheight+pad;
    int ub_j = mywidth +pad;

    OvImageT<float> dist = getProbDist(phases1, phases2, i0, j0, lb_i, lb_j, ub_i, ub_j);

    int where = 0;
    float norm = 0;
    pt1_x(n,0) = mywidth;
    pt1_y(n,0) = myheight;

    // why do the following?  If no points make the cut, we don't want singularities
    // it will be overwritten otherwise
    pt2_x(n,0) = mywidth;
    pt2_y(n,0) = myheight;
    g(n,0)     = 1;

    for(int i=lb_i; i<ub_i; i++){
      for(int j=lb_j; j<ub_j; j++){
        float prob = dist(i-lb_i,j-lb_j);
        if(prob > minprob){
          //cout << "i: " << i << " j: " << j << " prob: " << prob << " where: " << where << endl;
          pt2_x(n,where) = j;
          pt2_y(n,where) = i;
          g(n,where) = prob;
          norm += prob;
          where++;
        }
      }
    }
    // want probabilities to sum to 1
    for(int i=0; i<where; i++)
      g(n,i) /= norm;
  }

  // create a structure to return the dists
  ProbabilityDistributions mydists;
  mydists.g = log(g);
  mydists.pt1_x = pt1_x;
  mydists.pt1_y = pt1_y;
  mydists.pt2_x = pt2_x;
  mydists.pt2_y = pt2_y;

  return mydists;
}

void printProbdists(ProbabilityDistributions mydists)
{
  using namespace std;

  int numpoints, maxrez, channels;
  mydists.g.getDimensions(numpoints,maxrez,channels);

  cout << "numpoints: " << numpoints << "  maxrez: " << maxrez << endl;
  for(int n=0; n<numpoints; n++){
    cout << "n: " << n << " x1: " << mydists.pt1_x(n,0) << " y1: " << mydists.pt1_y(n,0) << endl;
    for(int where=0; mydists.g(n,where)> -100; where++){
      cout << "     " << " x2: " << mydists.pt2_x(n,where) << " y2: " << mydists.pt2_y(n,where) 
        << " g: " << mydists.g(n,where) << endl;
    }
  }

}

MotionParameters randMotion()
{
  float x = -1+2*((float) rand()/RAND_MAX);
  float y = -1+2*((float) rand()/RAND_MAX);
  float z = -1+2*((float) rand()/RAND_MAX);
  float norm = sqrt(x*x + y*y + z*z);

  while(norm > 1 ){
    x = -1+2*((float) rand()/RAND_MAX);
    y = -1+2*((float) rand()/RAND_MAX);
    z = -1+2*((float) rand()/RAND_MAX);
    norm = sqrt(x*x + y*y + z*z);
  }
  x = x/norm;
  y = y/norm;
  z = z/norm;

  float r_x  = 1*(-1+2*((float) rand()/RAND_MAX)) ;
  float r_y  = 1*(-1+2*((float) rand()/RAND_MAX)) ;
  float r_z  = 1*(-1+2*((float) rand()/RAND_MAX)) ;
  r_x = .1*r_x*r_x*r_x;
  r_y = .1*r_y*r_y*r_y;
  r_z = .1*r_z*r_z*r_z;


  MotionParameters myparams;
  myparams.tx    = x;
  myparams.ty    = y;
  myparams.tz    = z;
  myparams.r_x   = r_x;
  myparams.r_y   = r_y;
  myparams.r_z   = r_z;

  return myparams;
}



float evalmotion(ProbabilityDistributions mydists, MotionParameters myparams, float f, float pp_x, float pp_y)
{
  float tx = myparams.tx;
  float ty = myparams.ty;
  float tz = myparams.tz;

  float T11 = 0;
  float T12 = -tz;
  float T13 = ty;
  float T21 = tz;
  float T22 = 0;
  float T23 = -tx;
  float T31 = -ty;
  float T32 = tx;
  float T33 = 0;

  float phi = sqrt(myparams.r_x*myparams.r_x
    + myparams.r_y*myparams.r_y
    + myparams.r_z*myparams.r_z + 1e-10);
  float nx = myparams.r_x/phi;
  float ny = myparams.r_y/phi;
  float nz = myparams.r_z/phi;
  float R11 = 1 - 2*(ny*ny + nz*nz)*pow(sin(.5*phi),2);
  float R12 = -nz*sin(phi) + 2*nx*ny *pow(sin(.5*phi),2);
  float R13 =  ny*sin(phi) + 2*nz*nx *pow(sin(.5*phi),2);
  float R21 =  nz*sin(phi) + 2*nx*ny*pow(sin(.5*phi),2);
  float R22 = 1 - 2*(nz*nz + nx*nx)*pow(sin(.5*phi),2);
  float R23 = -nx*sin(phi) + 2*ny*nz *pow(sin(.5*phi),2);
  float R31 = -ny*sin(phi) + 2*nz*nx*pow(sin(.5*phi),2);
  float R32 =  nx*sin(phi) + 2*ny*nz*pow(sin(.5*phi),2);
  float R33 = 1 - 2*(nx*nx + ny*ny)*pow(sin(.5*phi),2);

  float E11 = R11*T11 + R21*T12 + R31*T13;
  float E12 = R12*T11 + R22*T12 + R32*T13;
  float E13 = R13*T11 + R23*T12 + R33*T13;
  float E21 = R11*T21 + R21*T22 + R31*T23;
  float E22 = R12*T21 + R22*T22 + R32*T23;
  float E23 = R13*T21 + R23*T22 + R33*T23;
  float E31 = R11*T31 + R21*T32 + R31*T33;
  float E32 = R12*T31 + R22*T32 + R32*T33;
  float E33 = R13*T31 + R23*T32 + R33*T33;

  float retval = 0;

  int numpoints, maxrez, channels;
  mydists.g.getDimensions(numpoints,maxrez,channels);

  float thisg;
  float thisdistsq1;
  for(int i=0; i<numpoints; i++){
    float s_x = mydists.pt1_x(i,0)-pp_x;
    float s_y = mydists.pt1_y(i,0)-pp_y;

    float l1 = E11*s_x + E12*s_y + E13*f;
    float l2 = E21*s_x + E22*s_y + E23*f;
    float l3 = E31*s_x + E32*s_y + E33*f;

    float normfactor = sqrt(l1*l1+l2*l2);
    l1 = l1/normfactor;
    l2 = l2/normfactor;
    l3 = l3/normfactor;

    float mysum = -1e100;
    for(int j=0; j<maxrez && mydists.g(i,j)>-100; j++){
      float q_x = mydists.pt2_x(i,j)-pp_x;
      float q_y = mydists.pt2_y(i,j)-pp_y;
      float g   = mydists.g(i,j);

      float myt0 = (l1*q_x + l2*q_y + l3*f);
      float distsq1 = myt0*myt0;

      float thismysum = g - distsq1;
      if(thismysum > mysum){
        mysum=thismysum;

        thisg = g;
        thisdistsq1 = distsq1;
      }
    }

    retval += log(exp(mysum)+1); // this parameter is the constant alpha in the paper    
  }

  return retval;
}

MotionParameters addparams(MotionParameters myparams1, MotionParameters myparams2)
{
  MotionParameters newparams;
  newparams.tx  = myparams1.tx  + myparams2.tx;
  newparams.ty  = myparams1.ty  + myparams2.ty;
  newparams.tz  = myparams1.tz  + myparams2.tz;
  newparams.r_x = myparams1.r_x + myparams2.r_x;
  newparams.r_y = myparams1.r_y + myparams2.r_y;
  newparams.r_z = myparams1.r_z + myparams2.r_z;
  return newparams;
}

MotionParameters scaleparams(MotionParameters myparams, float c)
{
  MotionParameters newparams = myparams;
  newparams.tx  *= c;
  newparams.ty  *= c;
  newparams.tz  *= c;
  newparams.r_x *= c;
  newparams.r_y *= c;
  newparams.r_z *= c;
  return newparams;
}

MotionParameters normparams(MotionParameters myparams)
{
  MotionParameters newparams = myparams;
  float x = myparams.tx;
  float y = myparams.ty;
  float z = myparams.tz;
  float norm = sqrt(x*x + y*y + z*z);
  x = x/norm;
  y = y/norm;
  z = z/norm;
  newparams.tx = x;
  newparams.ty = y;
  newparams.tz = z;
  return newparams;
}


MotionParameters jumpover(MotionParameters starter, MotionParameters centroid)
{
  // try flipping worst point about centroid
  // idea is newpoint = worst + 2*(centroid - worst) = 2*centroid - worse
  return normparams(addparams(scaleparams(centroid,2),scaleparams(starter,-1)));
}

MotionParameters jumpoverBig(MotionParameters starter, MotionParameters centroid)
{
  // try flipping worst point about centroid
  // idea is newpoint = worst + 3*(centroid - worst) = 3*centroid - 2*worse
  return normparams(addparams(scaleparams(centroid,3),scaleparams(starter,-2)));
}

MotionParameters searchmotions_nm(ProbabilityDistributions mydists, MotionParameters points[], float f, float pp_x, float pp_y)
{
  // this is an implementation of the nelder-mead simplex search algorithm

  using namespace std;

  // when this integer gets above 3, search terminates
  int go_on = 0;

  // big loop
  int worst = 0;
  int best  = 0;
  while(go_on < 3){
    go_on++;  // set to zero on success

    // find worst and best point
    worst = 0;
    best  = 0;
    for(int i=1; i<6; i++){
      if(points[i].score < points[worst].score)
        worst = i;
      if(points[i].score > points[best].score)
        best = i;
    }

    // compute centroid
    MotionParameters centroid = addparams(points[0],points[1]);
    for( int i=2; i<6; i++)
      centroid = addparams(centroid,points[2]);
    centroid = normparams(scaleparams(centroid,1/6.0));

    // try flipping worst point about centroid
    // idea is newpoint = worst + 2*(centroid - worst) = 2*centroid - worse
    MotionParameters newpoint = jumpover(points[worst], centroid); 
    newpoint.score = evalmotion(mydists, newpoint, f, pp_x, pp_y);

    if(newpoint.score > points[worst].score){
      if(newpoint.score > points[best].score){
        // try a really good point
        MotionParameters newpoint2 = jumpoverBig(points[worst], centroid); 

        newpoint2.score = evalmotion(mydists, newpoint2, f, pp_x, pp_y);
        if(newpoint2.score > newpoint.score)
          newpoint = newpoint2;
      }
      points[worst] = newpoint;
      go_on = 0;
    }

    if(go_on > 0){
      // if we are here, the newpoint was not helpful
      // instead try .5(centroid + worst)
      newpoint = normparams(scaleparams(addparams(centroid,points[worst]),.5));
      newpoint.score = evalmotion(mydists, newpoint, f, pp_x, pp_y);
      if(newpoint.score > points[worst].score){
        points[worst] = newpoint;
        go_on = 0;
      }
    }

    if(go_on > 0){
      // if we are here, nothing has worked-- perform a 'shrink step'
      // move every vertex halfway towards the best (either best or center point)
      // we do an extra evalmotion here sometimes, if one wants to be very hardcore
      // about speed

      // termination condition
      // notice that the centroid's score has not been calculated
      centroid.score = evalmotion(mydists, centroid, f, pp_x, pp_y);
      if( abs(centroid.score-points[best].score) < 1e-2 &&
        abs(centroid.score-points[worst].score) < 1e-2 &&
        abs(points[worst].score-points[best].score) < 1e-2)
        go_on = 100;

      if(points[best].score > centroid.score)
        centroid = points[best];

      for(int i=0; i<6; i++){
        points[i] = normparams(scaleparams(addparams(points[i],centroid),.5));
        points[i].score = evalmotion(mydists, points[i], f, pp_x, pp_y);
      }
    }
  }

  return points[best];
}


MotionParameters compute3Dmotion(OvImageAdapter & image1, OvImageAdapter & image2, float f, float pp_x, float pp_y, int numpoints, int numsearches)
{

  OvImageT<float> im1;
  im1.copyFromAdapter(image1);
  im1.setToGray(); // insist on having a grayscale image

  OvImageT<float> im2;
  im2.copyFromAdapter(image2);
  im2.setToGray(); // insist on having a grayscale image

  OvImageT<float> im1Phases = im1.getGaborPhaseStack();
  OvImageT<float> im2Phases = im2.getGaborPhaseStack();

  ProbabilityDistributions mydists = getProbDists(im1Phases,im2Phases,numpoints);

  float pi = 3.141592;

  MotionParameters myparams;
  MotionParameters bestparams;
  bestparams.score = -100;

  MotionParameters mybestparams;
  MotionParameters points[6];

  MotionParameters mypoint;

  // get a pool of good points for later use
  const int numgoodpoints = 25;
  MotionParameters goodpoints[numgoodpoints];
  for(int n=0; n<numgoodpoints; n++)
    goodpoints[n].score = -1000;
  int worst = 0;
  int best  = 0;
  for(int i=0; i<1000; i++){
    mypoint = randMotion();
    mypoint.score = evalmotion(mydists,mypoint,f,pp_x,pp_y);

    if(mypoint.score > goodpoints[worst].score)
      goodpoints[worst] = mypoint;
    for(int n=0; n<numgoodpoints; n++){
      if(goodpoints[n].score < goodpoints[worst].score)
        worst = n;
      if(goodpoints[n].score > goodpoints[best].score)
        best  = n;
    }    
  }

  /*
  // uncomment to see the points currently completed
  std::cout << "goodpoints: " << std::endl;
  for(int n=0; n<numgoodpoints; n++)
  print3Dmotion(goodpoints[n]);
  std::cout << " " << std::endl;    
  */

  // now use the set of good points to initialize a few simplex searches
  for(int m=0; m<numsearches; m++){
    for(int n=0; n<6; n++)
      points[n] = goodpoints[rand() % numgoodpoints];
    points[0] = goodpoints[worst];

    mybestparams = searchmotions_nm(mydists,points,f,pp_x,pp_y);
    if( mybestparams.score > goodpoints[worst].score)
      goodpoints[worst] = mybestparams;

    for(int n=0; n<numgoodpoints; n++){
      if(goodpoints[n].score < goodpoints[worst].score)
        worst = n;
      if(goodpoints[n].score > goodpoints[best].score)
        best  = n;
    }
  }

  MotionParameters egomotion = goodpoints[best];

  return egomotion;
}
