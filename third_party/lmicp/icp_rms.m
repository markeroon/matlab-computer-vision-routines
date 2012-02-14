function err = icp_rms(model, data)

% ICP_RMS       A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Sep 01

delstruct = awf_delaunay_4srch(model(:,1), model(:,2));

ndata = size(data,1);
  
% Find closest pts on model
for i=1:ndata
  k = awf_delaunay_closest_pt(delstruct, data(i,1), data(i,2));
  cp(i,:) = model(k,:);
end

d2 = sum((data - cp).^2, 2);
err = sqrt(mean(d2));
