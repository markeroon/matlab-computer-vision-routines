function [data, params, err] = test1(x, model, data, m_estimator, DTOL)

% TEST1         A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 04 Apr 01

hold off
scatter(x,'k-');
hold on
axis ij

scatter(model, 'r-');
scatter(model, 'r.');

awf_axissurround(model, 2);

scatter(data, 'b.');

h = scatter(data, 'g.');
xormode(h);

mx = model(:,1);
my = model(:,2);

delstruct = awf_delaunay_4srch(mx, my);

ndata = size(data,1);
nmodel = size(model,1);

icp.m_estimator = m_estimator;
icp.DTOL = DTOL;
icp.delstruct = delstruct;
icp.data = data;
icp.h = h;
icp.model = model;
% compute tangent planes
for k=1:nmodel
  if k == 1
    d = model(2,:) - model(1,:);
  elseif k == nmodel
    d = model(end,:) - model(end-1,:);
  else
    d = model(k+1,:) - model(k-1,:);
  end
  d = d / norm(d);
  normal = [d(2) -d(1)];
  l = [normal, -normal * model(k,:)'];
  % draw_line(model(k,:), model(k,:) + normal * 3, 'r');
  icp.lines(k,:) = l;
end

global icp_oh
icp_oh = plot(nan);

options = optimset('lsqnonlin');
options.TypicalX = [1 1 1];
options.TolFun = 0.0001;
options.TolX = 0.00001;
params = [0 0 0]; % theta, tx, ty
params = lsqnonlin(@icp_error, params, [], [], options, icp)

% final plot
[R,t] = icp_deparam(params);
data = icp_transrot(data, R, t);
err = icp_error(params, icp);
err = sqrt(mean(err.^2));

set(h, 'erasemode', 'none')
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dists = icp_error(params, icp)
[R,t] = icp_deparam(params);

data = icp_transrot(icp.data, R, t);

ndata = size(icp.data,1);

set(icp.h, 'xdata', data(:,1), 'ydata', data(:,2))
set(icp.h, 'xdata', data(:,1), 'ydata', data(:,2))
drawnow

% Find closest pts on model
cp = ones(ndata,2);
for i=1:ndata
  k = awf_delaunay_closest_pt(icp.delstruct, data(i,1), data(i,2));
  if ~(k < size(icp.model,1))
    % closest point
    cp(i,:) = icp.model(k,:);
  else
    % closest on a line
    cp(i,:) = proj_onto_line(data(i,:), icp.lines(k,:));
  end
end

% Compute distances
dists = sqrt(sum((cp - data)'.^2));

% Pass through Huber function
dists = sqrt(awf_m_estimator(icp.m_estimator, dists, icp.DTOL));

% Draw cp vectors
if 0
  global icp_oh
  delete(icp_oh);
  errdir = cp - data;
  errdirlen = sqrt(sum((errdir.^2)'))';
  l = (dists' ./ errdirlen);
  errdir = errdir .* (l * [1 1]);
  icp_oh = draw_line(data, data + errdir, 'b-');
  % icp_oh = scatter(cp, 'b.');
end

fprintf(1, ' err %4.2f params %4.1f %4.1f %4.1f\n', ...
    sqrt(mean(dists.^2)), params);
