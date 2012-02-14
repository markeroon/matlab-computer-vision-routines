function [data, params, err, iters] = ...
    icp_2d_lm_aux(borgefors, model, data, m_estimator, DTOL, GX, extraplotdata)

% ICP_2D_DT     A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 13 Apr 01

if nargin < 6
  GX = 1;
end

if nargin < 7
  extraplotdata = [];
end

fprintf('icp_2d_lm_aux: M-est = %s(%g), DISTMAX = %g\n', ...
    m_estimator, DTOL, max(borgefors.D(:)));
if ~strcmp(m_estimator, 'ls')
  %% Push derivatives through M-estimator
  % borgefors.D = E = sqrt(m(D));
  %           dE/dx = [dsqrt(t)/dt](m(D)) * dm(D)/dx 
  %                 = [dsqrt(t)/dt](m(D)) * [dm(t)/dt](D) * dD/dx 
  %                 = sqrt'(m(D)) * m'(D) * Dx;
  %                 = 1/2E * m'(D)

  E = sqrt(awf_m_estimator(m_estimator, borgefors.D, DTOL));
  mprimeD = awf_m_estimator(['D' m_estimator], borgefors.D, DTOL);
  Efactor = mprimeD./(2 * E);
  borgefors.D = E;
  borgefors.Dx = Efactor .* borgefors.Dx;
  borgefors.Dy = Efactor .* borgefors.Dy;
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
  h = plot(data(:,1), data(:,2), 'bo');
  if size(model, 1) < 1000
    plot(model(:,1), model(:,2), 'ro')
    plot(model(:,1), model(:,2), 'r-')
  else
    plot(model(:,1), model(:,2), 'r-')
  end

  if ~isempty(extraplotdata)
    set(scatter(extraplotdata, 'k:'), 'color', [1 1 1]/2)
  end
  
  % xormode(h);

  if GX == 2
    drawnow;
    fn = sprintf('icp2dlm.%03d.png', 0);
    icp_pngprint(fn);
  end

else
  h = 0;
end

I = finite(model(:,1));
model = model(I,:);

if GX
  icp0.h = [];
  icp0.borgefors = borgefors;
  icp0.data = data(1:10,:);
  test_derivatives([.1 .1 .1], icp0);
end

icp.h = h;
icp.data = data;
icp.borgefors = borgefors;

global icp_2d_dt_iters icp_2d_GX
icp_2d_dt_iters = 0;
icp_2d_GX = GX;

options = optimset('lsqnonlin');
options.TypicalX = [1 1 1];
options.TolFun = 0.00005;
if GX
  options.Display = 'final';
else
  options.Display = 'off';
end
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

%% Convert params from R(x + t) to R x + t
params = icp_params_tR_to_Rt(params);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dists, J] = icp_error(params, icp)
global icp_2d_dt_iters icp_2d_GX
icp_2d_dt_iters = icp_2d_dt_iters + 1;

[R,t] = icp_deparam(params);

Tx = icp_transrot(icp.data, R, t);

[dists, Dx, Dy] = awf_borgefors_cp(icp.borgefors, Tx(:,1), Tx(:,2));

% fprintf('D @ (%g,%g) = %g\n', Tx(1,:), dists(1));
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
  drawnow;
  if icp_2d_GX == 2
    fn = sprintf('icp2dlm.%03d.png', icp_2d_dt_iters);
    icp_pngprint(fn)
  end
  fprintf('icp_2d_lm_aux: iter %3d err %4.1f \n', icp_2d_dt_iters, 10 * sqrt(mean(dists.^2)));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_derivatives(p, icp)
fprintf('+-Testing derivatives at p =');
fprintf(' %g', p);
fprintf('\n');
icp.data = icp.data(1,:);

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
AnaJAC = AnaJAC';
fprintf('|Analytic =');
fprintf(' %9.4f', AnaJAC(:));
fprintf('\n');

delta = 1e-4;
for k=1:length(p)
  p0=p; p0(k)=p0(k) - delta;
  p1=p; p1(k)=p1(k) + delta;
  h = p1(k) - p0(k);
  f1 = icp_error(p1, icp); 
  f0 = icp_error(p0, icp); 
  FDJAC(:,k) = (f1 - f0) / h;
end
FDJAC = FDJAC';
fprintf('|  FD Jac =');
fprintf(' %9.4f', FDJAC(:));
fprintf('\n');

DERIVATIVE_TEST_ERR = FDJAC - AnaJAC;

fprintf('|    Diff =');
fprintf(' %9.4f', DERIVATIVE_TEST_ERR);
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dists = icp_error_grad(params, icp)
[R,t] = icp_deparam(params);
