function [dists, Dx, Dy] = awf_borgefors_cp(borgefors, x, y)

% AWF_BORGEFORS_CP A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 14 Apr 01

xb = (x - borgefors.xstart) / borgefors.xscale;
yb = (y - borgefors.ystart) / borgefors.yscale;

[r,c] = size(borgefors.D);
dists = vgg_interp2(borgefors.D, yb, xb);
dists(~finite(dists)) = (r + c);

if any(~finite(dists))
  fprintf('awf_borgefors_cp: %d out of range\n', sum(~finite(dists)));
end


if nargout > 1
  Dx = vgg_interp2(borgefors.Dx, yb, xb);
  Dx(~finite(Dx)) = 0;

  Dy = vgg_interp2(borgefors.Dy, yb, xb);
  Dy(~finite(Dy)) = 0;

  out = ~finite(Dx) | ~finite(Dy);
  if any(out)
    fprintf('awf_borgefors_cp: %d out of range\n', sum(out));
  end

end
