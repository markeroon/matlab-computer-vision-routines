addpath('~/Code/PointCloudGenerator/' );
X_vec = [   10  40  100
            10  42  96
            10  41  96
            10  39  98
            11  41  99
            12  39  97
            11  41  100
            10  45  100
            9   39  101
            8   40  99
            10  39  98
            14  42  120
            16  45  125
            14  45  125 ];
plot3(X_vec(:,1),X_vec(:,2),X_vec(:,3),'ro','markersize',12);
q_x = ones(size(X_vec,1),1);
k = 10;
for i=1:size(X_vec,1)
   q_x(i) = kernel_density_estimate( X_vec,i,k);
   if mod(i,1000) == 0
        sprintf( '%f completed', i/size(X_vec,1)*100 )
   end
end