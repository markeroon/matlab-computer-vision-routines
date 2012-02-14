%%
clear all; close all; clc
load head_ct; %V; 

%%
propagation_weight = 1e-3; 
GAC_weight = .02; 
% g = ones(size(V)); % linear diffusion 
g = ac_gradient_map(V,1); 
delta_t = 4; 
mu = 1200; 

margin = 4; 
center = [66, 47, 25]; 
phi = zeros(size(V)); 
phi(center(1)-margin:center(1)+margin,...
    center(2)-margin:center(2)+margin,...
    center(3)-margin:center(3)+margin) = 1; 
%%
for i = 1:10    
    phi = ac_hybrid_model(V-mu, phi-.5, propagation_weight, GAC_weight, g, ...
        delta_t, 1); 
    if exist('h','var') && all(ishandle(h)), delete(h); end
    iso = isosurface(phi,0);
    h = patch(iso,'edgecolor','r','facecolor','w');  axis equal;  view(3); 
    set(gcf,'name', sprintf('#iters = %d',i));
    drawnow; 
end

%%
figure;
slice = [10,15,20,25,30,35,40,45];
for i = 1:8
    subplot(2,4,i); imshow(V(:,:,slice(i)),[]); hold on; 
    c = contours(phi(:,:,slice(i)),[0,0]);
    zy_plot_contours(c,'linewidth',2);
end