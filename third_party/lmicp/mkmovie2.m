%function mkmovie2()

% MKMOVIE2      A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 12 Sep 01

% load somedata

I = find(x(:,1) < 200 | x(:,2) > 150);
xcrop = x; xcrop(I,:) = [];

I = finite(xcrop(:,1));

L= ones(size(cx2,1),1);
data = (cx2 - L * mean(cx2)) * rot2d(30*pi/180);

GX = 2;

global icp_pngprint_glob
icp_pngprint_glob.mode = 1;
icp_pngprint_glob.fn = 'frames/mov2.%04d.png';
icp_pngprint_glob.count = 0;

Tdata = data + L * [240 60]; icp_lmfit(Tdata, xcrop, Tdata, 'huber', 1, GX);

Tdata = data + L * [255 65]; icp_lmfit(Tdata, xcrop, Tdata, 'huber', 1, GX);

Tdata = data + L * [205 40]; icp_lmfit(Tdata, xcrop, Tdata, 'huber', 1, GX);

Tdata = data + L * [215 55]; icp_lmfit(Tdata, xcrop, Tdata, 'huber', 1, GX);
