mex CC=g++ ac_tridiagonal_Thomas_dll.cpp
% mex ac_fast_marching_3d_dll.cpp
mex CC=g++ ac_div_AOS_3D_dll.cpp
mex CC=g++ zy_binary_boundary_detection.c
mex CC=g++ ac_linear_diffusion_AOS_2D_dll.cpp
mex CC=g++ ac_linear_diffusion_AOS_3D_dll.cpp
mex CC=g++ ac_distance_transform_3d.cpp

movefile('*.mex*', '../private')
