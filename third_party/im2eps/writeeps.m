function writeeps(img, filename)
%WRITEEPS Save a grayscale or a color image to an EPS file
%
% WRITEEPS(img, filename)
% check whether img is a grayscale or color image
% normalize it to [0,255] and convert it to uint8 class
% then calls the mex function im2eps to write it as
% encapsulated postscript
%
% Copyright 2005 the IT University of Copenhagen
% Francois Lauze.
% Part of the generated postscript code is taken
% from ImageMagick. See http://wwww.imagemagick.org
% for some license stuffs.
% Code under (L?)GPL

% I do some elementary checking here
% nothing for filename consistency, it's done in im2eps
if isnumeric(img) ~= 1
    error('first argument must be a numeric array.');
end
if isreal(img) == 0
    error('first argument must be a non complex array.');
end
if ndims(img) > 3
    error('first argument is not a grayscale/color 2D image.');
elseif ndims(img) == 3
    [m,n,c] = size(img);
    if c == 2 || c > 3
        error('first argument is not a grayscale/color 2D image.');
    end
end

img = double(img);
maxval = max(img(:));
minval = min(img(:));
range = maxval-minval;
img = uint8(255*(img-minval)/range);
im2eps(img,filename);


