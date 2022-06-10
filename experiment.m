%% ART and SIRT
close all; clear; clc;
phantom_path = 'Phantoms/SheppLogan.mat';
I = struct2array(load(phantom_path));
L_det = 200;
N_det = 100;
angle_step = 2;
source2det_dist = 200;
Npix = size(I,1);
n_iter = 200;
alpha = 0.2;
highq_proj = radon_project(phantom_path,L_det,N_det,angle_step,source2det_dist);
f1 = figure;
[art_rec, art_error] = art(Npix,Npix,highq_proj,L_det,source2det_dist,n_iter,1,I,20,alpha);
f2 = figure;
threshold = 0;
[bart_rec, bart_error] = binary_weighted_art(Npix,Npix,highq_proj,L_det,source2det_dist,n_iter,1,I,20,alpha,threshold);
f3 = figure;
[SIRT_mat, sirt_rec, sirt_error] = sirtv2(Npix,Npix,highq_proj,L_det,source2det_dist,n_iter,1,I,20);
figure
plot(art_error)
hold on 
plot(sirt_error)
hold on 
plot(bart_error)
title('Reconstruction Error in Relative Error metric')
legend('ART','SIRT','Binary weighted ART')

%% Bart 
i = 1;
Errors = {};
for threshold = [0,0.2,0.5]
    [bart_rec, bart_error] = binary_weighted_art(Npix,Npix,highq_proj,L_det,source2det_dist,n_iter,1,I,20,alpha,threshold);
    Errors{end+1} = bart_error;
    subplot(1,3,i)
    imagesc(bart_rec)
    i = i+1 ; 
end

%% SART
close all; clear; clc;
I = struct2array(load('C:\Users\Kutay\Desktop\Fan-Beam-CT-ART-Simulation\Phantoms\SheppLogan.mat'));
L_det = 200;
n_iter = 200;
N_det = 200;
angle_step = 1;
source2det_dist = 200;
use_window = 1;
if_relax = 1;
[errors, Image_back] = sart('Phantoms/square',L_det,N_det,angle_step,source2det_dist,use_window,if_relax,n_iter);

