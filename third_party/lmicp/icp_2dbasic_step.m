function [newdata, params, final_err, count] = ...
    icp_2dbasic_step(x, model, data, THRESH, GX)

% TEST1         A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 04 Apr 01

if GX
  hold off
  scatter(x,'k-');
  hold on
  axis ij
  if size(model, 1) < 1000
    plot(model(:,1), model(:,2), 'ro')
    plot(model(:,1), model(:,2), 'r-')
  else
    plot(model(:,1), model(:,2), 'r.')
  end

  awf_axissurround(model, 2);

  h = scatter(data, 'bo');
end

if GX == 2
  icp_thicken(findobj('type', 'line'));
  axis([-1 3 -1 2])
  drawnow;

  fn = sprintf('icp2dbasic.%03d.png', 0);
  icp_pngprint(fn);
end

mx = model(:,1);
my = model(:,2);

delstruct = awf_delaunay_4srch(mx, my);

ndata = size(data,1);

origdata = data;

params = [0 0 0];

count=0;
if GX
  oh = plot(nan);
end
allR = eye(2);
allt = [0 0]';
while 1
  count=count+1;
  
  % Find closest pts on model
  for i=1:ndata
    k = awf_delaunay_closest_pt(delstruct, data(i,1), data(i,2));
    cp(i,:) = model(k,:);
  end
  
  % Reject outliers
  dists = sqrt(sum((cp - data)'.^2));
  inliers = find(dists < THRESH);
  
%  delete(oh);
%  oh = draw_line(data(inliers,:), cp(inliers,:), 'b-');

  % Solve for transformation
  [R, t] = homgsolve_euclid2d(data(inliers,:), cp(inliers,:));

  [Rp, tp] = icp_deparam(icp_param(R, t));
  params = icp_compose_params2(icp_param(R, t), params);

  % transformed_data = data * R' + ones(ndata,1) * t';
  transformed_data = awf_transform_pts(data, R, t);
  
  err = (transformed_data - data);
  delta_RMS = norm(err(:));

  data = transformed_data;
  
  err = (transformed_data - cp);
  RMS = sqrt(mean(err(:).^2));

  if GX
    [Rmin, tmin] = icp_deparam(params);
    datatmp = awf_transform_pts(origdata, Rmin, tmin);
    set(h, 'xdata', datatmp(:,1), 'ydata', datatmp(:,2))

    % set(h, 'xdata', data(:,1), 'ydata', data(:,2))
    if GX == 2
      icp_thicken(findobj('type', 'line'));
      axis([-1 3 -1 2])
      drawnow;
      fn = sprintf('icp2dbasic.%03d.png', count);
      icp_pngprint(fn);
    end
    drawnow;
    fprintf(1, ' iter %3d RMS %4.1f deltaRMS %7.4f inliers %4d/%d\n', ...
	count, 10*RMS, delta_RMS, length(inliers), ndata);
  end

  if delta_RMS < 1e-8
    break
  end
  
end

newdata = data;
final_err = RMS;
