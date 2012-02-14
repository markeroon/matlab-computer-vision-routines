DAY = 82;
addpath( '~/Code/file_management' );

for i=0:11
    filename = sprintf( '20100204-0000%2d-%03d.3pi', [DAY i] );
    [X,Y,Z,gray_val] = import3Pi( filename );
    % remove ground plane

    exportOffFile(X,Y,Z,sprintf('plants_converted%2d-%03d.off', [DAY i]) );
end

