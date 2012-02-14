function [ X,Y,Z,gray_val ] = import3Pi( filename )

fid = fopen( filename,'r' );
A1 = fscanf( fid, '#3PI file Copyright(C) 1997-2001 ShapeGrabber Incorporated\n', [1 1] )
A2 = fscanf( fid, '#:Number of Points per Profiles: %d\n', [1 1] )
A3 = fscanf( fid, '#:Number of Profiles: %d\n', [1 1] )
A4 = fscanf( fid, '#:Pose Transformation:\n', [1 1] )
A5 = fscanf( fid, '#    %f %f %f %f\n', [4 inf] )

X = []; Y = []; Z = []; gray_val = []; 

for i=1:A3
    
   profile_num = fscanf( fid, '%s\n', [1 2] );
   A = fscanf( fid, '%f %f %f %d %d\n', [5 A2] );
   X = [ X A(1,:) ];
   Y = [ Y A(2,:) ];
   Z = [ Z A(3,:) ];
   gray_val = [ gray_val A(4,:) ];
end

end
