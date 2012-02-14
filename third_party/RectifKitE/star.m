function  X = star(x)
%STAR Return the skew-symmetric matrix X s.t. cross(x,y) = X*y
%
% X is s.t. ker(X) = x

% The name is after the Hodge star operator, of which this is an instance.

%    Author: A. Fusiello 

if (length(x) ~= 3)
    error('Vector must be  3-dimensional');
end



X=[   0    -x(3)  x(2)
     x(3)    0   -x(1)
    -x(2)  x(1)   0   ];
