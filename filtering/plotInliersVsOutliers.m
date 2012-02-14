% PLOTINLIERSVSOUTLIERS More intuitive display of inliers vs outliers
% f is the estimate of kernel density at each point p=(x,y)
% outliers are concatenated onto the end of the original signal, so 
% outlier_start_point
function [] = plotInliersVsOutliers( x,y,f,outlier_start_point,threshold )
    figure;
    hold on;
    idx_inliers_exp = find( f > threshold );
    idx_inliers_ref = 1:outlier_start_point;
    
    idx_outliers_exp = find( f < threshold );
    idx_outliers_ref = outlier_start_point:size(x,1); 
    
    idx_in = intersect(idx_inliers_exp,idx_inliers_ref);
    idx_out = intersect(idx_outliers_exp,idx_outliers_ref);
    
    idx_true_neg   = intersect(idx_inliers_exp,idx_outliers_ref); 
    %idx_false_pos  = intersect(idx_outliers_exp,idx_inliers_ref);
    
    plot( x(idx_in),y(idx_in),'og','markersize',2 );
    %plot( x(idx_out),y(idx_out),'ob','markersize',4 );
    plot( x(idx_true_neg),y(idx_true_neg),'or','markersize',2);
    %plot( x(idx_false_pos),y(idx_false_pos),'oy','markersize',4);
end