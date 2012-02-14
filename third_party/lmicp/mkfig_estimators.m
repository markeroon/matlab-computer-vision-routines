function mkfig_estimators()

% MKFIG_ESTIMATORS A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 15 Apr 01


t = linspace(-3, 3);

E = 'huber';
param = .3;

hold off
val = awf_m_estimator(E, t, param);
plot(t, val); 
hold on
plot(t(1:end-1) + (t(2) - t(1))/2, diff(val)/(t(2) - t(1)), 'r')
plot(t, awf_m_estimator(['D' E], t, param), 'k')
