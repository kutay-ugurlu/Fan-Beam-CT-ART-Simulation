%% SART EXPERIMENTS

close all; clear; clc;
paths = ["Phantoms/SheppLogan.mat","Phantoms/square.mat","Phantoms/lena_cropped.mat"];
phantom_names = ["SheppLogan","Square","Lena"];
errors = {}; recs = {};
L_det = 200;
N_det = 100;
angle_step = 2;
source2det_dist = 200;
n_iter = 200;
alpha = 0.2;
i = 0;
show_plot = 0;
threshold = 0;
patience = 50;
SSIMs = [];
for phantom_path = paths
    I = struct2array(load(phantom_path));
    N = size(I,1);
    highq_proj = radon_project(phantom_path,L_det,N_det,angle_step,source2det_dist);
    i = i+1;
    L_det = 200;
    N_det = 200;
    angle_step = 2;
    use_window = 1;
    if_relax = 1;
    source2det_dist = 200;
    Npix = size(I,1);
    n_iter = 10;
    alpha = 0.2;
    if_show = 0;
    [sart_rec, sart_error] = sart(phantom_path,L_det,N_det,angle_step,source2det_dist,use_window, if_relax, n_iter, if_show, patience);
    errors{end+1} = sart_error;
    subplot(3,2,2*i-1)
    imagesc(sart_rec), colormap gray
    title(phantom_names(i))
    subplot(3,2,2*i)
    plot(sart_error)
    title('Relative Error')
    SSIMs(end+1) = ssim(sart_rec,I);
end
sgtitle('Classical SIRT Reconstructions')