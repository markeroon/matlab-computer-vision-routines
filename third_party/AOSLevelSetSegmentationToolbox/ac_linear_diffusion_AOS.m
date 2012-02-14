function phi = ac_linear_diffusion_AOS(phi, delta_t, n_iters)
% U = AC_LINEAR_DIFFUSION_AOS(U, DELTA_T, N_ITERS)
% Linear diffusion (Laplacian) on 2D/3D image/levelset. 
%   Inputs:
%       U --- Initial data in the PDE.
%       DELTA_T --- Time step for the linear diffusion.
%       N_ITERS --- Number of iterations (default value 1).
%   Output:
%       U --- Resulting data after time delta_t*n_iters.
%
% Example (2D):
%     I = double(imread('circuit.tif')); 
%     delta_t = 2; 
%     for i = 1:50        
%         if i == 1 
%             figure; subplot(121), imshow(I,[]);             
%         end
%         subplot(122), imshow(I,[]); 
%         set(gcf,'name',sprintf('#iters = %d',i)); drawnow; 
%         
%         I = ac_linear_diffusion_AOS(I, delta_t);               
%     end
%
% Example (3D) 1: 
%   A = randn(100,100,100); 
%   g = ones(size(A)); 
%   tic; A1 = ac_linear_diffusion_AOS(A, delta_t); toc; 
%   tic; A2 = ac_div_AOS(A, g, delta_t); toc; 
%   max(abs(A1(:)-A2(:)))
%
% Example (3D) 2:    
%     A = randn(40,40,40); delta_t = 1; 
%     for i = 1:50        
%         A = ac_linear_diffusion_AOS(A, delta_t);
%         if exist('h','var') && all(ishandle(h)), delete(h); end
%         iso = isosurface(A); 
%         h = patch(iso,'facecolor','w');  view(3); axis equal; 
%         set(gcf,'name',sprintf('#iteration = %d',i)); drawnow; 
%     end

if nargin < 3 
    n_iters = 1; 
end

n_dims = ndims(phi);
if n_dims == 2
    for i = 1:n_iters
        phi = ac_linear_diffusion_AOS_2D_dll(phi,  delta_t);
    end
elseif n_dims == 3
    for i = 1:n_iters
        phi = ac_linear_diffusion_AOS_3D_dll(phi,  delta_t);
    end
else
    error('This function can be only applied to 2D or 3D data.');
end