function [X_sub,Y_sub] = getTopLeft( X,Y )
left = min( [ X(:,1); Y(:,1) ] );
right = max( [ X(:,1); Y(:,1) ] );
bottom = min( [ X(:,2); Y(:,2) ] );
top = max( [ X(:,2); Y(:,2) ] );
back = min( [ X(:,3); Y(:,3) ] ); 
front = max( [ X(:,3); Y(:,3) ] ); 
       
m_width  = left+((right-left)/2);
m_height = bottom+((top-bottom)/2);
m_depth = back+((front-back)/2 );

Y1_ = Y(:,1);
Y2_ = Y(:,2);
Y3_ = Y(:,3);
X1_ = X(:,1);
X2_ = X(:,2);
X3_ = X(:,3);

k = 10;
idx_x_000 = find( X1_ < m_width & X2_ < m_height & X3_ < m_depth );
idx_y_000 = find( Y1_ < m_width & Y2_ < m_height & Y3_ < m_depth );

X_sub = X(idx_x_000,:);
Y_sub = Y(idx_y_000,:);
end