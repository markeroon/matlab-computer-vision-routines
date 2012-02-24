function [ d,d_x,d_y,d_z] = distance_vol( X1,Y1,Z1,x,y,z,dX )
%DISTANCE_VOL Creates a 3d distance volume
% X1,Y1,Z1 are vectors containing the rectified points

d =  ones(size(x));

d_x = ones(size(x));
d_y = ones(size(x));
d_z = ones(size(x));

size_x = size(x(:),1);

count = 0;
for i=1:size(d,1)
    for j=1:size(d,2)
        for k=1:size(d,3)
            x_cur = [ x(i,j,k) , y(i,j,k) , z(i,j,k) ];
            [d(i,j,k),d_x(i,j,k),d_y(i,j,k),d_z(i,j,k)] = ...
                                distance_function3d( x_cur,X1,Y1,Z1);
            if mod(count,1000) == 0
                count / size_x * 100
            end
            count = count+1;
        end
    end
end
%[d_x,d_y,d_z] = gradient( d, dX(1),dX(2),dX(3) );
end