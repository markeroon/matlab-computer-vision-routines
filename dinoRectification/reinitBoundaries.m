function [phi] = reinitBoundaries3d( phi )
    phi( 1,:,:) = 5;
    phi( :,1,:) = 5;
    phi( :,:,1) = 5;
    phi(:,:,size(phi,3)) = 5;
    phi(:,size(phi,2),:) = 5;
    phi(size(phi,1),:,:) = 5;
end