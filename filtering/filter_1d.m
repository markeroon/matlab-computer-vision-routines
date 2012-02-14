addpath( '~/Code/PointCloudGenerator/' );
addpath( '~/Code/filtering/mahalanobis/' );

clear
dx = 0.005;
dy = 0.005;
%x = [-2*pi:dx:2*pi];
x = [-2*pi:dx:-1.5*pi];
num_signal_points = size(x,2);
x = x';
y = sin( x );
N = 8 * size(y,1);
[x_corrupt,y_corrupt] = addNoisyPoints2D( x',y',N,dx,dy );

x = x_corrupt';
y = y_corrupt';

n = 3;%25;
radius = .01;
f = zeros(size(y,1),1);
f_fixed = zeros(size(y,1),1);
h = 0.7;
%h_fixed = 0.01;


k_rd = 10;
%keep in mind that returns 2-k nearest neighbors (so one less than k)
%for j = [1:50,3700:3750]
%{
for j = 1:size(y,1)
    [f(j),f_fixed_h(j),f_no_denom(j)] = ...
        kernel_density_estimate_within_radius( [x y],j,radius,n,h,h_fixed );
end
%}
for j = ...%[1:50,3700:3750]
    1:size(y,1)
    [f(j),f_fixed(j)] = kernel_density( [x y],j,radius,h,n );
end

threshold = median( f_fixed );
plotInliersVsOutliers( x,y,f,num_signal_points,threshold );