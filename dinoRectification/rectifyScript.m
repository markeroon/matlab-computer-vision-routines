addpath( '/home/mbrophy/ComputerScience/LevelSetsAOS3D/' );
addpath( '/home/mbrophy/ComputerScience/SphereToPlaneEvolution/' );
addpath( '/home/mbrophy/ComputerScience/SilhouettesMatlab/' );
addpath( '/home/mbrophy/ComputerScience/CubeToCubeEvolution/' );
addpath( '/home/mbrophy/ComputerScience/AOSLevelSetSegmentationToolbox/' );

[a,P,numImages] = dinoFileRead(  );

%pml = P{2};
%pmr = P{3};

delta_x = 0.001;    delta_y = 0.001;    delta_z = 0.001;
%(-0.021897 0.021126 -0.017845)
%(0.050897 0.108227 0.055495)
[y,x,z] = meshgrid( 0.021126:delta_y:0.108227, ...
                    -0.021897:delta_x:0.05089, ...
                    -0.017845:delta_z:0.055495 );
[visHull,img,phi] = VisHull( x,y,z );
vol = zeros(size(x));

ml = [0;0];
calibRectifier = CalibratedRectifier( );


for i = 1:2 %numImages-1
    i
    filename = sprintf( '/home/mbrophy/ComputerScience/dinoRing/dinoR%04d.png', i );
    IL = imread( filename );
    filename = sprintf( '/home/mbrophy/ComputerScience/dinoRing/dinoR%04d.png', i+1 );
    IR = imread( filename );
    
    pml = P{i};
    pmr = P{i+1};
    [ pml1,pmr1,JL,JR,bestshiftsL,bestshiftsR ] = rectify( calibRectifier,IL,IR,pml,pmr );
    [vol] = backproject( pml1, pmr1, bestshiftsR, JL, JR,vol,x,y,z );
end

vol2 = vol;
% visual hull constraint
vol2( phi > 0 ) = 0;

