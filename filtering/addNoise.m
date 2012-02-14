function [ x_corrupt,y_corrupt,z_corrupt] = addNoise( X,Y,Z,frequency,sigma )
%ADDNOISE Corrupts a subset of the measured points
    
    x_corrupt = X;
    y_corrupt = Y;
    z_corrupt = Z;
    
    noisy_signal_x = X + sigma*randn(size(X));
    noisy_signal_y = Y + sigma*randn(size(X));
    noisy_signal_z = Z + sigma*randn(size(X));

    x_corrupt( 1:frequency:end ) = noisy_signal_x(1:frequency:end);
    y_corrupt( 1:frequency:end ) = noisy_signal_y(1:frequency:end);
    z_corrupt( 1:frequency:end ) = noisy_signal_z(1:frequency:end);
end

