%% Sample outputs
close all; clear; clc;

sample_names = ["Phantoms/square"];
projection_angle_step_size = 2;
N_detectors = 500;
for sample = sample_names
I = struct2array(load(sample));
[RowNumber_I, ColumnNumber_I] = size(I);
L_detector = RowNumber_I * sqrt(3);
source2det_dist = L_detector;
folder_file = split(sample,'/');
phantom_name = folder_file{2};
[PROJECTIONS, ~] = radon_project(sample,L_detector, N_detectors, projection_angle_step_size, source2det_dist);
RI = (back_projection(RowNumber_I, ColumnNumber_I, PROJECTIONS, L_detector, source2det_dist, N_detectors));
RH = (filtered_back_projection_hamm(RowNumber_I, ColumnNumber_I, PROJECTIONS, L_detector, source2det_dist, N_detectors));
end