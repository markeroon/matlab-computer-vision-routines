
% FIG_BOX2D_ALL A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 09 Sep 01

hold off
k=1;h= plot(RotAngleRange, out(:,k), 'r');
hold on
k=2;h(2) = plot(RotAngleRange, out(:,k), 'b');

k=1;errorbar(RotAngleRange, out(:,k), err(:,k), 'r');
k=2;errorbar(RotAngleRange, out(:,k), err(:,k), 'b');
legend('icp', 'lm');
xlabel('Error in initial guess (degrees)')
ylabel('Number of iterations')
set(h, 'linewidth', 4);
drawnow

print -painters -dmeta
