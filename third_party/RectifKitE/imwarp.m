function [I2, bb, alpha] = imwarp(I,H,meth,sz)
%IMWARP Image Warping
%   I2 = imwarp(I,H) apply the projective transformation specified by H to
%   the image I using linear interpolation. The output image I2 has the
%   same size of I.
%
%   I2 = imwarp(I,H,meth) use  method 'meth' for interpolation (see interp2
%   for the list of options).
%
%   I2 = imwarp(I,H,meth,sz) yield an output image with specific size. sz
%   can be:
%
%         - 'valid'    Make output image I2 large enough to contain the
%                  entire rotated image.
%
%         - 'same'   Make output image I2 the same size as the input image
%                  I, cropping the warped image to fit (default).
%
%         -  a vector of 4 elements specifying the bounding box
%
% The output bb is the bounding box of the transformed image in the
% coordinate frame of the input image. The first 2 elements of the bb are
% the translation that have been applied to the upper left corner.
%
% The bounding box is specified with [minx; miny; maxx; maxy];
%
%   See also: INTERP2

% Author: Andrea Fusiello

[hm,hn]=size(H);
if ((hm ~= 3) | (hn ~= 3))
    error('Invalid input transformation');
end

% defaults
if nargin == 2
    sz='same';
    meth='linear';
elseif nargin ==3
    sz='same';
end

if strcmp(sz,'same')
    % same bb as the input image

    minx = 0;
    maxx = size(I,2)-1;
    miny = 0;
    maxy = size(I,1)-1;

elseif strcmp(sz,'valid')
    % compute the smallest bb containing the whole image

    corners = [0, 0, size(I,2), size(I,2);
               0, size(I,1), 0, size(I,1)];
    corners_x=p2t(H,corners);

    minx = floor(min(corners_x(1,:)));
    maxx = ceil(max(corners_x(1,:)));
    miny = floor(min(corners_x(2,:)));
    maxy = ceil(max(corners_x(2,:)));

elseif length(sz)==4
    % force the bounding box

    minx = sz(1);
    miny = sz(2);
    maxx = sz(3);
    maxy = sz(4);
else
    error('Invalid size option');

end

bb = [minx; miny; maxx; maxy];

[x,y] = meshgrid(minx:maxx-1,miny:maxy-1);

pp = p2t(inv(H),[vec(x)';vec(y)']);
xi=ivec(pp(1,:)',size(x,1));
yi=ivec(pp(2,:)',size(y,1));
I2=interp2(0:size(I,2)-1, 0:size(I,1)-1,double(I),xi,yi,meth,NaN);

if nargout == 3
    alpha = ~isnan(I2);
end

I2 = uint8(I2);

