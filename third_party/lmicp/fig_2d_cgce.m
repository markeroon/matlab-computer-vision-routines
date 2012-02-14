% function fig_2d_cgce()

% FIG_2D_CGCE   A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Sep 01

NoiseLevel = .01;

alltheta = 20; % [-120:10:120];
errs = zeros(size(alltheta));
iters = zeros(size(alltheta));
allparams = zeros(length(alltheta), 3);
for k=1:length(alltheta)
  theta = alltheta(k) * pi/180;
  R = [cos(theta) sin(theta); -sin(theta) cos(theta)];
  
  %model = cx(10:end-20,:);
  model = cx(1:end,:);
  data0 = cx2(40:end-50,:);
  
  figure(1);
  % add noise
  data = data0 + randn(size(data)) * NoiseLevel;
  
  % transform
  centroid = mean(data);
  T = ([1 10 ] + centroid) * R - centroid;
  data = icp_transrot(data, R, T);

  % translate data to model mean
  t = mean(model) - mean(data) ;
  data = icp_transrot(data, 0, t);
  p = [0 t];

  % minimize
  m_estimator = 'ls';
  m_estimator_param = 15;
  switch 3
  case 1
    [newdata, params, final_err, final_iters] = ...
	icp_lmfit(x, model, data, m_estimator);
  case 2
    [newdata, params, final_err, final_iters] = ...
	icp_2dbasic(x, model, data);
  case 3
    [newdata, params, final_err, final_iters] = ...
	icp_2d_lm(x, model, data, m_estimator, m_estimator_param, 0);
  end
  
  errs(k) = final_err;
  iters(k) = final_iters;
  allparams(k,:) = params(:)';
  
  [Rmin, tmin] = icp_deparam(params);
  newdata = icp_transrot(data, Rmin, tmin);
  
  mean(newdata)
  
  figure(1)
  hold off
  set(scatter(x, 'k-'), 'color', [1 1 1]*.5);
  hold on
  h1 = scatter(model, 'b*');

  set(h1, 'markersize', 2);
  axis ij
  axis equal
  awf_axissurround(model, 1.5);
  axis off
  h2 = scatter(newdata, 'ro');
  set(h2, 'markersize', 2);
  h3 = scatter(data, 'r.');
  set(h3, 'markersize', 8);

  legend([h1 h3 h2], 'model', 'start', 'end')
  set(gcf, 'color', [1 1 1])
  
%  print -depsc /awf/doc/papers/icp/fig_2d_cgce_lorentz_m40.eps
end
