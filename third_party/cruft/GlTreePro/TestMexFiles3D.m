%Script to compile and test GLTree files


clc
clear all
close all


%% Compile
fprintf('COMPILING:\n')
 


mex BuildGLTree3D.cpp
fprintf('\tBuildGLTree3D : mex succesfully completed.\n') 

mex CuboidSearch3D.cpp
fprintf('\tCuboidSearch3D : mex succesfully completed.\n') 

mex KNNSearch3D.cpp
fprintf('\tKNNSearch3D : mex succesfully completed.\n') 

mex KNNGraph3D.cpp
fprintf('\tKNNGraph3D : mex succesfully completed.\n') 


mex RSearch3D.cpp
fprintf('\tRSearch3D : mex succesfully completed.\n') 

mex NNFilter3D.cpp
fprintf('\tNNFilter3D : mex succesfully completed.\n') 


mex DeleteGLTree3D.cpp
fprintf('\tDeleteGLTree3D : mex succesfully completed.\n\n') 



%% Runs a few test

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

%% CUBOID SEARCH
fprintf('START CUBOID SEARCH:\n')


tic
for i=1:Nq
[idc]=CuboidSearch3D(p',Cuboid,ptrtree);

%Checking the results
in=(p(:,1)>Cuboid(1) & p(:,1)<Cuboid(2) & p(:,2)>Cuboid(3) & p(:,2)<Cuboid(4) & p(:,3)>Cuboid(5) & p(:,3)<Cuboid(6));

id=1:N;

idc2=id(in);

if  any(sort(idc)'~=sort(idc2))
    error('Bug Found in cuboid search');
end

end
fprintf('\t  Cuboid Search took: %4.4f s\n\n',toc);



%% K NEAREST NEIGHBOR SEARCH

fprintf('START K NEAREST NEIGHBOR SEARCH:\n')
tic
[KNNG,distances]=KNNSearch3D(p',qp',ptrtree,k);
fprintf('\t  NNsearch of%4.0f neighbors in %4.0f reference points and %4.0f query points took: %4.4f s\n\n',k,N,Nq,toc);

[KNNG2, distances2]=BruteSearchMex(p',qp','k',k);

%checking the results

%sort the results
KNNG=sort(KNNG,2);
KNNG2=sort(KNNG2,2);
distances=sort(distances,2);
distances2=sort(distances2,2);

if ~(all(KNNG==KNNG2 | distances==distances2 ))
       
     error('Bug Found in KNN search');
end



%% START K NEAREST NEIGHBOR GRAPH
fprintf('START K NEAREST NEIGHBOR GRAPH CONSTRUCTION:\n')
tic
[KNNG,distances]=KNNGraph3D(p',ptrtree,k);
fprintf('\t  KNNGraph of%4.0f neighbors in %4.0f reference took: %4.4f s\n\n',k,N,toc);

%We use the normal knn to verify with k=k+1 and qp=p
[KNNG2,distances2]=KNNSearch3D(p',p',ptrtree,k+1);
KNNG2(:,end)=[];%last columns is the closesest
distances2(:,end)=[];%last columns is the closesest
%sort the results
KNNG=sort(KNNG,2);
KNNG2=sort(KNNG2,2);
distances=sort(distances,2);
distances2=sort(distances2,2);

if ~(all(KNNG==KNNG2 | distances==distances2 ))
       
     error('Bug Found in the K nearest neighbours graph');
end

%% RADIUS SEARCH
fprintf('START RADIUS SEARCH:\n')
tic
for i=1:Nq
[idc]=RSearch3D(p',qp(i,:)',ptrtree,r);


[idc2]=BruteSearchMex(p',qp(i,:)','r',r);

if  any(sort(idc)'~=sort(idc2))
    error('Bug Found in radius search');
end

end
fprintf('\t  RSearch with radius = %4.2f, in %4.0f reference points and %4.0f query points took: %4.4f s\n\n',r,N,Nq,toc);




%% START  NEAREST NEIGHBOR FILTERING (f)
fprintf('START NEAREST NEIGHBOR FILTERING\n')
tic
[cutdist,ndel,idel]=NNFilter3D(p',ptrtree,'f',2);
fprintf('\t  NNFilter of%4.0f points took: %4.4f s\n\n',N,toc);

%Check that in the nearest neighbor graph there is no distance less than
%cutdist
in=true(N,1);in(idel)=false;
[KNNG,distances]=KNNGraph3D(p',ptrtree,1);

if any(distances(in)<cutdist)
       
     error('Bug Found in the NEIGHBOR FILTERING (f)');
end







% %% START  NEAREST NEIGHBOR FILTERING (r)
% fprintf('START NEAREST NEIGHBOR FILTERING\n')
% tic
% [cutdist,ndel,idel]=NNFilter3D(p',ptrtree,'r',.1);
% fprintf('\t  NNFilter of%4.0f points took: %4.4f s\n\n',N,toc);
% 
% %Check that in the nearest neighbor graph there is no distance less than
% %cutdist
% in=true(N,1);in(idel)=false;
% [KNNG,distances]=KNNGraph3D(p',ptrtree,1);
% 
% if any(distances(in)<cutdist)
%        
%      error('Bug Found in the NEIGHBOR FILTERING (f)');
% end



fprintf('DELETING THE TREE\n\n')
DeleteGLTree3D(ptrtree);
 

fprintf('TEST SUCCESFULLY COMPLETED !!!\n\n')


