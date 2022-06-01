function [A] = sart_matrix(I,L_detector, N_detectors, projection_angle_step_size, source2det_dist, use_window)
%% Parameter checks
if size(I,1)*sqrt(2) > source2det_dist
error('Phantom does not fit between source and detector!')
end
%% Getting relevant parameters from image.
% Using size function to arrange beams.
D = source2det_dist*0.5;
[M,~] = size(I);
left_end = M * -0.5;
right_end = M * 0.5;
FOV = L_detector*360/(2*pi*D);
angle_between_detectors = FOV / (N_detectors-1);

%% Forming angle, t and grid vectors.
% Vectors that are going to be iterated are formed here. 

thetas = deg2rad(0:projection_angle_step_size:360-projection_angle_step_size); 
gammas = deg2rad(-0.5*FOV:angle_between_detectors:0.5*FOV) ; 
X_grid = left_end : right_end;
Y_grid = X_grid;
L_gammas = length(gammas);
L_thetas = length(thetas);
%% PROJECTIONS matrix to store the projection values:
% A matrix that is going to store the projection values are formed here
% with rows representing beams and columns representing projection angles.
A = zeros(length(gammas)*length(thetas),M^2);

%% Main Loop
% There are 2 loops passing through each beam and angle to compute the
% projection value. First loop iterates on angle values and the second loop
% interates on beams.
for angle = 1:L_thetas
    theta = thetas(angle);
    for ray = 1:L_gammas
        gamma = gammas(ray);   
        %% Creating intersection vectors for each angle using the equation
        % D sin(gamma) = x cos(theta+gamma) + y sin(theta+gamma)
        intersect_x_with_grid = ((D*sin(gamma) - Y_grid * sin(theta+gamma)) / cos(theta+gamma));
        intersect_x = linspace(min(intersect_x_with_grid),max(intersect_x_with_grid),M);
        intersect_y = ((D*sin(gamma) - intersect_x * cos(theta+gamma)) / sin(theta+gamma));
        delta_s = sqrt((intersect_x(1)-intersect_x(2))^2+(intersect_y(1)-intersect_y(2))^2);

        %% Bilinear interpolation variables
        x1 = floor(intersect_x) + right_end;
        x2 = ceil(intersect_x) + right_end;
        y1 = floor(intersect_x) + right_end;
        y2 = ceil(intersect_x) + right_end;

        t = (intersect_x - x1)./(x2-x1);
        u = (intersect_y - y1)./(y2-y1);

        %% Select window 
        if use_window 
            win = hamming(length(intersect_x));
        else
            win = ones(size(intersect_x));
        end

        %% Fill matrix A with bilinear interpolation
        for idx = 1:length(intersect_x)
            if x1(idx) > 0 && y1(idx) > 0 && x1(idx) <= right_end && x1(idx) <= right_end
                   A((angle-1)*L_gammas+ray,y1(idx)+(x1(idx)-1)*M) = win(idx)*delta_s*(1-t(idx))*(1-u(idx)) + A((angle-1)*L_gammas+ray,x1(idx)+(y1(idx)-1)*M);
                   A((angle-1)*L_gammas+ray,y1(idx)+(x1(idx)-1)*M) = win(idx)*delta_s*(t(idx))*(1-u(idx)) + A((angle-1)*L_gammas+ray,x1(idx)+(y1(idx)-1)*M);
                   A((angle-1)*L_gammas+ray,y1(idx)+(x1(idx)-1)*M) = win(idx)*delta_s*(1-t(idx))*(u(idx)) + A((angle-1)*L_gammas+ray,x1(idx)+(y1(idx)-1)*M);
                   A((angle-1)*L_gammas+ray,y1(idx)+(x1(idx)-1)*M) = win(idx)*delta_s*(t(idx))*(u(idx)) + A((angle-1)*L_gammas+ray,x1(idx)+(y1(idx)-1)*M);
            end
        end
    end
end
end