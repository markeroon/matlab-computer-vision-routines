function u = ac_curvature_flow_AOS(u, delta_t, n_iters)
% FUNCTION U = AC_CURVATURE_FLOW_AOS(U, DELTA_T, N_ITERS)
% Implicit curve evolution according to curvature flow. PDE for curvature  
% flow is u_t = div( \nabla u / |\nabla u| ).
%   Inputs:
%       U --- Initial levelset in the PDE.
%       DELTA_T --- time step for the AOS scheme.
%       N_ITERS --- Number of iterations (default value 1).
%   Output:
%       U --- Resulting levelset after time DELTA_T*N_ITERS.
%
% Example:
%     I = imread('shou.jpg'); 
%     phi = (rgb2gray(I) < 100) - .5;     
%     delta_t = 5; 
%     for i = 1:50
%         phi = ac_curvature_flow_AOS(phi, delta_t); 
%         
%         if i == 1
%             figure, imshow(phi); hold on; 
%         end
%         c = contour(phi, [0,0]); 
%         if exist('h','var') && all(ishandle(h)), delete(h); end
%         h = zy_plot_contours(c,'linewidth',2); 
%         set(gcf,'name',sprintf('#iters = %d',i)); 
%         drawnow; 
%     end   


%%
if ~strcmp(class(u),'double')
    u = double(u);
end

if nargin < 3 || isempty(n_iters)
    n_iters = 1;
end

%%
for i = 1:n_iters
    u = ac_reinit(u);
    u = ac_laplacian_AOS(u, delta_t);
end