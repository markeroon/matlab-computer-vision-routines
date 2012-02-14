function delstruct = awf_delaunay_4srch(x,y)

% AWF_DELAUNAY_4SRCH Set up structure for delaunay closest-pt searches.
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 04 Apr 01

delstruct.x = x;
delstruct.y = y;
delstruct.tri = delaunay(x, y);
nxy = prod(size(x));
delstruct.S = sparse(...
    delstruct.tri(:,[1 1 2 2 3 3]),...
    delstruct.tri(:,[2 3 1 3 1 2]),...
    1,nxy,nxy);
