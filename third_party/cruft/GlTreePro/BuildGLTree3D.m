% BuildGLTree construct a GL-Tree from a 3D points set
%
% SYNTAX
% ptrtree=BuildGLTree(p);
%
% INPUT PARAMETERS
%   p: [Nx3] double array of the x,y and z coordinates of points.
%     
%
% OUTPUT PARAMETERS
%   ptrtree: a pointer to the created data structure
%
%
% GENERAL INFORMATIONS
%
%     - GLTree is an exact method, no approximate search is done. If you find a
%      different value from the expected one,  you found a bug, please
%      send a report to the author.
%     - GLTree works on double precision, inputs must be doubles.
%     - GLTree is faster on uniformly random data. On sparse ones should work
%      properly but may be  slower
%     -DO NOT CHANGE THE ARRAY p after building a tree search results may
%     be incorrect. If you have to change p you need to rebuild the
%     data structure.
%
%
%For question, suggestion, bug reports
% giaccariluigi@msn.com
%
%Author: Luigi Giaccari
%
% Visit:
%<a href="http://www.advancedmcode.org/gltree-pro-version-a-fast-nearest-neighbour-library-for-matlab-and-c.html"> GLTree Home Page</a>

