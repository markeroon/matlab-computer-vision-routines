X1 = [ 1 10 50 ];
X2 = [ 1 20 70];
X3 = [ 1 30 30];

Nx = 50; Ny = 70; Nz = 30;

[ d,d_x,d_y,d_z,x,y,z ] = distance_vol( X1,X2,X3,Nx,Ny,Nz );

for i = 1:size(X1,2)
    assert(d(X2(i),X1(i),X3(i)) < 0.01, ...
        'd( %d %d %d ) should be almost zero ',X2(i),X1(i),X3(i))
end