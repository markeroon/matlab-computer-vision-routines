%% Runs a few test
mex -g NNFilter3D.cpp

N=10000;%reference points
Nq=10000;%query points
k=3;%k neigh
r=.1;%radius
Cuboid=[.28 ,.3 ,.28 ,.3 , .28  ,.3]';

p=rand(N,3);
qp=rand(Nq,3);

fprintf('RANDOM POINTS GENERATED\n\n')

%% BUILD THE TREE
fprintf('BUILDING THE DATA STRUCTURE:\n')
tic
ptrtree=BuildGLTree3D(p');
fprintf('\tGLTree built in %4.4f s\n\treturned pointer %4.0f:\n\n',toc,ptrtree);
[cutdist,ndel,idel]=NNFilter3D(p',ptrtree,'r',.1);

DeleteGLTree3D(ptrtree);