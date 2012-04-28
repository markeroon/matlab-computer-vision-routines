function [ JL,JR ] = warpPairToReferenceFrame( I_ref,pm_ref,IL,pml,IR,pmr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    [ T_ref,TL ] = warpPairToReferenceView( I_ref,pm_ref,IL,pml );
    [ T_ref2,TL2 ] = warpPairToReferenceView( I_ref,pm_ref,IR,pmr );

    bb = mcbb(size(IL),size(IR), TL, TL2);
    for c = 1:3
        % Warp LEFT
        [JL(:,:,c),bbL,alphaL] = imwarp(IL(:,:,c), TL, 'bilinear', bb);
        % Warp RIGHT
        [JR(:,:,c),bbR,alphaR] = imwarp(IR(:,:,c), TL2, 'bilinear', bb);
    end
end