function [phi] = cube_SDF( dims, margin, dX )

    top = margin; 
    left = margin; 
    back = margin;

    bottom= dims(1) - margin + 1; 
    right = dims(2) - margin + 1; 
    front = dims(3) - margin + 1;

    phi = ones(dims);

    %phi(top:bottom, left:right, back) = 1;
    %phi(top:bottom, left:right, front) = 1;
    %phi(bottom,left:right,back) = 1;
    %phi(bottom,left:right,front) = 1;


    %phi(top:bottom, left,front:back) = 1;
    %phi(top:bottom, left,front) = 1;
    %phi(top:bottom, right,front:back) = 1; 
    %phi(top:bottom, right,front) = 1;

    %phi(top, left:right, front:back ) = 1;
    %phi(top, right, front:back ) = 1;
    %phi(bottom,left:right, front:back ) = 1;
    %phi(bottom,right,front:back ) = 1;

    phi(top:bottom,left:right,back:front) = -1;
    phi = computeDistanceFunction3d( phi, dX );
    %phi = -bwdist(phi); 
    %phi(top:bottom, left:right,front:back) = - phi(top:bottom, left:right,front:back); 
end