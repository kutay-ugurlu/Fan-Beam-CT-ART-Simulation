function [Image_back, errors] = sart(phantom_name,L_det,N_det,angle_step,source2det_dist,use_window, if_relax, n_iter, if_show, patience, axes)
[PROJECTIONS, ~] = radon_project(phantom_name,L_det, N_det, angle_step, source2det_dist);
I = struct2array(load(phantom_name));
A = sart_matrix(I,L_det,N_det,angle_step,source2det_dist,use_window);
Image_size = size(I,1);
[Image_back, errors] = sart_reconstruct(Image_size, A, if_relax, n_iter, PROJECTIONS, I, if_show, patience, axes);
Image_back = imrotate(Image_back,90);

