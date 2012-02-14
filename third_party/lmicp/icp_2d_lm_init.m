function borgefors = icp_2d_lm_init(model, RES, EXPANDFACTOR)

% ICP_2D_LM_INIT A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Sep 01

if nargin < 2
  RES = 500;
end
if nargin < 3
  EXPANDFACTOR = 5;
end

I = finite(model(:,1));

borgefors0 = awf_borgefors(RES,RES,EXPANDFACTOR, model(I,1),model(I,2));

borgefors = borgefors0;
borgefors.D = gsmooth(borgefors0.D, 2.0, 'same');
% Finite-difference delta
deltax = 2*borgefors.xscale;
deltay = 2*borgefors.yscale;
borgefors.Dx = conv2(borgefors.D, [1 0 -1]'/deltax, 'same');
borgefors.Dy = conv2(borgefors.D, [1 0 -1]/deltay, 'same');

