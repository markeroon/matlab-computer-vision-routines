function drawEpipolarLine( u,v,u_prime,v_prime,pml,pmr,im )

[F,el,er] = fund( pml,pmr );

% Assume p, p_prime are two corresponding image points.
p=(u,v,1);
p_prime=(u_prime,v_prime,1);

epipolar_line = F * p_prime;
a = epipolar_line(1);
b = epipolar_line(2);
c = epipolar_line(3);

% Consider a region around p in two cases due to different slope
length = 30;
if(abs(a)<abs(b))
    d = length/sqrt((a/b)^2+1);
    drawpoint = [u-d , u+d ; (-c - a*(u-d))/b , (-c - a*(u+d))/b ];
else
    d = length/sqrt((b/a)^2+1);
    drawpoint = [(-c - b*(v-d))/a  , (-c - b*(v+d))/a ; v-d , v +d ];
end
plot(drawpoint(1,:), drawpoint(2,:));

end