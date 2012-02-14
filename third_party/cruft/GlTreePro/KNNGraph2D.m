% KNNGraph2D query a GL-tree for k nearest neighbor Graph
%
% SYNTAX
%
% [kNNG]=KNNGraph(p,ptrtree,k);       short
% [kNNG,dist]=KNNGraph(p,ptrtree,k);  long
%
% INPUT PARAMETERS
% 
%       p: [2xN] double array coordinates of reference (and query) points.
%                In a nearest neighbour graph for each point in p the
%                k closest in p (different from the point itself) will
%                be found.
%       
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
%      kNNG: [Nxk] array, each rows contains the kNN indexes
%            So in row one there are kNN to first query
%           point, in row two to the second etc...
% 
%      Dist: [Nxk] array, Facultative output, each rows contains the
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


