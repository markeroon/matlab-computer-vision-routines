function D = icp_3ddt(M)

% ICP_3DDT      Compute 3D distance transform from Mask array M
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 30 Aug 01

N = size(M,1);

infile = '/tmp/icp_3ddt_in.dat';
outfile = '/tmp/icp_3ddt.dat';

disp('writing')
f = fopen(infile, 'wb');
fwrite(f, M(:), 'float32');
fclose(f); 

disp('calling')
tic
if ispc
    path='';
else
    path='./';
end
unix(sprintf('%sicp_3ddt %d %s %s ', path, N, infile, outfile))
toc

disp('reading')
f = fopen(outfile, 'rb'); 
D = fread(f, N^3, 'float32'); 
fclose(f); 
D = reshape(D,  N,N,N);
