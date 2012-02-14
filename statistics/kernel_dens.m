y = sin( -15:15 );
x = 0.5*randn(31,1) + y';
z = [x; y'];

[f,xi] = ksdensity(z, 'kernel', 'epanechnikov');
