%%
clear all; close all; clc
load head_ct; %V; 

%%
smooth_weight = 1; 
image_weight = 1e-6; 
delta_t = 4; 

margin = 10; 
phi = zeros(size(V)); 
phi(margin:end-margin, margin:end-margin, margin:end-margin) = 1; 
phi = ac_reinit(phi-.5); 

%%
for i = 1:10
    phi = ac_ChanVese_model(V, phi, smooth_weight, image_weight, delta_t, 1); 
    
    if exist('h','var') && all(ishandle(h)), delete(h); end
    iso = isosurface(phi);
    h = patch(iso,'facecolor','w');  axis equal;  view(3); 
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