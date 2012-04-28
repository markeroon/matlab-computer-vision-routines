%REGISTER_VIA_SURFACE_SUBDIVISION Do a coarse to fine, recursive
%registration.
function [Y1,Y2,Y3] = registerRecursive( X,Y,opt,MIN_SIZE )

[Y1,Y2,Y3] = registerPoints( X,Y,opt,MIN_SIZE );
end    
 
function [X__,Y__,Z__] = registerPoints( X,Y,opt,MIN_SIZE )   
    if size(X,1) > MIN_SIZE && size(Y,1) > MIN_SIZE
        [T] = cpd_register(X,Y,opt);
        Y1_ = T.Y(:,1);
        Y2_ = T.Y(:,2);
        Y3_ = T.Y(:,3);
        
        % after initial registration, use more refined
        opt.fgt = 0;
        opt.method = 'rigid';
        opt.normalize = 1;
        opt.outliers = 0.4;
        T = 0;
        Y = [];
        q = [X(:,1);Y1_]
        min_x = min( [ X(:,1);Y1_ ] );
        max_x = max( [ X(:,1);Y1_ ] );
        min_y = min( [ X(:,2);Y2_ ] );
        max_y = max( [ X(:,2);Y2_ ] );
        min_z = min( [ X(:,3);Y3_ ] ); 
        max_z = max( [ X(:,3);Y3_ ] );
        % padding does not work because 
        % we are just dividing in half.
        %pad = 0.2;
        
        width = dist(min_x,max_x);
        height = dist(min_y,max_y);
        depth = dist(min_z,max_z);
        
        left_x   = min_x; %- pad*width
        right_x  = max_x; %+ pad*width
        top_x    = max_y; %+ pad*height
        bottom_x = min_y; %- pad*height
        back_x   = min_z; %- pad*depth
        front_x  = max_z; %+ pad*depth
        
        % this use of X co-ords as the dividing space is on purpose
        left_y   = min_x;
        right_y  = max_x;
        top_y    = max_y;
        bottom_y = min_y;
        back_y   = min_z;
        front_y  = max_z ;     
        
        m_width  = left_x+((right_x-left_x)/2);
        m_height = bottom_x+((top_x-bottom_x)/2);
        m_depth = back_x+((front_x-back_x)/2 );
        
        m_width_y  = left_y+((right_y-left_y)/2);
        m_height_y = bottom_y+((top_y-bottom_y)/2);
        m_depth_y = back_y+((front_y-back_y)/2 );
        
        X1_ = X(:,1);
        X2_ = X(:,2);
        X3_ = X(:,3);
        
        idx_x_000 = find( X1_ < m_width & X2_ < m_height & X3_ < m_depth );
        idx_x_001 = find( X1_ < m_width & X2_ < m_height & X3_ >= m_depth );
        idx_x_010 = find( X1_ < m_width & X2_ >= m_height & X3_ < m_depth );
        idx_x_011 = find( X1_ < m_width & X2_ >= m_height & X3_ >= m_depth );
        idx_x_100 = find( X1_ >= m_width & X2_ < m_height & X3_ < m_depth );
        idx_x_101 = find( X1_ >= m_width & X2_ < m_height & X3_ >= m_depth );
        idx_x_110 = find( X1_ >= m_width & X2_ >= m_height & X3_ < m_depth );
        idx_x_111 = find( X1_ >= m_width & X2_ >= m_height & X3_ >= m_depth );

        idx_y_000 = find( Y1_ < m_width_y & Y2_ < m_height_y & Y3_ < m_depth_y );
        idx_y_001 = find( Y1_ < m_width_y & Y2_ < m_height_y & Y3_ >= m_depth_y );
        idx_y_010 = find( Y1_ < m_width_y & Y2_ >= m_height_y & Y3_ < m_depth_y );
        idx_y_011 = find( Y1_ < m_width_y & Y2_ >= m_height_y & Y3_ >= m_depth_y );
        idx_y_100 = find( Y1_ >= m_width_y & Y2_ < m_height_y & Y3_ < m_depth_y );
        idx_y_101 = find( Y1_ >= m_width_y & Y2_ < m_height_y & Y3_ >= m_depth_y );
        idx_y_110 = find( Y1_ >= m_width_y & Y2_ >= m_height_y & Y3_ < m_depth_y );
        idx_y_111 = find( Y1_ >= m_width_y & Y2_ >= m_height_y & Y3_ >= m_depth_y );
        
        %make fgt = 0 for the smaller subdivisions
        [Y1_000,Y2_000,Y3_000] = registerPoints( X(idx_x_000,:),[Y1_(idx_y_000),Y2_(idx_y_000),Y3_(idx_y_000)],opt,MIN_SIZE );
        idx_x_000 = 0; idx_y_000 = 0;
        [Y1_001,Y2_001,Y3_001] = registerPoints( X(idx_x_001,:),[Y1_(idx_y_001),Y2_(idx_y_001),Y3_(idx_y_001)],opt,MIN_SIZE );
        idx_x_001 = 0; idx_y_001 = 0;
        [Y1_010,Y2_010,Y3_010] = registerPoints( X(idx_x_010,:),[Y1_(idx_y_010),Y2_(idx_y_010),Y3_(idx_y_010)],opt,MIN_SIZE );
        idx_x_010 = 0; idx_y_010 = 0;
        [Y1_011,Y2_011,Y3_011] = registerPoints( X(idx_x_011,:),[Y1_(idx_y_011),Y2_(idx_y_011),Y3_(idx_y_011)],opt,MIN_SIZE );
        idx_x_011 = 0; idx_y_011 = 0;
        [Y1_100,Y2_100,Y3_100] = registerPoints( X(idx_x_100,:),[Y1_(idx_y_100),Y2_(idx_y_100),Y3_(idx_y_100)],opt,MIN_SIZE );
        idx_x_100 = 0; idx_y_100 = 0;
        [Y1_101,Y2_101,Y3_101] = registerPoints( X(idx_x_101,:),[Y1_(idx_y_101),Y2_(idx_y_101),Y3_(idx_y_101)],opt,MIN_SIZE );
        idx_x_101 = 0; idx_y_101 = 0;
        [Y1_110,Y2_110,Y3_110] = registerPoints( X(idx_x_110,:),[Y1_(idx_y_110),Y2_(idx_y_110),Y3_(idx_y_110)],opt,MIN_SIZE );
        idx_x_110 = 0; idx_y_110 = 0;
        [Y1_111,Y2_111,Y3_111] = registerPoints( X(idx_x_111,:),[Y1_(idx_y_111),Y2_(idx_y_111),Y3_(idx_y_111)],opt,MIN_SIZE );
        idx_x_111 = 0; idx_y_111 = 0;
        X__ = [Y1_000; Y1_001 ; Y1_010 ; Y1_011 ; Y1_100 ; Y1_101 ; Y1_110 ; Y1_111 ]; 
        Y__ = [Y2_000; Y2_001 ; Y2_010 ; Y2_011 ; Y2_100 ; Y2_101 ; Y2_110 ; Y2_111 ];  
        Z__ = [Y3_000; Y3_001 ; Y3_010 ; Y3_011 ; Y3_100 ; Y3_101 ; Y3_110 ; Y3_111 ]; 
    else
        X__ = Y(:,1);
        Y__ = Y(:,2);
        Z__ = Y(:,3);
    end

end
