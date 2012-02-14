% slfunction test3()

% TEST3         A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 30 Aug 01

bunny_T = [0.1440    0.0234    0.0844];
bunny_Scale = 4;

if ~exist('MODE', 'var')
  MODE= 1;
end

switch MODE
case 0
  N = 31;
  B = [10 20 30];
case 1
  % Use Mr Bunny
  bun000 = loadmat('/images/range/bunny/bun000.dat');
  
  N = 50;
  B = (bun000 + ones(size(bun000,1),1)*bunny_T)*bunny_Scale * N;
case 2
  bun045 = loadmat('/images/range/bunny/bun045.dat');
  
  N = 50;
  B = (bun045 + ones(size(bun045,1),1)*bunny_T)*bunny_Scale * N;
case 3
  bun090 = loadmat('/images/range/bunny/bun090.dat');
  
  N = 50;
  B = (bun090 + ones(size(bun090,1),1)*bunny_T)*bunny_Scale * N;
end

B = (round(B));
scatter(B, '.');
min(B)
max(B)
axis([0 N+1 0 N+1 0 N+1]);
grid
tic
A = zeros(N,N,N);
A(sub2ind(size(A), B(:,1), B(:,2), B(:,3))) = 1;
toc

infile = '/tmp/icp_3ddt_in.dat';
outfile = '/tmp/icp_3ddt.dat';

f = fopen(infile, 'wb');
fwrite(f, A(:), 'float32');
fclose(f); 

unix('cl -O2 -nologo icp_3ddt.cxx')
tic
unix(sprintf('icp_3ddt %d %s %s ', N, infile, outfile))
toc

f = fopen(outfile, 'rb'); 
D = fread(f, N^3, 'float32'); 
fclose(f); 
D = reshape(D,  N,N,N);

clf
slice(D, [N/2], [N/2 ], [ N/2]); 
p = patch(isosurface(D, 3), 'facecolor', 'none', 'edgecolor', 'red');
camlight
hold on
plot3(B(:,2), B(:,1), B(:,3), 'b.')
