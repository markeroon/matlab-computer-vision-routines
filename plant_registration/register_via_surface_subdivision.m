function [Y1_reg,Y2_reg,Y3_reg] = ...
                    register_via_surface_subdivision( X,Y,iters_rigid,...
                                                      iters_nonrigid )
%REGISTER_VIA_SURFACE_SUBDIVISION Do a coarse to fine registration.
%  
MAX_SSD_DIST = 10; % If dist is larger than this, it is not
                   % included in the error estimation.
lambda = 1; %10
beta = 1;%30
[Y1_reg,Y2_reg,Y3_reg] = registerToReferenceRangeScan( ...
                                    X,Y,30,0,lambda,beta );
Y = [Y1_reg,Y2_reg,Y3_reg];

left   = min(X(:,1))
right  = max(X(:,1))
top    = max(X(:,2))
bottom = min(X(:,2))
back   = min(X(:,3))
front  = max(X(:,3))

width = ( max(X(:,1)) - min(X(:,1)) ); % / 2 
height = ( max(X(:,2)) - min(X(:,2)) ); %/ 2 
depth = ( max(X(:,3)) - min(X(:,3)) ); % / 2 

iters_nonrigid__ = iters_nonrigid;

MIN_WIDTH = 35; MIN_HEIGHT = 35; MIN_DEPTH = 35;

% YOU ONLY ADD AT THE SMALLEST LEVEL OF GRANULARITY
while width > MIN_WIDTH && height > MIN_HEIGHT && depth > MIN_HEIGHT
    
    if width / 2 <= MIN_WIDTH || height/2 <= MIN_HEIGHT || depth/2 <= MIN_DEPTH
        iters_nonrigid = iters_nonrigid__;
    else
        iters_nonrigid = 0;
    end
    width = width / 2
    height = height / 2
    depth = depth / 2
    Y1_reg = [];
    Y2_reg = [];
    Y3_reg = [];
    
    for i=left:width:right-width
        for j=bottom:height:top-height
            for k=back:depth:front-depth
                idx_x = find( X(:,1) > i   & X(:,1) < i+width & ...
                            X(:,2) > j & X(:,2) < j+height & ...
                            X(:,3) > k   & X(:,3) < k+depth )
                idx_y = find( Y(:,1) > i   & Y(:,1) < i+width & ...
                            Y(:,2) > j & Y(:,2) < j+height & ...
                            Y(:,3) > k   & Y(:,3) < k+depth )       
                if (size( idx_x,1 ) > 80) && (size( idx_y,1 ) > 80)
                    [Y1_,Y2_,Y3_] = registerToReferenceRangeScan(X(idx_x,:),...
                                                                 Y(idx_y,:),...
                                                                 iters_rigid,...
                                                                 iters_nonrigid,...
                                                                 lambda,...
                                                                 beta);
                    % Indicates last time through. We check the quality
                    % of the fit before we just add it mindlessly.
                    if width <= MIN_WIDTH || height <= MIN_HEIGHT || depth <= MIN_DEPTH
                        % check avg sum of squared distances
                        % "rejection of poor registrations"
                        [ids,dists] = kNearestNeighbors( Y(idx_y,:),X(idx_x,:),1 );
                        idx = find( dists <= MAX_SSD_DIST );
                        dists = dists(idx); % remove larger dists from weighting
                        SSD_avg = sum(dists) / size(dists,1);
                        % if it's a small distance and at least a third of
                        % the points are kept, then we add it
                        if SSD_avg <= 1 && (size(dists,1)*3) > size(ids,1)
                            Y1_reg = [ Y1_reg ; Y1_ ];
                            Y2_reg = [ Y2_reg ; Y2_ ];
                            Y3_reg = [ Y3_reg ; Y3_ ];
                        else 
                            ; % Leave them out completely
                        end
                    end
                elseif size(idx_x,1) > 5 && size(idx_y,1) > 5
                   [ids,dists] = kNearestNeighbors( Y(idx_y,:),X(idx_x,:),1 );
                   % if we're going to add this few points, it damn
                   % well better be a _very_ good fit.
                   SSD_avg = sum(dists) / size(dists,1);
                   if SSD_avg <= 1
                        Y1_reg = [ Y1_reg ; Y(idx_y,1) ];
                        Y2_reg = [ Y2_reg ; Y(idx_y,2) ];
                        Y3_reg = [ Y3_reg ; Y(idx_y,3) ];
                   end
                else
                    ; % do nothing -- THESE POINTS DON'T GET ADDED
                end               
            end
        end
    end
end