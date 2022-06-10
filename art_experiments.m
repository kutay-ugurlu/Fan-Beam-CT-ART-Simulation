%% Bart experiments
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
bart_ssims = [];
figure
for phantom_path = paths
    I = struct2array(load(phantom_path));
    N = size(I,1);
    highq_proj = radon_project(phantom_path,L_det,N_det,angle_step,source2det_dist);
    i = i+1;
    L_det = 200;
    N_det = 100;
    angle_step = 2;
    source2det_dist = 200;
    Npix = size(I,1);
    n_iter = 200;
    alpha = 0.2;
    [bart_rec, bart_error] =  binary_weighted_art(N, N, highq_proj, L_det, source2det_dist, n_iter, show_plot, I, patience, alpha, threshold, axes);
    errors{end+1} = bart_error;
    bart_ssims(end+1) = ssim(bart_rec,I);
    subplot(3,2,2*i-1)
    imagesc(bart_rec), colormap gray
    title(phantom_names(i))
    subplot(3,2,2*i)
    plot(bart_error)
    xlabel('Iterations')
    title('Relative Error')
end
sgtitle('Classical ART Reconstructions')

%% Art experiments
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
art_ssims = [];
figure
for phantom_path = paths
    I = struct2array(load(phantom_path));
    N = size(I,1);
    highq_proj = radon_project(phantom_path,L_det,N_det,angle_step,source2det_dist);
    i = i+1;
    L_det = 200;
    N_det = 100;
    angle_step = 2;
    source2det_dist = 200;
    Npix = size(I,1);
    n_iter = 200;
    alpha = 0.2;
    [art_rec, art_error] = art(N, N, highq_proj, L_det, source2det_dist, n_iter, show_plot, I, patience, alpha);
    errors{end+1} = art_error;
    art_ssims(end+1) = ssim(art_rec,I);
    subplot(3,2,2*i-1)
    imagesc(art_rec), colormap gray
    title(phantom_names(i))
    subplot(3,2,2*i)
    plot(art_error)
    xlabel('Iterations')
    title('Relative Error')
end
sgtitle('Modified ART Reconstructions')