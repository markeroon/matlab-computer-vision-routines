     I = double(imread('coins.png')); 
     g = ac_gradient_map(I, 5); 
     phi = ac_SDF_2D('rectangle', size(I), 5) ;
     countour_weight = 3; expansion_weight = -1; 
     delta_t = 5; n_iters = 1; show_result = 0;
     
     for i = 1:160
        %phi_old = phi; % for checking termination criteria
        contour = zero_crossing( phi ); 
        g_contour = zeros( size( I ) );
        index = find( contour > 0.9 );
        g_contour(index) = g(index);
        
        phi = ac_GAC_model(g_contour, phi, countour_weight, expansion_weight, ...
                delta_t, n_iters, show_result);
        %if isequal(phi > 0, phi_old > 0), break; end
     end
     imagesc( g_contour );
     figure;     
     imagesc( I );