function u = ac_laplacian_AOS(u, delta_t, n_iters)
% FUNCTION U = AC_LAPLACIAN_AOS(U, DELTA_T, N_ITERS)
% AOS solver for linear diffusion u_t = \delta u.
%   Inputs:
%       U --- Initial data.
%       DELTA_T --- Time step for each iteration.
%       N_ITERS --- Number of iterations. (default value 1)
%   Output:
%       U --- Resulting data.
%
% Example:
%     I = double(imread('circuit.tif')); 
%     delta_t = 2; 
%     for i = 1:50        
%         if i == 1 
%             figure; subplot(121), imshow(I,[]);             
%         end
%         subplot(122), imshow(I,[]); 
%         set(gcf,'name',sprintf('#iters = %d',i)); drawnow; 
%         
%         I = ac_laplacian_AOS(I, delta_t);               
%     end

%%
if ~strcmp(class(u),'double')
    u = double(u); 
end

if nargin < 3 || isempty(n_iters)
    n_iters = 1; 
end

g = ones(size(u)); 
u = ac_div_AOS(u, g, delta_t, n_iters); 