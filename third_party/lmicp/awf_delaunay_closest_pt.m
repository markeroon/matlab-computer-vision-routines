function k = awf_delaunay_closest_pt(delstruct, xi, yi)

% AWF_DELAUNAY_CLOSEST_PT Compute closest point, given delstruct
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 04 Apr 01

k = dsearch(delstruct.x, delstruct.y, delstruct.tri, xi, yi, delstruct.S);
