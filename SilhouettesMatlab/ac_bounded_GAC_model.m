% FUNCTION U = AC_GAC_MODEL(G, U, COUNTOUR_WEIGHT, EXPANSION_WEIGHT, ...
%    DELTA_T, N_ITERS, SHOW_RESULT)
% AOS solver for geodesic active contour (GAC) model. The GAC PDE is
% u_t = \alpha * div(g \nabla u / |\nabla u|)|\nabla u| + \beta g |\nabla u|.

function phi = ac_bounded_GAC_model(g, phi, countour_weight, expansion_weight, ...
    delta_t, n_iters, show_result)
    
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
    phi = phi + delta_t*expansion_weight*min(g,w_max); 
    
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