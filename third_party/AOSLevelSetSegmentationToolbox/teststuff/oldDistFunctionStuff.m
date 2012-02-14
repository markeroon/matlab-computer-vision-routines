%phiSignedDist = zeroCrossing3D( phi_init );
%phi_dst = computeDistanceFunction3d( phiSignedDist, dX );
%phi = ac_reinit( phi_dst );

%margin = 10;
%center = [50,50,50];
%phi = zeros(size(x));
%phi(center(1)-margin:center(1)+margin,...
%center(2)-margin:center(2)+margin,...
%center(3)-margin:center(3)+margin) = 1;
%phi = computeDistanceFunction3d( phi, dX, [],1 );
%phi_init = phi;

%isosurface(x,y,z,phi,0)