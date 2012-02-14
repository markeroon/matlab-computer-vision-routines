I = double(imread('coins.png')); 
%g = ac_gradient_map(I, 5); 

contour_weight = 1; expansion_weight = 1;
delta_t = 1; n_iters = 100; show_result = 1; 
     
c = 3;
dims = size( I );         
center = [ size(I,2)/2 ; size(I,1)/2]; radius =  70;    
phi = ac_SDF_2D('circle', dims, center, radius ) ;
g = ones( size(phi) );
phi2 = c + ac_curvature_flow_AOS( phi, delta_t, n_iters );