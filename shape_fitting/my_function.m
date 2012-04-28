function [shape_dist] = my_function(alpha)
[X,Y,Z] = meshgrid(-10:10,-11:12,-9:11);
[phi_init] = make_torus(6,4,X,Y,Z);

beta =0;gamma=0; a=0;b=0;c=0;r=1;
[psi0] = transform_surface( phi_init,0.3,beta,gamma,a,b,c,r,X,Y,Z );

phi = transform_surface( phi_init,alpha,beta,gamma,a,b,c,r,X,Y,Z );
delta_x = 1;
Hpsi0 = heaviside_im(psi0,delta_x);
Hphi = heaviside_im(phi,delta_x);
dirac_psi = dirac_im(psi0,delta_x);%dirac_im(psi,delta_x);
    
Hpsi_sub_Hphi = (Hpsi0 - Hphi).*dirac_psi;
shape_dist = sum(Hpsi_sub_Hphi(:));

end