function exportXFfile( pml1, filename )
    
    [a,r,t] = art(pml1);
    xf = [r t]; % I love you, Matlab
    fid = fopen( filename,'wt' );
    fprintf( fid, '%f %f %f %f\n', xf' );
    fclose(fid);
end