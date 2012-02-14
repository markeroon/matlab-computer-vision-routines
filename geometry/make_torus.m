function [phi] = make_torus( R, r,x,y,z )
    % R is dist from center of tube to center of torus
    % r is radius of tube
    % r = 5, R = 10
    % example:
    % [x,y,z] = meshgrid(-50:50,-50:50,-50:50 );
    % make_torus( 20,20,x,y,z ); 
    phi = (R - (x.^2 + y.^2).^.5 ).^2 + z.^2 - r^2;
end