function [dmin,xmin,ymin] = distance_function2d(x,S)
dmin = inf;
for i=1:size(S,1)
   dx = abs(S(i,1) - x(1));
   dy = abs(S(i,2) - x(2));
   d = sqrt(dx^2+dy^2);
   if d<dmin
       dmin=d;
       xmin = dx;
       ymin = dy;
   end   
end