%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta = 180;
R_y = [ cosd(theta)  0 sind(theta); 
        0           1   0 ;
        -sind(theta) 0 cosd(theta) ]
%}
%R_y = cpd_R( 0, 0, 20 *pi / 180 );
%rot = R_y * [X1(idx_1); Y1(idx_1); Z1(idx_1)];
 
%X1_r = rot(1,:)';
%Y1_r = rot(2,:)';
%Z1_r = rot(3,:)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%