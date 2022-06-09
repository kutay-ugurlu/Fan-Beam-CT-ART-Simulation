%% Sart
close all; clear; clc;
I = struct2array(load('C:\Users\Kutay\Desktop\Fan-Beam-CT-ART-Simulation\Phantoms\SheppLogan.mat'));
L_det = 500;
N_det = 100;
angle_step = 2;
source2det_dist = 500;
use_window = 1;
if_relax = 1;
A = sart_matrix(I,L_det,N_det,angle_step,source2det_dist,use_window);
sart_Projections = sart_project(I,L_det,N_det,angle_step,source2det_dist);
Image_back = sart_reconstruct(size(I,1),A,if_relax,50,sart_Projections);
figure
imagesc(I)