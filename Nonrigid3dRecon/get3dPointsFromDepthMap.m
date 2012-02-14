function [ X_vec ] =  ...
    get3dPointsFromDepthMap( silhouetteIm,x,y,z )
% GET3DPOINTSFROMDEPTHMAP get CPD-appropriate matrix from depth map z

idx_im = find( silhouetteIm == 1 );
x_vec = x(idx_im);

y_vec = y(idx_im);

z_vec = z(idx_im);

X_vec = [ x_vec'; y_vec'; z_vec' ];




end

