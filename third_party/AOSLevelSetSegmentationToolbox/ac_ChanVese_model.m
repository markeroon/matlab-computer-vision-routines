function phi = ac_ChanVese_model(I, phi, smooth_weight, image_weight, ...
    delta_t, n_iters, show_result)
% FUNCTION U = AC_CHANVESE_MODEL(I, U, SMOOTH_WEIGHT, IMAGE_WEIGHT, ...
%     DELTA_T, N_ITERS, SHOW_RESULT)
% AOS solver for Chan-Vese model. 
%   Inputs:
%       I --- Input image (2D/3D). 
%       U --- Initial level set.
%       SMOOTH_WEIGHT --- Weight for the smooth term.
%       IMAGE_WEIGHT --- Weight for the image term.
%       DELTA_T --- Time step for each iteration (default value 1).
%       N_ITERS --- Maximum number of iterations (default value 50).
%       SHOW_RESULT --- 1 for showing the results after each iteration
%       (only for 2D image) (default value 0).
%   Output:
%       U --- resulting level set after DELTA_T*N_ITERS.
%
% Example:
%     I = rgb2gray(imread('europe_night.jpg')); 
%     phi = ac_SDF_2D('rectangle', size(I), 10) ;
%     smooth_weight = 3; image_weight = 1e-3; 
%     delta_t = 2; n_iters = 100; show_result = 1; 
%     phi = ac_ChanVese_model(double(I), phi, smooth_weight, image_weight, ...
%         delta_t, n_iters, show_result); 
%
% See also:
%      ac_GAC_model, ac_hybrid_model
%
% Reference:
%   T. F. Chan and L. A. Vese. Active contours without edges. IEEE Transaction 
%       on Image Processing, 10(2):266-277, 2001.

%%
if nargin < 5 || isempty(delta_t)
    delta_t = 1; 
end

if nargin < 6 || isempty(n_iters)
    n_iters = 50; 
end

if nargin < 7 || isempty(show_result)
    show_result = 0; 
end

% Displaying of evolution process only works for 2D image.
if ndims(I) ~= 2 
    show_result = 0; 
end

%%
for i = 1:n_iters
    phi_old = phi; 
    
    mu_in = mean(I(phi>=0)); 
    mu_out = mean(I(phi<0)); 
    
    phi = ac_reinit(phi); 
    phi = phi + delta_t*image_weight*((I-mu_out).^2 - (I-mu_in).^2); 
    phi = ac_reinit(phi); 
    phi = ac_laplacian_AOS(phi, delta_t*smooth_weight, 1); 
    
    % Show evolution process.
    if show_result
        if i == 1
            figure, imshow(I,[]); hold on;  
        end
        c = contours(phi,[0,0]); 
        if isempty(c), break; end
        if exist('h','var') && all(ishandle(h)), delete(h); end; 
        h = zy_plot_contours(c,'linewidth',2); 
        set(gcf,'name',sprintf('#iters = %d',i)); 
        drawnow;
    end
    
    % Terminate the process if no more evolution.
    if isequal(phi > 0, phi_old > 0), break; end
end
