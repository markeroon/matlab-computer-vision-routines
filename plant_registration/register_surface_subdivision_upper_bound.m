function [Y1,Y2,Y3] = ...
                    register_surface_subdivision_upper_bound( X,Y,iters_rigid,...
                                                      iters_nonrigid )
%REGISTER_VIA_SURFACE_SUBDIVISION Do a coarse to fine registration.
%
%MIN_SIZE = 250;
%THRESH_SSD = 5;
%MAX_SSD_DIST = 10; % If dist is larger than this, it is not
                   % included in the error estimation.

width = ( max(X(:,1)) - min(X(:,1)) ); % / 2 
height = ( max(X(:,2)) - min(X(:,2)) ); %/ 2 
depth = ( max(X(:,3)) - min(X(:,3)) ); % / 2 

%iters_nonrigid__ = iters_nonrigid;

%MIN_WIDTH = 35; MIN_HEIGHT = 35; MIN_DEPTH = 35;

% YOU ONLY ADD AT THE SMALLEST LEVEL OF GRANULARITY
%while width > MIN_WIDTH && height > MIN_HEIGHT && depth > MIN_HEIGHT
    
    %width = width / 2
    %height = height / 2
    %depth = depth / 2
    
    [Y1,Y2,Y3] = registerPoints( X,Y,iters_rigid,iters_nonrigid );
    %for i=left:width:right-width
    %    for j=bottom:height:top-height
    %        for k=back:depth:front-depth
end    
 
function [X__,Y__,Z__] = registerPoints( X,Y,iters_rigid,iters_nonrigid )   
    MIN_SIZE = 500;
    if size(X,1) > MIN_SIZE && size(Y,1) > MIN_SIZE
       
        [Y1_,Y2_,Y3_] = registerToReferenceRangeScan(X, Y, iters_rigid, ...                                                iters_rigid,...
                                                           iters_nonrigid,...
                                                           1,...
                                                           1 );
        min_x = min( [ X(:,1);Y1_ ] )
        max_x = max( [ X(:,1);Y1_ ] )
        min_y = min( [ X(:,2);Y2_ ] )
        max_y = max( [ X(:,2);Y2_ ] )
        min_z = min( [ X(:,3);Y3_ ] )  
        max_z = max( [ X(:,3);Y3_ ] ) 
        pad = 0.2;
        
        left_x   = min_x %- pad*min_x%min(X(:,1)) - left_pad*min(X(:,1))
        right_x  = max_x %+ pad*max_x%max(X(:,1)) + right_pad*max(X(:,1))
        top_x    = max_y %+ pad*max_y%max(X(:,2)) + top_pad*max(X(:,2))
        bottom_x = min_y %- pad*min_y%min(X(:,2)) - bottom_pad*min(X(:,2))
        back_x   = min_z %- pad*min_z%min(X(:,3)) - back_pad*min(X(:,3))
        front_x  = max_z %+ pad*max_z%max(X(:,3)) + front_pad*max(X(:,3))
        
        % this use of X co-ords as the dividing space is on purpose
        left_y   =  min_x %min(X(:,1))
        right_y  = max_x %max(X(:,1))
        top_y    = max_y %max(X(:,2))
        bottom_y = min_y %min(X(:,2))
        back_y   = min_z %min(X(:,3))
        front_y  = max_z %max(X(:,3))       
        
        %width_x = (right_x - left_x)/2
        %height_x = 
        m_width  = left_x+((right_x-left_x)/2);
        m_height = bottom_x+((top_x-bottom_x)/2);
        m_depth = back_x+((front_x-back_x)/2 );
        
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

        idx_y_000 = find( Y1_ < m_width & Y2_ < m_height & Y3_ < m_depth );
        idx_y_001 = find( Y1_ < m_width & Y2_ < m_height & Y3_ >= m_depth );
        idx_y_010 = find( Y1_ < m_width & Y2_ >= m_height & Y3_ < m_depth );
        idx_y_011 = find( Y1_ < m_width & Y2_ >= m_height & Y3_ >= m_depth );
        idx_y_100 = find( Y1_ >= m_width & Y2_ < m_height & Y3_ < m_depth );
        idx_y_101 = find( Y1_ >= m_width & Y2_ < m_height & Y3_ >= m_depth );
        idx_y_110 = find( Y1_ >= m_width & Y2_ >= m_height & Y3_ < m_depth );
        idx_y_111 = find( Y1_ >= m_width & Y2_ >= m_height & Y3_ >= m_depth );
        
        [Y1_000,Y2_000,Y3_000] = registerPoints( X(idx_x_000,:),[Y1_(idx_y_000),Y2_(idx_y_000),Y3_(idx_y_000)],iters_rigid,iters_nonrigid );
        [Y1_001,Y2_001,Y3_001] = registerPoints( X(idx_x_001,:),[Y1_(idx_y_001),Y2_(idx_y_001),Y3_(idx_y_001)],iters_rigid,iters_nonrigid );
        [Y1_010,Y2_010,Y3_010] = registerPoints( X(idx_x_010,:),[Y1_(idx_y_010),Y2_(idx_y_010),Y3_(idx_y_010)],iters_rigid,iters_nonrigid );
        [Y1_011,Y2_011,Y3_011] = registerPoints( X(idx_x_011,:),[Y1_(idx_y_011),Y2_(idx_y_011),Y3_(idx_y_011)],iters_rigid,iters_nonrigid );
        [Y1_100,Y2_100,Y3_100] = registerPoints( X(idx_x_100,:),[Y1_(idx_y_100),Y2_(idx_y_100),Y3_(idx_y_100)],iters_rigid,iters_nonrigid );
        [Y1_101,Y2_101,Y3_101] = registerPoints( X(idx_x_101,:),[Y1_(idx_y_101),Y2_(idx_y_101),Y3_(idx_y_101)],iters_rigid,iters_nonrigid );
        [Y1_110,Y2_110,Y3_110] = registerPoints( X(idx_x_110,:),[Y1_(idx_y_110),Y2_(idx_y_110),Y3_(idx_y_110)],iters_rigid,iters_nonrigid );
        [Y1_111,Y2_111,Y3_111] = registerPoints( X(idx_x_111,:),[Y1_(idx_y_111),Y2_(idx_y_111),Y3_(idx_y_111)],iters_rigid,iters_nonrigid );

        X__ = [Y1_000; Y1_001 ; Y1_010 ; Y1_011 ; Y1_100 ; Y1_101 ; Y1_110 ; Y1_111 ]; 
        Y__ = [Y2_000; Y2_001 ; Y2_010 ; Y2_011 ; Y2_100 ; Y2_101 ; Y2_110 ; Y2_111 ];  
        Z__ = [Y3_000; Y3_001 ; Y3_010 ; Y3_011 ; Y3_100 ; Y3_101 ; Y3_110 ; Y3_111 ]; 
        %{
        idx_xlbb = find( X(:,1) <  & ...
                         X(:,2) <  & ...
                         X(:,3) < ;
        idx_xlbf = find( X(:,1) < left_x+(right_x-left_x)/2 & ...
                         X(:,2) < bottom_x+(top_x-bottom_x)/2 & ...
                         X(:,3) >= (front_x-back_x)/2 );                   
        idx_xltb = find( X(:,1) < (right_x-left_x)/2 & ...
                         X(:,2) >= bottom_x+(top_x-bottom_x)/2  & ...
                         X(:,3) < (front_x-back_x)/2 );                   
        idx_xltf = find( X(:,1) < (right_x-left_x)/2 & ...
                         X(:,2) >= (top_x-bottom_x)/2 & ...
                         X(:,3) >= (front_x-back_x)/2 );
                     
        idx_xrbb = find( X(:,1) >= (right_x-left_x)/2 & ...
                          X(:,2) < (top_x-bottom_x)/2 & ...
                          X(:,3) < (front_x-back_x)/2 );               
        idx_xrbf = find( X(:,1) > (right_x-left_x)/2 &  ...
                         X(:,2) < (top_x-bottom_x)/2 & ...
                         X(:,3) >= (front_x-back_x)/2 );                   
        idx_xrtb = find( X(:,1) >= (right_x-left_x)/2 & ...
                         X(:,2)  >=(top_x-bottom_x)/2 &...
                         X(:,3) < (front_x-back_x)/2 );                   
        idx_xrtf = find( X(:,1) >= (right_x-left_x)/2  & ...
                         X(:,2)  >= (top_x-bottom_x)/2 &...
                         X(:,3)  >= (front_x-back_x)/2 );             
                                      
        idx_ylbb = find( Y1_ < (right_y-left_y)/2 & ...
                         Y2_ < (top_y-bottom_y)/2 & ...
                         Y3_ < (front_y-back_y)/2 );
        idx_ylbf = find( Y1_ < (right_y-left_y)/2 & ...
                         Y2_ < (top_y-bottom_y)/2 & ...
                         Y3_ >= (front_y-back_y)/2 );                   
        idx_yltb = find( Y1_ < (right_y-left_y)/2 & ...
                         Y2_ >= (top_y-bottom_y)/2  &...
                         Y3_ < (front_y-back_y)/2 );                   
        idx_yltf = find( Y1_ < (right_y-left_y)/2 & ...
                         Y2_ >= (top_y-bottom_y)/2 &...
                         Y3_ >= (front_y-back_y)/2 );
                     
        idx_yrbb = find( Y1_ >= (right_y-left_y)/2  & ...
                         Y2_ < (top_y-bottom_y)/2 & ...
                         Y3_ < (front_y-back_y)/2 );               
        idx_yrbf = find( Y1_ >= (right_y-left_y)/2 & ...
                         Y2_ < (top_y-bottom_y)/2 & ...
                         Y3_ >= (front_y-back_y)/2 );                   
        idx_yrtb = find( Y1_ >= (right_y-left_y)/2 & ...
                         Y2_ >= (top_y-bottom_y)/2 &...
                         Y3_ < (front_y-back_y)/2 );                   
        idx_yrtf = find( Y1_ >= (right_y-left_y)/2 & ...
                         Y2_ >= (top_y-bottom_y)/2  &...
                         Y3_ >= (front_y-back_y)/2  );  
        [Y1lbb,Y2lbb,Y3lbb] = registerPoints( X(idx_xlbb,:),[Y1_(idx_ylbb),Y2_(idx_ylbb),Y3_(idx_ylbb)],iters_rigid,iters_nonrigid );
        [Y1lbf,Y2lbf,Y3lbf] = registerPoints( X(idx_xlbf,:),[Y1_(idx_ylbf),Y2_(idx_ylbf),Y3_(idx_ylbf)],iters_rigid,iters_nonrigid );
        [Y1ltb,Y2ltb,Y3ltb] = registerPoints( X(idx_xltb,:),[Y1_(idx_yltb),Y2_(idx_yltb),Y3_(idx_yltb)],iters_rigid,iters_nonrigid );
        [Y1ltf,Y2ltf,Y3ltf] = registerPoints( X(idx_xltf,:),[Y1_(idx_yltf),Y2_(idx_yltf),Y3_(idx_yltf)],iters_rigid,iters_nonrigid );
        [Y1rbb,Y2rbb,Y3rbb] = registerPoints( X(idx_xrbb,:),[Y1_(idx_yrbb),Y2_(idx_yrbb),Y3_(idx_yrbb)],iters_rigid,iters_nonrigid );
        [Y1rbf,Y2rbf,Y3rbf] = registerPoints( X(idx_xrbf,:),[Y1_(idx_yrbf),Y2_(idx_yrbf),Y3_(idx_yrbf)],iters_rigid,iters_nonrigid );
        [Y1rtb,Y2rtb,Y3rtb] = registerPoints( X(idx_xrtb,:),[Y1_(idx_yrtb),Y2_(idx_yrtb),Y3_(idx_yrtb)],iters_rigid,iters_nonrigid );
        [Y1rtf,Y2rtf,Y3rtf] = registerPoints( X(idx_xrtf,:),[Y1_(idx_yrtf),Y2_(idx_yrtf),Y3_(idx_yrtf)],iters_rigid,iters_nonrigid );

        X__ = [Y1lbb; Y1lbf ; Y1ltb ; Y1ltf ; Y1rbb ; Y1rbf ; Y1rtb ; Y1rtf ];
        Y__ = [Y2lbb; Y2lbf ; Y2ltb ; Y2ltf ; Y2rbb ; Y2rbf ; Y2rtb ; Y2rtf ];
        Z__ = [Y3lbb; Y3lbf ; Y3ltb ; Y3ltf ; Y3rbb ; Y3rbf ; Y3rtb ; Y3rtf ];
        %}
    else
        X__ = Y(:,1);
        Y__ = Y(:,2);
        Z__ = Y(:,3);
    end

end

%{
        idx_y_lf = find( Y1_ >= left    & Y1_ < left+((right-left)/2) & ...
                       Y2_ >= bottom  & Y2_ < bottom+((top-bottom)/2) & ...
                       Y3_ >= back+((front-back)/2))    & Y3_ < front ;
        idx_y_lb = find( Y1_(:,1) >= left    & Y1_(:,1) < left+((right-left)/2) & ...
                       Y2_(:,2) >= bottom    & Y2_(:,2) < top+((top-bottom)/2) & ...
                       Y3_(:,3) >= back      & Y3_(:,3) < back+((front-back)/2) );           
        idx_x_r = find( X(:,1) >= left+((right-left)/2)  & X(:,1) <= right & ...
                       X(:,2) >= bottom+((top-bottom)/2)  & X(:,2) <= top & ...
                       X(:,3) >= back+((front-back)/2)  & X(:,3) < front );
        idx_yr = find( Y1_ >= left+((right-left)/2)  & Y1_ < right & ...
                       Y2_ >= bottom+((top-bottom)/2)  & Y2_ < top & ...
                       Y3_ >= back+((front-back)/2)  & Y3_ < front );   
%}