addpath( '../file_management' );
data = open('../../Data/GrossTumourVolumes/DeformStaple_allpatients_good.mat');
patients = 1:10


for i = 1:length(patients)
    patient_num = patients(i);
    propagation_list_filename = sprintf( '../../Data/GrossTumourVolumes/DeformStaple_patient%d.txt', patient_num );
    [ staple_indices,gtv_indices ] = read_patient_info( propagation_list_filename );
    
    
    switch patient_num
    case 1
    segmentations = data.rois_4dct001;
    names = data.names_4dct001;
    case 2
    segmentations = data.rois_4dct002;
    names = data.names_4dct002;
    case 3
    segmentations = data.rois_4dct003;
    names = data.names_4dct003;
    case 4
    segmentations = data.rois_4dct004;
    names = data.names_4dct004;
    case 5
    segmentations = data.rois_4dct005;
    names = data.names_4dct005;
    case 6
    segmentations = data.rois_4dct006;
    names = data.names_4dct006;
    case 7
    segmentations = data.rois_4dct007;
    names = data.names_4dct007;
    case 8
    segmentations = data.rois_4dct008;
    names = data.names_4dct008;
    case 9
    segmentations = data.rois_4dct009;
    names = data.names_4dct009;
    case 10
    segmentations = data.rois_4dct010;
    names = data.names_4dct010;
    end
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_00_percent,gtv_indices.idx_00_percent);
    registered_tumours.phase_00 = registered_tumour;
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_10_percent,gtv_indices.idx_10_percent);
    registered_tumours.phase_10 = registered_tumour;
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_20_percent,gtv_indices.idx_20_percent);
    registered_tumours.phase_20 = registered_tumour;
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_30_percent,gtv_indices.idx_30_percent);
    registered_tumours.phase_30 = registered_tumour;
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_40_percent,gtv_indices.idx_40_percent);
    registered_tumours.phase_40 = registered_tumour;
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_50_percent,gtv_indices.idx_50_percent);
    registered_tumours.phase_50 = registered_tumour;
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_60_percent,gtv_indices.idx_60_percent);
    registered_tumours.phase_60 = registered_tumour;
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_70_percent,gtv_indices.idx_70_percent);
    registered_tumours.phase_70 = registered_tumour;
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_80_percent,gtv_indices.idx_80_percent);
    registered_tumours.phase_80 = registered_tumour;
    
    registered_tumour = register_gtv(names,segmentations,staple_indices.idx_90_percent,gtv_indices.idx_90_percent);
    registered_tumours.phase_90 = registered_tumour;
    
    date_str = date;
    filename = sprintf( '../../Data/registered_gtvs_patient_%02d_%s.mat', [i date_str] );
    save(filename,'registered_tumours');
end