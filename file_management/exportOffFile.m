function [A] = exportOffFile( X1,X2,X3, filename  )
%EXPORTOFFFILE Takes points and exports them to a .off file

    num_points = max( size(X1) );
    %A = [X1 X2 X3];
    A = [ X1', X2', X3' ];
    off_fid = fopen( filename,'wt' );
    fprintf( off_fid, 'OFF\n' );
    fprintf( off_fid, '%d 0 0\n', num_points );
    fprintf( off_fid, '%f %f %f \n', A' );
    fclose( off_fid );
    
end

