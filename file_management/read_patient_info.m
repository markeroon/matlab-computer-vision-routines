function [ c,d ] = read_patient_info( propagation_list_filename )
%READ_PATIENT_INFO Reads patient data regarding staple position and
% gtv locations from a txt file
    
    fid = fopen( propagation_list_filename,'r' );
    [c,d] = textscan(fid,'%s %s \n','delimiter','''')
    
    
    labels_scanned = c{1}(:);
    indices_scanned = c{2}(:);
    
    %idx_0_percent = find( indices_scanned == '0' )
    
    fclose(fid);
end

