function [M, I] = ac_gradient_map(I, alpha, type, ...
    gaussian_kernel_dims, gaussian_kernel_cov, convn_shape)
% FUNCTION [M, IS] = AC_GRADIENT_MAP(I, ALPHA, TYPE, ...
%     GAUSSIAN_KERNEL_DIMS, GAUSSIAN_KERNEL_COV, CONVN_SHAPE)
% Generate the regularized gradient map used for geodesic active contour 
% and nonlinear diffusion. Can be applied to N-D data. 
%   Inputs:
%      I --- N-D Input data.
%      ALPHA --- Parameter controlling the decreasing function. (default value 1) 
%      TYPE --- Decreasing function type. (0 for f(x) = 1/(1+alpha*x^2) and
%           nonzero for f(x) = exp(-alpha*x^2).) (default value 0)
%      GAUSSIAN_KERNEL_DIMS --- Dimensionalilty of the Guassian kernel.
%           (default value 2*ones(1,N))
%      GAUSSIAN_KERNEL_COV --- Convariance matrix of the Gaussian kernel.
%           (default value eye(N))
%      CONVN_SHAPE --- Can be 'valid', 'same' or 'full'. See the help of
%           Matlab function CONVN for details. (default value 'same')
%   Outputs:
%       M --- Gradient map.
%       IS --- Smoothed (regularized) input data.
%
% Example:
%     I = double(imread('trees.tif'));
%     [M, Is] = ac_gradient_map(I);
%     figure; 
%     subplot(1,3,1); imshow(I,[]); title('original'); 
%     subplot(1,3,2); imshow(Is,[]); title('smoothed'); 
%     subplot(1,3,3); imshow(M,[]); title('gradient map'); 
%
% See also
%     ac_gaussian_kernel


n_dims = ndims(I); % dimensionality of the input data.

if nargin < 2 || isempty(alpha)
    alpha = 1; 
end

if nargin < 3 || isempty(type) 
    type = 0; 
end

if nargin < 4 || isempty(gaussian_kernel_dims)
    gaussian_kernel_dims = 2*ones(1,n_dims); 
end

if nargin < 5 || isempty(gaussian_kernel_cov)
    gaussian_kernel_cov = eye(n_dims); 
end

if nargin < 6 || isempty(convn_shape)
    convn_shape = 'same'; 
end

%%
% Smooth the input image by Gaussian kernel; 
if gaussian_kernel_dims ~= 0 % Only do the smoothing when kernel size not equal 0. 
    kernel = ac_gaussian_kernel(gaussian_kernel_dims, gaussian_kernel_cov); 
    if n_dims == 2 % conv2 uses fft which much faster than convn doing convolution directly
        I = conv2(I, kernel, convn_shape); 
    else
        I = convn(I, kernel, convn_shape);
    end
end

%% Work out the gradient of the smooth image. 
G = cell(1, n_dims);
[G{:}] = gradient(I); 

%% Work out the squared gradient magnitue.
M = zeros(size(I)); 
for i = 1:n_dims
    M = M + G{i}.^2; 
end

switch(type)
    case 0
        M = 1./(1 + alpha*M); 
    case 1
        M = exp(-alpha*M); 
end