% ensures that voxel projects to image, but is also not a boundary pixel
function projBool = projectsToImage( p_1,im,bound_size )
    x1 = int16( round( p_1(1,1) ) );
    y1 = int16( round( p_1(2,1) ) );
    if( x1 < (size(im,2)-bound_size) && x1 > (0+bound_size) && ( y1 < (size(im,1)-bound_size) ) && y1 > (0+bound_size) )
        projBool = true;
    else
        projBool = false;
    end
end
