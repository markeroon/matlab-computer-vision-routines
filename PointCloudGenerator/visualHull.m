function [phi] = visualHull( P, x_mesh,y_mesh,z_mesh,silhouettes )

phi = ones(size(x_mesh));

for i=1:size(x_mesh,1)
    for j=1:size(x_mesh,2)
        for k=1:size(x_mesh,3)
            X = [ x_mesh(i,j,k) ; y_mesh(i,j,k) ; z_mesh(i,j,k) ; 1 ];
            for idx = 1:size(silhouettes,1)
                assert( size(silhouettes,1) ~= 1, 'wrong dim' )
                if idx ~= 6 % 6 is the bad silhouette
                    x = P{idx}*X;
                    x = x ./ x(3);
                    if x(1) <= size(silhouettes{idx},1) && x(1) >= 1 && ...
                            x(2) <= size(silhouettes{idx},2) && x(2) >= 1 && ...
                        silhouettes{idx}(round(x(1)),round(x(2))) == 0
                        phi(i,j,k) = -1;
                    end                
                end
            end
        end
    end
end

