function [data, params, err, iters] = icp_2d_dt(borgefors, model, data, m_estimator, DTOL, GX)

% ICP_2D_DT     A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 13 Apr 01

if nargin < 6
  GX = 1;
end

% borgefors.D = E = sqrt(m(D));
%               E'= sqrt'(m(D)) * m'(D);
%                 = 1/2E * m'(D)

if ~strcmp(m_estimator, 'ls')
  borgefors.D = sqrt(awf_m_estimator(m_estimator, borgefors.D, DTOL));
  Efactor = 1./(2 * borgefors.D);
  borgefors.Dx = Efactor * awf_m_estimator(['D' m_estimator], borgefors.Dx, DTOL);
  borgefors.Dy = Efactor * awf_m_estimator(['D' m_estimator], borgefors.Dy, DTOL);
end

p = [0 0 0];

if GX
  DRangeX = [1:borgefors.xsize] * borgefors.xscale + borgefors.xstart;
  DRangeY = [1:borgefors.ysize] * borgefors.yscale + borgefors.ystart;
  hold off
  if 0
    imagesc(DRangeX, DRangeY, 0*log(borgefors.D)')
  else
    plot(nan)
    axis([DRangeX([1 end]) DRangeY([1 end])])
    axis ij
  end
  hold on
  h = plot(data(:,1), data(:,2), 'b.')
  plot(model(:,1), model(:,2), 'r.')
  plot(model(:,1), model(:,2), 'r-')
  % xormode(h);
else
  h = 0;
end

icp0.h = [];
icp0.borgefors = borgefors;
icp0.data = data(1:10,:);
test_derivatives([.1 .1 .1], icp0);


icp.h = h;
icp.data = data;
icp.borgefors = borgefors;

global icp_2d_dt_iters
icp_2d_dt_iters = 0;

options = optimset('lsqnonlin');
options.TypicalX = [1 1 1];
options.TolFun = 0.005;
options.TolX = 0.001;
options.DiffMinChange = .00001;
options.LargeScale = 'on';
options.maxFunEvals = 1000;
options.Jacobian = 'on';
options.DerivativeCheck = 'off';
params = [0 0 0]; % theta, tx, ty
[params, resnorm, residual, exitflag, output] =...
    lsqnonlin(@icp_error, params, [], [], options, icp);

iters = icp_2d_dt_iters;

% final plot
[R,t] = icp_deparam(params);
data = icp_transrot(data, R, t);
err = icp_error(params, icp);
err = sqrt(mean(err.^2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dists, J] = icp_error(params, icp)
global icp_2d_dt_iters
icp_2d_dt_iters = icp_2d_dt_iters + 1;

[R,t] = icp_deparam(params);

Tx = icp_transrot(icp.data, R, t);

[dists, Dx, Dy] = awf_borgefors_cp(icp.borgefors, Tx(:,1), Tx(:,2));

% syms t tx ty real
% syms xi yi real
% [R,trans] = icp_deparam([t tx ty]);
% Tx = icp_transrot([xi yi], t, [tx ty])
% [diff(Tx, t)'  diff(Tx, tx)' diff(Tx, ty)']
% [ -(xi+tx)*sin(t)+(yi+ty)*cos(t),  cos(t), sin(t)]
% [ -(xi+tx)*cos(t)-(yi+ty)*sin(t), -sin(t), cos(t)]

s = sin(params(1));
c = cos(params(1));
xpt = icp.data(:,1) + params(2);
ypt = icp.data(:,2) + params(3);

J = [Dx .* (-xpt*s + ypt*c), Dx *  c,  Dx * s] + ...
    [Dy .* (-xpt*c - ypt*s), Dy * -s,  Dy * c];

if icp.h
  set(icp.h, 'xdata', Tx(:,1), 'ydata', Tx(:,2))
  drawnow
  fprintf(' iter %3d err %4.1f \n', icp_2d_dt_iters, 10 * sqrt(mean(dists.^2)));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_derivatives(p, icp)

icp.data = icp.data(1,:)

% 1st test awf_borgefors_cp
if 0
  tx = icp.data(1,1)
  ty = icp.data(1,2)
  [dists, Dx, Dy] = awf_borgefors_cp(icp.borgefors, tx, ty)
  d=1e-2;
  fdx = (awf_borgefors_cp(icp.borgefors, tx + d, ty) - ...
      awf_borgefors_cp(icp.borgefors, tx - d, ty))/(2*d)
  fdy = (awf_borgefors_cp(icp.borgefors, tx, ty + d) - ...
      awf_borgefors_cp(icp.borgefors, tx, ty - d))/(2*d)
end

[dists, AnaJAC] = icp_error(p, icp);
AnaJAC

delta = 1e-4;
for k=1:length(p)
  p0=p; p0(k)=p0(k) - delta;
  p1=p; p1(k)=p1(k) + delta;
  h = p1(k) - p0(k);
  f1 = icp_error(p1, icp); 
  f0 = icp_error(p0, icp); 
  FDJAC(:,k) = (f1 - f0) / h;
end
FDJAC

DERIVATIVE_TEST_ERR = FDJAC - AnaJAC

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dists = icp_error_grad(params, icp)
[R,t] = icp_deparam(params);
