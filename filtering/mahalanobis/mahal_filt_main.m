clear
x = [-2*pi:0.01:2*pi];
x = x';
y = sin( x );
figure;
plot(x,y,'go' );
axis( [-8 8 -2 2] )
% standard deviation .00002
noisy_signal = y + 0.4*randn(size(x));
y( 1:10:end ) = noisy_signal(1:10:end);
figure;
plot(x,y,'bo' )

axis( [-8 8 -2 2] )
radius = .1;

empty_count = 0;
dist_m = zeros(size(x));
for i=1:size(x,1)
    idx = neighborsWithinRadius( [x y], [x(i) y(i)], radius );
    if size(idx) == 1 & idx == i
        empty_count = empty_count+1;
        dist_m(i) = -1;
    else
            X = [x(idx(2:end))  y(idx(2:end))]';
            Y = [x(i) y(i)]';
            dist_mat = cvMahaldist(X, Y);
            gaussian_dist_mat = exp(-.5*dist_mat );
            dist_m(i) = sum( gaussian_dist_mat ) / size(dist_mat,1);
            if isnan(dist_m(i))
                sprintf( 'isnan %d', i )
                dist_m(i) = -5;
            end
    end
end
in_idx = find( dist_m > .57);
out_idx = find( dist_m <= 0.57 );
figure;
plot( x(in_idx),y(in_idx), 'og')
axis( [-8 8 -2 2] )

figure;
plot( x(out_idx),y(out_idx),'or' );
axis( [-8 8 -2 2] )
axis( [-8 8 -2 2] )
axis( [-8 8 -2 2] )
axis( [-8 8 -2 2] )