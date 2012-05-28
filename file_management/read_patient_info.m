function [ staple_indices,gtv_indices ] = read_patient_info( propagation_list_filename )
%READ_PATIENT_INFO Reads patient data regarding staple position and
% gtv locations from a txt file
    

    fid = fopen( propagation_list_filename,'r' );
    [c,d] = textscan(fid,'%s %s \n','delimiter','''')
    
    labels_scanned = c{1};
    indices_scanned = c{2};
    for i=1:size(labels_scanned,1)
      a = regexp(labels_scanned(i), 'PRIMARY', 'match')
      is_primary(i) = ~isempty( a{1} );
      a = regexp(labels_scanned(i), '_0', 'match')
      is_00(i) = ~isempty( a{1} );
      a = regexp(labels_scanned(i), '10', 'match')
      is_10(i) = ~isempty( a{1} )
      a = regexp(labels_scanned(i), '20', 'match')
      is_20(i) = ~isempty( a{1} )
      a = regexp(labels_scanned(i), '30', 'match')
      is_30(i) = ~isempty( a{1} )
      a = regexp(labels_scanned(i), '40', 'match')
      is_40(i) = ~isempty( a{1} )
      a = regexp(labels_scanned(i), '50', 'match')
      is_50(i) = ~isempty( a{1} )
      a = regexp(labels_scanned(i), '60', 'match')
      is_60(i) = ~isempty( a{1} )
      a = regexp(labels_scanned(i), '70', 'match')
      is_70(i) = ~isempty( a{1} )
      a = regexp(labels_scanned(i), '80', 'match')
      is_80(i) = ~isempty( a{1} )
      a = regexp(labels_scanned(i), '90', 'match')
      is_90(i) = ~isempty( a{1} )
    end
    
    
    gtv_indices.idx_00_percent = find( is_primary' & strcmp(indices_scanned,'0') == 1 );
    gtv_indices.idx_10_percent = find(  is_primary' & strcmp(indices_scanned,'10') == 1 );
    gtv_indices.idx_20_percent = find( is_primary' & strcmp(indices_scanned,'20') == 1 );
    gtv_indices.idx_30_percent = find( is_primary' & strcmp(indices_scanned,'30') == 1 );
    gtv_indices.idx_40_percent = find( is_primary' & strcmp(indices_scanned,'40') == 1 );
    gtv_indices.idx_50_percent = find( is_primary' & strcmp(indices_scanned,'50') == 1 );
    gtv_indices.idx_60_percent = find( is_primary' & strcmp(indices_scanned,'60') == 1 );
    gtv_indices.idx_70_percent = find( is_primary' & strcmp(indices_scanned,'70') == 1 );
    gtv_indices.idx_80_percent = find( is_primary' & strcmp(indices_scanned,'80') == 1 );
    gtv_indices.idx_90_percent = find( is_primary' & strcmp(indices_scanned,'90') == 1 );
    
    staple_indices.idx_00_percent = find( is_00' & is_primary' & strcmp(indices_scanned,'') == 1 );
    staple_indices.idx_10_percent = find( is_10' & is_primary' & strcmp(indices_scanned,'') == 1 );
    staple_indices.idx_20_percent = find( is_20' & is_primary' & strcmp(indices_scanned,'') == 1 );
    staple_indices.idx_30_percent = find( is_30' & is_primary' & strcmp(indices_scanned,'') == 1 );
    staple_indices.idx_40_percent = find( is_40' & is_primary' & strcmp(indices_scanned,'') == 1 );
    staple_indices.idx_50_percent = find( is_50' & is_primary' & strcmp(indices_scanned,'') == 1 );
    staple_indices.idx_60_percent = find( is_60' & is_primary' & strcmp(indices_scanned,'') == 1 );
    staple_indices.idx_70_percent = find( is_70' & is_primary' & strcmp(indices_scanned,'') == 1 );
    staple_indices.idx_80_percent = find( is_80' & is_primary' & strcmp(indices_scanned,'') == 1 );
    staple_indices.idx_90_percent = find( is_90' & is_primary' & strcmp(indices_scanned,'') == 1 );
   
    fclose(fid);
end

