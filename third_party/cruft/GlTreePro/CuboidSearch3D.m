% CuboidSearch3D query a GL-Tree for Points inside a cuboid
% 
% SYNTAX
% idc=CuboidSearch(p,cuboid,ptrtree)
% 
% INPUT PARAMETERS
% 
%       p: [3xN] double array coordinates of reference points              
% 
%       cuboid: [xmin;xmax;ymin;ymax;zmin;zmax]; 6x1 double array defining
%                the cuboid boundary
% 
%       ptrtree: a pointer to the previously constructed  GLtree.Warning
%                if the pointer is uncorrect it will cause a crash, there is
%                no way to check this in the mex routine, you have to check
%                it in your script.
% 
% 
% 
% OUTPUT PARAMETERS
% 
%   idc: [?x1] column vector, each rows contains an index of a point found in
%        the range described by the cuboid.
%         
% 
% GENERAL INFORMATIONS
% 
%         -Conditions for a point to be found in the radius is <=, so
%         points with distance from the query=r will be returned.
% 
% 
% For question, suggestion, bug reports
% giaccariluigi@msn.com
%
%Author: Luigi Giaccari
%
% Visit:
%<a href="http://www.advancedmcode.org/gltree-pro-version-a-fast-nearest-neighbour-library-for-matlab-and-c.html"> GLTree Home Page</a>

