function phi = ac_hybrid_model(P, phi, propagation_weight, GAC_weight, g, ...
    delta_t, n_iters, show_result)
% FUNCTION U = AC_HYBRID_MODEL(P, U, PROPAGATION_WEIGHT, GAC_WEIGHT, G, ...
%     DELTA_T, N_ITERS, SHOW_RESULT)
% The hybrid method combining both boundary and regional terms. PDE for
% this model is u_t = \alpha * P * |\nabla u| + \beta *  div(g \nabla u /
% |\nabla u|)|\nabla u|.
%   Inputs:
%       P --- Propagation field indicating the magnitues and directions of 
%           evolving curves. Positive value for expansion and negative for
%           contraction. 
%       U --- Initial level set.
%       PROPAGATION_WEIGHT --- \alpha in the PDE.
%       GAC_WEIGHT --- \beta in the PDE.
%       G --- Gradient map related to GAC. (default value 1 for curvature
%           flow)
%       DELTA_T --- Time step for each iteration (default value 1).
%       N_ITERS --- Maximum number of iterations (default value 50).
%       SHOW_RESULT --- 1 for showing the results after each iteration
%       (only for 2D image) (default value 0).
%   Output:
%       U --- resulting level set after DELTA_T*N_ITERS.
% 
% Example:
%     I = double(imread('coins.png')); 
%     phi = ac_SDF_2D('circle', size(I),[size(I,2)/2,size(I,1)/2],size(I,1)/2.5);
%     g = ac_gradient_map(I, 5); 
%     mu = 100; propagation_weight = .05; GAC_weight = 1; 
%     delta_t = 1; n_iters = 100; show_result = 1; 
%     phi = ac_hybrid_model(I-mu, phi, propagation_weight, GAC_weight, g, ...
%       delta_t, n_iters, show_result);
%
% See also:
%      ac_GAC_model, ac_ChanVese_model
%
% Referecne:
%   Y. Zhang, B. J. Matuszewski, L.-K. Shark, C. J. Moore, Medical Image
%       Segmentation Using New Hybrid Level-Set Method. IEEE International 
%       Conference on Biomedical Visualisation, MEDi08VIS, London, pp.71-76,
%       July, 2008.
%%
if nargin < 5 || isempty(g);
    g = 1; 
end

if nargin < 6 || isempty(delta_t)
    delta_t = 1; 
end

if nargin < 7 || isempty(n_iters)
    n_iters = 50; 
end

if nargin < 8 || isempty(show_result)
    show_result = 0; 
end

% Displaying of evolution process only works for 2D image.
if ndims(P) ~= 2 
    show_result = 0; 
end

%%
for i = 1:n_iters
    phi_old = phi; 

    phi = ac_reinit(phi);
    phi = phi + delta_t*propagation_weight*P;
    if GAC_weight
        phi = ac_reinit(phi);
        if isscalar(g)
            phi = ac_linear_diffusion_AOS(phi, delta_t*GAC_weight*g); 
        else
            phi = ac_div_AOS(phi, g, delta_t*GAC_weight);
        end
    end
 
    % Show evolution process.
    if show_result
        if i == 1
            figure, imshow(P,[]); hold on;  
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