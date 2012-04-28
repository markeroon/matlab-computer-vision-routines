function [phi] = reinitBoundaries2d( phi )
    phi( 1,:) = phi(2,:) + 1;
    phi(size(phi,1),:) = phi( size(phi,1)-1,:) + 1;
    phi( :,1) = phi(:,2) + 1;
    phi(:,size(phi,2)) = phi(:,size(phi,2)-1) + 1;
end