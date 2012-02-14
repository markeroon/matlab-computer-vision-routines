function exportPlyFile( X1,X2,X3, sil_image, filename  )
	
    DATA.vertex.x = X1;
    DATA.vertex.y = X2;
    DATA.vertex.z = X3;
    
    im_row_major = sil_image'; % stored in row major order
    DATA.obj_info.num_cols = size(im_row_major,2);
    DATA.obj_info.num_rows = size(im_row_major,1);
    DATA.range_grid.vertex_indices = cell(1,size(im_row_major(:),1));
    count = 0;
    for i=1:size(im_row_major(:),1)
            if im_row_major(i) == 1
                DATA.range_grid.vertex_indices{i} = [count];
                count = count + 1;
            else 
                DATA.range_grid.vertex_indices{i} = [];
            end
    end
    %DATA.range_grid.vertex_indices = { [5],[],[6],[10],[11],[] };
	ply_write( DATA, filename,'ascii'  );
