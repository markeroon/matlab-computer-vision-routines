function awf_axissurround(p, ratio)

% AWF_AXISSURROUND A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 04 Apr 01

pmin = min(p);
pmax = max(p);

pmean = mean([pmin; pmax]);

prad = pmax - pmean;

pboundary = prad * ratio;

axis([ ...
      pmean(1) - prad(1) * ratio ...
      pmean(1) + prad(1) * ratio ...
      pmean(2) - prad(2) * ratio ...
      pmean(2) + prad(2) * ratio ]);

      