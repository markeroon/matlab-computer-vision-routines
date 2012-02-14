function [ c_x,c_y,c_z ] = getCameraCenter( P )
% getCameraCenter Given 3x4 projection matrix P, 
% return the co-ordinates of the camera center

    P2P3P4 = zeros(3,3);
    P2P3P4(1:3,1) = P(1:3,2);
    P2P3P4(1:3,2) = P(1:3,3);
    P2P3P4(1:3,3) = P(1:3,4);
    c_x = det( P2P3P4 );
    
    P1P3P4 = zeros(3,3);
    P1P3P4(1:3,1) = P( 1:3,1 );
    P1P3P4(1:3,2) = P( 1:3,3 );
    P1P3P4(1:3,3) = P( 1:3,4 );    
    c_y = -det( P1P3P4 );
    
    P1P2P4 = zeros(3,3); %P1P2P4 is 3x3
    P1P2P4(1:3,1) = P( 1:3,1 );
    P1P2P4(1:3,2) = P( 1:3,2 );
    P1P2P4(1:3,3) = P( 1:3,4 );
    c_z = det( P1P2P4 );
    
    P1P2P3 = zeros(3,3); %P1P2P4 is 3x3
    P1P2P3(1:3,1) = P( 1:3,1 );
    P1P2P3(1:3,2) = P( 1:3,2 );
    P1P2P3(1:3,3) = P( 1:3,3 );
    t = -det( P1P2P3 );
    
    c_x = c_x / t;
    c_y = c_y / t;
    c_z = c_z / t;
    
end

