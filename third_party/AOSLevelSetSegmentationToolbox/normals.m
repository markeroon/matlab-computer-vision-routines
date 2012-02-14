% example usage :
% cols = 100;
% rows = 100;
% [u,v] = meshgrid( 1:cols, 1:rows );
% phi = ((u-cols/2)/(floor(0.45*cols))).^2+((v-rows/2)/(floor(0.45*rows))).^2-1;
% n_phi = normals( phi );
function [normGradPhiX,normGradPhiY] = normals( phi ) 
    %cols = 100;
    %rows = 100;
    %[u,v] = meshgrid(1:cols, 1:rows);
    %phi = ((u-cols/2)/(floor(0.45*cols))).^2+((v-rows/2)/(floor(0.45*rows))).^2-1;
    %imagesc( phi )
    [gradPhiX gradPhiY]=gradient(phi);
    % magnitude of gradient of phi
    absGradPhi=sqrt(gradPhiX.^2+gradPhiY.^2);
    % normalized gradient of phi - eliminating singularities
    normGradPhiX=gradPhiX./(absGradPhi+(absGradPhi==0));
    normGradPhiY=gradPhiY./(absGradPhi+(absGradPhi==0));
    %imagesc( normGradPhiX) 
    
    % added on Jan 21, 2009 -- forgot the change direction of normal!
    normGradPhiX = -normGradPhiX;
    normGradPhiY = -normGradPhiY;
    contour( phi ), hold on,
    quiver( normGradPhiX, normGradPhiY ), hold off
end