function icp_3dbasic(model, model_triangulation, data, alldata)

% ICP_3DBASIC   A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Apr 01

D = data;

hold off
set(scatter(model, 'b.'), 'markersize', .001);
set(gcf, 'renderer', 'opengl')
hold on
axis off
h_alldata = scatter(alldata, 'r.');
set(h_alldata, 'markersize', .001);
h = scatter(data, 'r+');
set(h, 'markersize', 2);
axis vis3d

allR = eye(3);
allt = [0 0 0 ]';

iter = 0;
while 1
  tic
  iter = iter + 1;
  
  scatter(alldata, h_alldata);
  scatter(D, h);
  
  fprintf('cp, ');
  [Matches, Dists] = dsearchn(model, D);
  M = model(Matches, :);
  
  fprintf('plot, ');
  % plot3([M(:,1) D(:,1)]', [M(:,2) D(:,2)]', [M(:,3) D(:,3)]', 'r-');
  
  [R, t] = icp_solve3d_euclid(M, D);
  dTranslation = norm(t);
  
  D = D * R' + t(ones(1,size(D,1)), :);
  NewDists2 = sum( (M - D)'.^2 );
  err = sum(NewDists2);

  alldata = alldata * R' + t(ones(1,size(alldata,1)), :);
  
  fprintf(' err %.7f  iter %4d  dT %g time %g \n', err, iter, dTranslation, toc);
  
  if dTranslation < 1e-8
    break
  end

  drawnow
end
