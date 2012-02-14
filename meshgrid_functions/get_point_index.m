function [ idx ] = get_point_index( p_x,p_y,p_z,x,y,z,h )
% GET_POINT_INDEX find the index of the point p = [p_x,p_y,p_z]
% in the meshgrid as defined by x,y,z
%h=1.;
idx = find( (p_x - h) < x & x < (p_x + h)  ...
     & (p_y - h) < y & y < (p_y + h) ...
     & (p_z - h) < z & z < (p_z + h) );


if isempty( idx ), error( 'the point falls outside of the meshgrid' ); end
 
end

