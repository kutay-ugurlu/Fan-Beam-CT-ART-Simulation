%% SIRT EXPERIMENTS

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
sirt_ssims = [];
N_dets = [100,100,200];
for phantom_path = paths
    I = struct2array(load(phantom_path));
    N = size(I,1);
    highq_proj = radon_project(phantom_path,L_det,N_det,angle_step,source2det_dist);
    i = i+1;
    L_det = 200;
    N_det = N_dets(i);
    angle_step = 2;
    source2det_dist = 200;
    Npix = size(I,1);
    n_iter = 200;
    alpha = 0.2;
    [~, sirt_rec, sirt_error] =  sirtv2(N, N, highq_proj, L_det, source2det_dist, n_iter, show_plot, I, patience);
    errors{end+1} = sirt_error;
    subplot(3,2,2*i-1)
    imagesc(sirt_rec), colormap gray
    title(phantom_names(i))
    subplot(3,2,2*i)
    plot(sirt_error)
    xlabel('Iterations')
    title('Relative Error')
    sirt_ssims(end+1) = ssim(sirt_rec,I);
end
sgtitle('SIRT Reconstructions')