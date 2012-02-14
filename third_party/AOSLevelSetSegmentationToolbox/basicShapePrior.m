filename = 'dino/dinoPrior0002.png';
I = im2double( rgb2gray( imread( filename ) ) );
priorDino = I;
priorDino = priorDino < 1;
sdfDino = bwdist( priorDino );
sdfDIno = sdfDino / max( sdfDino(:) );

phi = ac_SDF_2D('rectangle', size(I), 10) ;
for i = 1:20 
    phi = phi - sdfDino;
end
imagesc( phi )