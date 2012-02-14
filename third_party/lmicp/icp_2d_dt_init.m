% function icp_2d_dt_init()

% ICP_2D_DT_INIT A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 14 Apr 01


borgefors0 = awf_borgefors(256,256,cx(:,1),cx(:,2));

borgefors = borgefors0;
borgefors.D = gsmooth(borgefors0.D, 2.0, 'same');
borgefors.Dx = conv2(borgefors.D, [-1 0 1]', 'same');
borgefors.Dy = conv2(borgefors.D, [-1 0 1], 'same');
