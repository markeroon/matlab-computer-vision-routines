function phi = ac_div_AOS(phi, varargin)
% FUNCTION U = AC_DIV_AOS(U, G, DELTA_T, N_ITERS)
% AOS solver for PDE u_t = div(g \nabla u). 
%   Inputs:
%       U --- Initial levelset in the PDE.
%       G --- g in the PDE.
%       DELTA_T --- Time step for the AOS scheme.
%       N_ITERS --- Number of iterations (default value 1).
%   Output:
%       U --- Resulting levelset after time delta_t*n_iters.
%
% Example: (nonlinear diffusion)
%     I = double(imread('trees.tif'));
%     I = I + 10*randn(size(I)); 
%     g = ac_gradient_map(I,1);
%     delta_t = 5; 
%     figure; subplot(121); imshow(I,[]);
%     for i = 1:50
%         I = ac_div_AOS(I, g, delta_t);
%         
%         subplot(122); imshow(I,[]); drawnow;
%         set(gcf,'name',sprintf('#iters = %d',i));
%     end
%
% Reference:
%  J. Weickert, B. M. H. Romeny and M. A. Viergever. Efficient and reliable
%  schemes for nonlinear diffusion filtering. IEEE Transactions on Image
%  Processing 7(3):398-410, 1998.

switch ndims(phi)
    case 1
        phi = ac_div_AOS_1D(phi, varargin{:});
    case 2
        phi = ac_div_AOS_2D(phi, varargin{:});
    case 3
        phi = ac_div_AOS_3D(phi, varargin{:});
    otherwise
        error('%s only works for 1D-3D data.',mfilename()); 
end
    

