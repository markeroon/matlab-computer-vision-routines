function K = ac_gaussian_kernel(dims, C)
% FUNCTION K = AC_GAUSSIAN_KERNEL(DIMS, C)
% Generate N dimensional guassian kernel.
%   Inputs:
%       DIMS --- Vector specifying the dimesion of kernel (can be scalar if all
%           dimensions are the same).
%       C --- Convariance matrix.
%   Output: 
%       K --- N-D Gaussian kernel. 
% 
% Example:
%     % 1D Gaussian kernel
%     K = ac_gaussian_kernel(100, 10^2);
%     figure, plot(K);
%     % 2D Gaussian kernel
%     dims = [100,120];
%     variance = 30^2;
%     K = ac_gaussian_kernel(dims, variance*eye(2));
%     KK = fspecial('gaussian', 2*dims+1, sqrt(variance));
%     max(abs(K(:)-KK(:)))
%     figure, mesh(K);
%     % 3D Gaussian kernel
%     dims = [20,20,20]; 
%     K = ac_gaussian_kernel(dims, diag([16,25,36].^2)); 
%     figure,patch(isosurface(K, 2e-5),'edgecolor','k','facecolor','w');
%     view(3); axis equal; 

N = size(C,1); 

if isscalar(dims)
    dims = dims*ones(1,N); 
end

idx = cell(1,length(dims)); 
for i = 1:length(dims)
    idx{i} = -dims(i):dims(i); 
end

out_str = 'X1'; 
for i = 2:length(dims)
    out_str = [out_str, sprintf(',X%s', num2str(i))]; 
end

cmd = sprintf('[%s] = ndgrid(idx{:});',out_str); 
eval(cmd);

%% generate X here
out_str = 'X1(:)'; 
for i = 2:length(dims)
    out_str = [out_str, sprintf(',X%s(:)',num2str(i))]; 
end
cmd = sprintf('X = [%s];', out_str); 
eval(cmd); 

%% Calculate the kernel. 
C_inv = inv(C); 
if N == 1
    K = zeros(1, 2*dims+1); 
else
    K = zeros(2*dims+1); 
end
for i = 1:prod(2*dims+1)
    XX = X(i,:);
    K(i) = XX*C_inv*XX'; 
end
K = exp(-K/2); 
K = K./sum(K(:)); 
