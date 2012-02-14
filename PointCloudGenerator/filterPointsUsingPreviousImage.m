function [X1_f,X2_f,X3_f,confidence] = filterPointsUsingPreviousImage( X1,X2,X3, P_prev,I_prev,P_ref,I_ref,half_window_size )
    X1_f = [];
    X2_f = [];
    X3_f = [];
    confidence = [];
    for i = 1:size( X1,2)
        is_valid_pixel = 1;
        if size( X1,2) == 1, error( 'only one point input' ), end
        X = [X1(i) ; X2(i); X3(i) ; 1. ];
        x_ref = P_ref*X;
        x_ref = x_ref / x_ref(3);

        x_prev = P_prev * X;
        x_prev = x_prev / x_prev(3);
        
        if ~projectsToImage( x_ref,I_ref,half_window_size ) ...
                || ~projectsToImage( x_prev,I_prev,half_window_size )
            is_valid_pixel = false;
        end
        if is_valid_pixel
            template = I_ref( round(x_ref(2))-half_window_size:round(x_ref(2))+half_window_size, ...
                            round(x_ref(1))-half_window_size:round(x_ref(1))+half_window_size );
            im = I_prev( round(x_prev(2))-half_window_size:round(x_prev(2))+half_window_size, ...
                            round(x_prev(1))-half_window_size:round(x_prev(1))+half_window_size );
        end
        % ensures no NaN problems     
        if is_valid_pixel && ~all( template(:) == template(1))
            res_im = normxcorr2( template,im );
            if res_im(11,11) >= 0.65
                X1_f = [X1_f X1(i)];
                X2_f = [X2_f X2(i)];
                X3_f = [X3_f X3(i)];
                confidence = [confidence res_im(11,11)];
            end
        end
    end
end
