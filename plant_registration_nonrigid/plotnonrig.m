
nonrig_resid = [2.8661 , 3.3322 , 3.7927 , 4.0021 , 4.5391 , 4.5257 , 4.3297  ,  4.7238   , 4.2555 ,4.3687  ,  4.1136];
plot( nonrig_resid, '--b' );
hold on
cpd_resid = [3.0595, 3.3841, 3.9165, 4.1242, 4.7176, 4.8527, 4.4056,4.7026,4.2812,4.4519, 4.1230];
plot( cpd_resid, '--r' );
title( 'Effiacy of proposed method vs CPD on subset of plant data' );
xlabel('rms error' );
ylabel('scan number');
h = legend('recursive subdivision','coherent point drift',2);
set(h,'Interpreter','none')