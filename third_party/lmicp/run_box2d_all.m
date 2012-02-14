% function run_box2d_all()

% RUN_BOX2D_ALL A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 08 Sep 01


t = linspace(0,1,100)';

box = [1-t 1+0*t; 0*t t; t 0*t; 1+0*t t];

model = box * diag([2 1]);

GX = 0;
NSAMPLES = 100;
tic
out = [];
err = [];
RotAngleRange = 0:10:80;
for rotangle = RotAngleRange

  translation = [.5 0];
  
  mean_icp = 0;
  mean_lm = 0;
  out1 = [];
  for sample = 1:NSAMPLES
    data = awf_transform_pts(model, rot2d(rotangle / 180 * pi), translation);
    data = data + randn(size(data))*.01;

    [newdata, newparams, final_err, niters] = ...
                             icp_2dbasic_step(model, model, data , 100, GX);
    fprintf('regular icp done, niters = %d\n', niters);
    
    [newdata_lm, newparams_lm, final_err_lm, niters_lm] = ...
                             icp_2d_lm(model, model, data , 100, GX);
    fprintf('lm icp done, niters = %d\n', niters_lm);
    
    fprintf('............................................Old/LM = %d/%d  errs %6.3f,%6.3f\n', ...
	niters, niters_lm, final_err, final_err_lm);
    out1 = [out1; niters, niters_lm, final_err, final_err_lm];
  end
  out1
  mean(out1)
  std(out1)
  out = [out; mean(out1)];
  err = [err; std(out1)];
  fprintf('                                                **************************************** ang = %g\n', rotangle);
end

hold off
k=1;errorbar(RotAngleRange, out(:,k), err(:,k), 'r');
hold on
k=2;errorbar(RotAngleRange, out(:,k), err(:,k), 'b');
legend('icp', 'lm');

toc
