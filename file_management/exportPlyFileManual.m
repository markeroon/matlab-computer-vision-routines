function [A] = exportPlyFileManual( X1,X2,X3,confidence,sil_occl_im, filename  )
%EXPORTOFFFILE Takes points and exports them to a .ply file
    im_row_major = sil_occl_im';
    num_points = max( size(X1) );
    A = [ X1', X2', X3' ]; %, confidence' ];
    off_fid = fopen( filename,'wt' );
    fprintf( off_fid, 'ply\nformat ascii 1.0\n' );
    fprintf( off_fid, 'obj_info num_cols %d\n', size(im_row_major,2) ); 
    fprintf( off_fid, 'obj_info num_rows %d\n', size(im_row_major,1) );
    fprintf( off_fid, 'element vertex %d\n', num_points );
    fprintf( off_fid, 'property float x\n' );
    fprintf( off_fid, 'property float y\n' );
    fprintf( off_fid, 'property float z\n' );
    %fprintf( off_fid, 'property float confidence\n' )
    fprintf( off_fid, 'element range_grid %d\n', size(im_row_major(:),1));
    fprintf( off_fid, 'property list uchar int vertex_indices\n' );
    fprintf( off_fid, 'end_header\n');
    fprintf( off_fid, '%f %f %f \n', A' );
    
    count = 0;
    for i=1:size(im_row_major,1)
        for j=1:size(im_row_major,2)
            if im_row_major(i,j) == 1
                fprintf( off_fid, '1 %d\n', count );
                count = count + 1;
            else
                fprintf( off_fid, '0\n' );
            end
        end
    end
    fclose( off_fid );    
end

