% KNNSearch3DFEX query a GL-tree for k nearest neighbor(kNN)
%
% SYNTAX
%
% [NNG]=KNNSearch3DFEX(p,qp,ptrtree);       short
% [NNG,Dist]=KNNSearch3DFEX(p,qp,ptrtree);  long
%
% INPUT PARAMETERS
% 
%       p: [Nx3] double array coordinates of reference points
% 
%       qp: [Nqx3] double array coordinates of query points
%
%       ptrtree: a pointer to the previously constructed  GLtree.Warning
%                if the pointer is uncorrect it will cause a crash, there is
%                no way to check this in the mex routine, you have to check
%                yourself in your script.
%
%       
%
% OUTPUT PARAMETERS
%
%      NNG: [Nqx1] array, each rows contains the kNN indexes
%            So in row one there are kNN to first query
%           point, in row two to the second etc...
% 
%      Dist: [Nqx1] array, Facultative output, each rows contains the
%                   distance values of the  found kNN.
%         
%
%
%
% GENERAL INFORMATIONS
%
%         -This function is faster if all query points are given once
%         instead of looping and pass one point each loop.
%
%
%  For question, suggestion, bug reports
%  giaccariluigi@msn.com
% 
% Visit: <a href="http://www.advancedmcode.org/gltree.html"> The GLTree Web Page</a>
%
% This work is free thanks to users gratitude, if you find it usefull
% please consider making a donation on my website.
%
%  Author : Luigi Giaccari
%  Last Update: 2/1/2010
%  Created : 8/8/2008
