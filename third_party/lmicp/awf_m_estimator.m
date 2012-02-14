function e = awf_m_estimator(type, r, param)

% AWF_M_ESTIMATOR A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 04 Apr 01

p2 = param.*param;
ar = abs(r);

switch type
case 'ls'
  e = r.*r;
case 'Dls'
  e = 2*r;
  
case 'trim'
  e = r.*r;
  e(ar > param) = 0;
case 'Dtrim'
  e = 2*r;
  e(ar > param) = 0;
  
case 'bz'
  e = r.*r;
  e(ar > param) = p2;
case 'Dbz'
  e = 2*r;
  e(ar > param) = 0;

case 'huber'
  I = ar < param;
  e = ar.*ar;
  e(~I) = 2 * param * ar(~I) - p2;
case 'Dhuber'
  e = 2 * r;
  I = ar < param;
  e(~I) = 2*param * sign(r(~I));

case 'lorentzian'
  e = log(1 + (r ./ param).^2);
case 'Dlorentzian'
  e = 2*r ./ (p2 + r.*r);
  
otherwise
  error(type)
end
