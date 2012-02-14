addpath('mahalanobis');
fid = fopen( '~/Data/bunny/reconstruction/bun_zipper_stripped.ply', 'r' );


A = fscanf( fid, '%f %f %f %f %f\n', [5 inf] );
x_in = A(1,:);
y_in = A(2,:);
z_in = A(3,:);


[x,y,z] = addNoisyPoints( x_in,y_in,z_in,size(x_in,2)*2 );

x = x';
y = y';
z = z';

full_set = [1:size(x,1)];
sub_set =  [1:100,37000:37100];

SET = full_set;

radius = 0.000007;
h_x = 1;
empty_count = 0;
f = zeros(size(x));
for i = SET
    idx = neighborsWithinRadius( [x y z], [x(i) y(i) z(i)], radius );
    if size(idx) < 5
        empty_count =  empty_count+1
        f(i) = -1;
    else        
            X = [x(idx(2:end))  y(idx(2:end)) z(idx(2:end))]';
            Y = [x(i) y(i) z(i)]';
            dist_mat = cvMahaldist(Y,X);
            f(i) = sum( exp( -.5*dist_mat / h_x ) ) / size(idx,1);
            %if isnan(dist_mat(i))
            %    sprintf( 'isnan %d', i )
            %    error( 'isnan %d', i)
                %dist_m(i) = -5;
            %    f(i) = -5;
            %end
   end
    if mod(i,100)==0, sprintf( '%f completed', i/size(x,1)*100), end
end


% now check detection algorithm
detection_reference = zeros(size(f));
detection_reference(size(x,1):end) = 1;
%detection_reference(1:freq:end) = 1;

thresh_max = max( f .* detection_reference );

roc_x = [];
roc_y = [];
true_positive_detect = 1;
while true_positive_detect > 0
    detection_result = f < thresh_max;
    thresh_max = thresh_max - 0.001; %10000000000;
    
    actual_normal_class = ~detection_reference;
    actual_outlier_class = detection_reference;
    
    
    
    true_positive_detect =  sum( detection_reference == 1 & detection_result == 1 );
    false_negative_detect = sum( detection_reference == 1 & detection_result == 0 );   
    
    false_positive_detect =  sum( detection_reference == 0 & detection_result == 1 );
    true_negative_detect  =  sum( detection_reference == 0 & detection_result == 0 );
    
    detect_rate = true_positive_detect / (true_positive_detect + false_negative_detect );
    false_alarm_rate = false_positive_detect / ( false_positive_detect + true_negative_detect );
    roc_x = [roc_x detect_rate];
    roc_y = [roc_y false_alarm_rate];
end
