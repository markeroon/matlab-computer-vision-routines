function [a,P_cell,numImages] = dinoFileRead( filename )
% format imgname.png k11 k12 k13 k21 k22 k23 k31 k32 k33 r11 r12 r13 r21 r22 r23 r31 r32 r33 t1 t2 t3
 
k = zeros( 3,3 );
%r = zeros( 3,3 );
%t = zeros( 3,1 );

RT = zeros( 3,4 );

%fid = fopen('dino/dino_par.txt', 'r');
%fid = fopen('dinoSparseRing/dinoSR_par.txt', 'r');
%fid = fopen('/home/mbrophy/ComputerScience/dinoRing/dinoR_par.txt', 'r' );
fid = fopen( filename, 'r' ); 
numImages = fscanf( fid, '%d' );
P_cell = cell( numImages,1 );

%a = fscanf(fid, ['dino%4d.png %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n'] );
%a = fscanf(fid, ['dinoSR%4d.png %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n'] );
a = fscanf(fid, ['dinoR%4d.png %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g\n'] );

numargs = 22;

offset = 0;
for i = 1:numImages
    

    k(1,1:3) = a(2+offset:4+offset);
    k(2,1:3) = a(5+offset:7+offset);
    k(3,1:3) = a(8+offset:10+offset);

    %r(1,1:3) = a(11:13);
    RT(1,1:3) = a(11+offset:13+offset);
    %r(2,1:3) = a(14:16);
    RT(2,1:3) = a(14+offset:16+offset);
    %r(3,1:3) = a(17:19);
    RT(3,1:3) = a(17+offset:19+offset);
    
    RT(1:3,4) = a(20+offset:22+offset);
    
    %t(1:3,1) = a(20:22);
    
    P = k*RT;
    
    P_cell{i} = P;
    offset = offset + numargs;
end    