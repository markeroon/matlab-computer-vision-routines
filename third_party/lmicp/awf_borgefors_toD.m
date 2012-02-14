function [xb,yb] = awf_borgefors_toD(borgefors, x,y)

% AWF_BORGEFORS_TOD A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 14 Apr 01

xb = (x - borgefors.xstart) / borgefors.xscale;
yb = (y - borgefors.ystart) / borgefors.yscale;
