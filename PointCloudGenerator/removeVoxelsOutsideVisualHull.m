function [X1_sil,X2_sil,X3_sil] = removeVoxelsOutsideVisualHull( ...
            X1_vec,X2_vec,X3_vec,silhouettes,P )
    bad_silhouettes = [6];
    num_points = max( size( X1_vec ) );
    num_images = max( size( P ) );
    to_be_removed = zeros(size(X1_vec));
    for i = 1:num_points
        for idx = 1:num_images
            X_i = [X1_vec(i) ; X2_vec(i) ; X3_vec(i) ; 1 ];
            x_i = projectToImage( P{idx},X_i );
            bad_sil = contains( bad_silhouettes,idx );
            % not in silhouette
            if( ~bad_sil && projectsToImage(x_i,silhouettes{idx}) ...
                    && (~(silhouettes{idx,1}(x_i(2,1),x_i(1,1)) == 1)) )
                to_be_removed(i) = 1;
            end
            %if( ~projectsToImage( x_i,silhouettes{idx} ) )
            %    to_be_removed(i) = 1;
            %end
        end
    end
    X1_sil = X1_vec( ~to_be_removed );
    X2_sil = X2_vec( ~to_be_removed );
    X3_sil = X3_vec( ~to_be_removed );
end

function x = projectToImage( P, X )
    x = P * X;
    w = x(3,1);
    % now normalize -- don't bother with 3rd coord
    x(1,1) = round( x(1,1) / w );
    x(2,1) = round( x(2,1) / w );
    x(3,1) = round( x(3,1) / w );

end

% ensures that voxel projects to image, but is also not a boundary pixel
function projBool = projectsToImage( p_1,im )
    x1 = int16( round( p_1(1,1) ) );
    y1 = int16( round( p_1(2,1) ) );
    %if( ( x1 <= (480-3) ) && ( x1 > (0+3) ) && ( y1 <= (640-3) ) && ( y1 > (0+3) ) )
    if( x1 <= size(im,2) && x1 > 0 && ( y1 <= size(im,1) ) && ...
            y1 > 0 )
        projBool = true;
    else
        projBool = false;
    end
end

function [isMemberOf] = contains( A, value )
    isMemberOf = false;
    for i = 1:size( A,1 )
        for j = 1:size( A,2 )
            if( A(i,j) == value )
                isMemberOf = true;
            end
        end
    end
end