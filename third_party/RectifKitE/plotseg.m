function plotseg(c,x1,x2,T)
%PLOTSEG plot a segment tranformed according to T
% line is c(1)*x + c(2)*y + c(3) = 0
% T is a 3x3 matrix encoding a projective transformation of the plane

% vengono fatte delle approssimazioni, ma tanto e` solo per disegnare

% Author: Andrea Fusiello


if nargin == 3 
    T = eye(3);
end


% trasforma la retta individuata da c
if c(1) == 0
  c(1) = 1e-12;
end
if c(2) == 0
  c(2) = 1e-12;
end

c3d = T * [ 
    0  -c(3)/c(1)
    -c(3)/c(2) 0
    1            1       ];
  
x = ((c3d(1,:)'./c3d(3,:)'));
y = ((c3d(2,:)'./c3d(3,:)')); 

% retta trasformata
  a = y(2)-y(1);
  b = x(1)-x(2);
  k = -x(1)*a-y(1)*b;
  if b == 0
    b = 1e-12;
  end
  
  y1 = -a/b*x1-k/b;
  y2 =  -a/b*x2-k/b;
  
  plot([x1 x2], [y1, y2],'k');
