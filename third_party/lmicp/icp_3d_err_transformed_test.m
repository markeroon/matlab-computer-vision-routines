function icp_3d_err_transformed_test()

% ICP_3D_ERR_TRANSFORMED_TEST A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 31 Aug 01

D = [1 2 3];
p = [1 2 3 4 -[5 6 7]];

[T,Jx,Jy,Jz] = icp_3d_err_transformed(p, D);

T

AnalyticJacobian = [Jx; Jy; Jz]

delta = 1e-4;
for k=1:7
  p0 = p; p0(k) = p0(k) - delta;  
  p1 = p; p1(k) = p1(k) + delta;
  h = p1(k) - p0(k);
  
  f1 = icp_3d_err_transformed(p1, D);
  f0 = icp_3d_err_transformed(p0, D);
  Diff = (f1 - f0)/h;
  FDJacobian(:,k) = Diff';
end

FDJacobian

[T,Jx,Jy,Jz] = icp_3d_err_transformed(p, [D; D; D])

ERR = AnalyticJacobian - FDJacobian;

FDJacobian = zeros(3,7);

DeltaRange = logspace(-12, 0, 100);
Errs = [];
for delta = DeltaRange

  for k=1:7
    p0 = p; p0(k) = p0(k) - delta;  
    p1 = p; p1(k) = p1(k) + delta;
    h = p1(k) - p0(k);
    
    f1 = icp_3d_err_transformed(p1, D);
    f0 = icp_3d_err_transformed(p0, D);
    Diff = (f1 - f0)/h;
    FDJacobian(:,k) = Diff';
  end

  Err = norm(FDJacobian- AnalyticJacobian);
%  fprintf('Del %20.3e err %g\n', h, log(Err))
  Errs = [Errs Err];
end

clf
plot(log(DeltaRange)/log(10), log(Errs)/log(10));

title('finite-difference vs analytic')
xlabel('log10(h) in d/dx = (f(x+h)-f(x-h)) / (2*h)')
ylabel('log10(err)')
set(gca, 'position', [.2 .2 .7 .7])