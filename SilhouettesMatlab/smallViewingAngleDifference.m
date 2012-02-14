function [isSmallAngle] = smallViewingAngleDifference( X, c1, c2 )
    if( size( c1 ) ~= size( X ) )
        sprintf( 'c1 is not the same size as X\n' )
        sprintf( 'size(c1) = %d, size(c2) = %d, size(X) = %d', c1,c2,X )
    end
    v1 = (c1 - X) / norm( c1 - X );
    v2 = (c2 - X) / norm( c2 - X );
    
    angle = acosd( dot( v1,v2 ) );
    isSmallAngle = abs( angle ) < 45;
end