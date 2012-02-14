% KNNSearch2D query a GL-tree for k nearest neighbor(kNN)
%
% SYNTAX
%
% [kNNG]=KNNSearch2D(p,qp,ptrtree,k);       short
% [kNNG,Dist]=KNNSearch2D(p,qp,ptrtree,k);  long
%
% INPUT PARAMETERS
% 
%       p: [2xN] double array coordinates of reference points
% 
%       qp: [2xNq] double array coordinates of query points
%
%       ptrtree: a pointer to the previously constructed  GLtree.Warning
%                if the pointer is uncorrect it will cause a crash, there is
%                no way to check this in the mex routine, you have to check
%                it in your script.
%
%       k: number of neighbors
%
% OUTPUT PARAMETERS
%
%      kNNG: [Nqxk] array, each rows contains the kNN indexes
%            So in row one there are kNN to first query
%           point, in row two to the second etc...
% 
%      Dist: [Nqxk] array, Facultative output, each rows contains the
%                   distance values of the  found kNN.
%         
%
%
%
% GENERAL INFORMATIONS
%
%         -This function is faster if all query points are given once
%         instead of looping and passing one point each loop.
%
%
%
%For question, suggestion, bug reports
% giaccariluigi@msn.com
%
%Author: Luigi Giaccari
%
% Visit:
%<a href="http://www.advancedmcode.org/gltree-pro-version-a-fast-nearest-neighbour-library-for-matlab-and-c.html"> GLTree Home Page</a>


