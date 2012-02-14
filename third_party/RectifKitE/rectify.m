function [T1,T2,Pn1,Pn2] = rectify(Po1,Po2,d1,d2)
% RECTIFY compute  rectification matrices in homogeneous coordinate
%
%         [T1,T2,Pn1,Pn2] = rectify(Po1,Po2,d) computes the rectified
%         projection matrices "Pn1" and "Pn2", and the transformation 
%         of the retinal plane "T1" and  "t2" (in homogeneous coord.)
%         which perform rectification.  The arguments are the two old
%         projection  matrices "Po1" and "Po2" and two 2D displacement 
%         d1 and d2 wich are applied to the new image centers.

%         Andrea Fusiello, 1999 (fusiello@sci.univr.it)

%         19/11/2001: bug fixed in [A2,R2,t2] = art(Po1)
%         01/10/2003: image centers displacement  added
%         29/01/2004: bug fixed in v1 = (c1-c2);
%         29/01/2004: changed expression for c1 and c2;


if nargin==2
    d1=[0,0];
    d2=[0,0];
end

if d1(2) ~= d2(2) 
    error('left and right vertical displacements must be the same')
end

% factorise old PPM 
[A1,R1,t1] = art(Po1);
[A2,R2,t2] = art(Po2);

% optical centers (unchanged)
c1 = - R1'*inv(A1)*Po1(:,4);
c2 = - R2'*inv(A2)*Po2(:,4);

% new x axis (baseline, from c1 to c2)
v1 = (c2-c1);
% new y axes (orthogonal to old z and new x)
v2 = cross(R1(3,:)',v1);
% new z axes (no choice, orthogonal to baseline and y)
v3 = cross(v1,v2);

% new extrinsic (translation unchanged)
R = [v1'/norm(v1)
    v2'/norm(v2)
    v3'/norm(v3)];

% new intrinsic (arbitrary) 
An1 = A2;
An1(1,2)=0;
An2 = A2;
An2(1,2)=0;

% translate image centers 
An1(1,3)=An1(1,3)+d1(1);
An1(2,3)=An1(2,3)+d1(2);
An2(1,3)=An2(1,3)+d2(1);
An2(2,3)=An2(2,3)+d2(2);

% new projection matrices
Pn1 = An1 * [R -R*c1 ];
Pn2 = An2 * [R -R*c2 ];

% rectifying image transformation
T1 = Pn1(1:3,1:3)* inv(Po1(1:3,1:3));
T2 = Pn2(1:3,1:3)* inv(Po2(1:3,1:3));





