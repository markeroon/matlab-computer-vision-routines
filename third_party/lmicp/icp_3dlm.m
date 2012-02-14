function [R,t] = icp_3dbasic(model, data, alldata)

% ICP_3DLM   A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Apr 01

lmdata.model = model;
lmdata.alldata = alldata;
lmdata.data = data;

figure(1)
hold off
set(scatter(model, 'b.'), 'markersize', .001);
set(gcf, 'renderer', 'opengl')
hold on
axis off
lmdata.h_alldata = scatter(alldata, 'r.');
set(lmdata.h_alldata, 'markersize', .001);
lmdata.h = scatter(data, 'r+');
set(lmdata.h, 'markersize', 2);
axis equal
axis vis3d

global icp_3dlm_iter
icp_3dlm_iter = 0;

global icp_3dlm_matches
icp_3dlm_matches = [];

if nargout < 2
  disp('No return values, returning....');
  return
end

% Set up levmarq and tallyho
options = optimset('lsqnonlin');
options.TypicalX = [1 1 1 1 1 1];
options.TolFun = 0.0001;
options.TolX = 1e-7;
if 0
  options.LargeScale = 'off';
  options.DiffMinChange = 1e-4;
else
  options.LargeScale = 'on';
end
options.Display = 'iter';

params = [0 0 0   0 0 0]; % quat, trans
params = lsqnonlin(@icp_3derror, params, [], [], options, lmdata);
[R,t] = icp_deparam_3d(params);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Error function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Dists = icp_3derror(params, lm)
% 1. Extract R, t
[R,t] = icp_deparam_3d(params);

t = t(:)'; % colvec

% 2. Evaluate
tic
global icp_3dlm_iter
icp_3dlm_iter = icp_3dlm_iter + 1;

D = lm.data;
alldata = lm.alldata;
D = D * R' + t(ones(1,size(D,1)), :);
alldata = alldata * R' + t(ones(1,size(alldata,1)), :);

if 0
  fprintf('cp, ');
end

[Matches, Dists] = dsearchn(lm.model, D);
M = lm.model(Matches, :);

global icp_3dlm_matches
icp_3dlm_matches = [icp_3dlm_matches Matches(:)];

dummy = sort(Dists);
meanD = 0.01;
figure(2)
plot(dummy)
hline(meanD);
figure(1)
% meanD = dummy(round(end * .2)); % percentile at which threshold is set
Dists = sqrt(awf_m_estimator('bz', Dists, meanD));

Dists = 10 * Dists;

err = sum(Dists.^2);

scatter(alldata, lm.h_alldata);
scatter(D, lm.h);
drawnow
if 0
  fprintf(' err %.7f  iter %4d  dT %g time %g meanD %g ', ...
      err, icp_3dlm_iter, 0, toc, meanD);
  fprintf(' %.5f ', params);
  fprintf('\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R,t] = icp_deparam_3d(params)
% 1. Extract R, t
if length(params) == 7
  q = params(1:4); q = q / norm(q);
  R = quat2mat(q);
  t = params(5:7); 
else
  r = params(1:3);
  R = expm(cross_matrix(r));
  t = params(4:6); 
end
