
    
    [s,P,numImages] = dinoFileRead( );
    %obtain camera centers
    c = cell( numImages,1);
    image = cell(numImages,1);
    for index=1:numImages
        filename = sprintf( '/home/mbrophy/ComputerScience/dinoRing/dinoR%04d.png', index );
    end



    % have visual hull, now compute photoconsistency    
    Nx = 100;
    Ny = 100;
    Nz = 100;
    x_lo = -0.1;%-0.08;
    x_hi = 0.1;%0.05; 
    y_lo = -0.1;%-0.03;
    y_hi = 0.1;%0.09; 
    z_lo = -0.1;%-0.08;
    z_hi = 0.1;%0.03;
    dx = (x_hi-x_lo)/Nx;
    dy = (y_hi-y_lo)/Ny;
    dz = (z_hi-z_lo)/Nz;
    dX = [dx dy dz];
    X = (x_lo:dx:x_hi)';
    Y = (y_lo:dy:y_hi)';
    Z = (z_lo:dz:z_hi)';
    [x,y,z] = meshgrid(X,Y,Z);
    
    % phi obtained previously (visual hull)
    % compute dissimMeasure
    for i=1:size(phi,1)
        for j=1:size(phi,2)
            for k=1:size(phi,3)
                if( phi(i,j,k) <= 0.01 )
                    X_i = [ x(p,q,r) ; y(p,q,r) ; z(p,q,r) ; 1.0 ];
                    x_i = projectToImage( P{idx},X_i );
                    
                    [corr_val,dissim] = getCorrelationScore( X_i, P, image, numImages, );
                end    
            end
        end
    end
    
    
    