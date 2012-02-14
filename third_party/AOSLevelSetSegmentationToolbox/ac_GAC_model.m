function phi = ac_GAC_model(g, phi, countour_weight, expansion_weight, ...
    delta_t, n_iters, show_result)
% FUNCTION U = AC_GAC_MODEL(G, U, COUNTOUR_WEIGHT, EXPANSION_WEIGHT, ...
%    DELTA_T, N_ITERS, SHOW_RESULT)
% AOS solver for geodesic active contour (GAC) model. The GAC PDE is
% u_t = \alpha * div(g \nabla u / |\nabla u|)|\nabla u| + \beta g |\nabla u|.
%   Inputs:
%       G --- Gradeint map. 
%       U --- Initial level set.
%       COUNTOUR_WEIGHT --- \alpha in the PDE.
%       EXPANSION_WEIGHT --- \beta in the PDE.
%       DELTA_T --- Time step for each iteration (default value 1).
%       N_ITERS --- Maximum number of iterations (default value 50).
%       SHOW_RESULT --- 1 for showing the results after each iteration
%       (only for 2D image) (default value 0).
%   Output:
%       U --- resulting level set after DELTA_T*N_ITERS.
%
% Example:
%     I = double(imread('coins.png')); 
%     g = ac_gradient_map(I, 5); 
%     phi = ac_SDF_2D('rectangle', size(I), 5) ;
%     countour_weight = 3; expansion_weight = -1; 
%     delta_t = 5; n_iters = 100; show_result = 1; 
%     phi = ac_GAC_model(g, phi, countour_weight, expansion_weight, ...
%         delta_t, n_iters, show_result); 
% See also:
%      ac_ChanVese_model, ac_hybrid_model
%
% Reference:
%   V. Caselles, R. Kimmel and G. Sapiro. Geodesic Active Contours. IJCV
%       22(1):61-79, 1997.

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
if ndims(g) ~= 2 
    show_result = 0; 
end

%%
for i = 1:n_iters
    phi_old = phi;
    
    phi = ac_reinit(phi);
    phi = ac_div_AOS(phi, g, delta_t*countour_weight);
    phi = ac_reinit(phi); 
    phi = phi + delta_t*expansion_weight*g; 
    
    % Show evolution process. 
    if show_result
        if i == 1
            figure, imshow(g,[]); hold on;  
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
