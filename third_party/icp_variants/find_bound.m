function bound = find_bound(pts, poly)

%Importing points and polygons from 'fname'.vtk:
%[pts poly] = importVTK(fname, 'POINTS', 'POLYGONS');

%Correcting polygon indices and converting datatype 
poly = double(poly+1);
pts = double(pts);

%Calculating freeboundary points:
TR = TriRep(poly, pts(1,:)', pts(2,:)', pts(3,:)');
FF = freeBoundary(TR);

%Output
bound = FF(:,1);

end