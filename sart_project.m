function [PROJECTIONS] = sart_project(I,L_detector, N_detectors, projection_angle_step_size, source2det_dist)
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
PROJECTIONS = zeros(length(gammas),length(thetas));

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

        INTERSECTS_all = [intersect_x' intersect_y'];
        INTERSECTS_all = sortrows(uniquetol(INTERSECTS_all,'ByRows',1e-10));
        INTERSECTS_all = INTERSECTS_all(INTERSECTS_all(:,1)>left_end & INTERSECTS_all(:,1)<right_end & INTERSECTS_all(:,2)>left_end & INTERSECTS_all(:,2)<right_end,:);
        intersect_x = INTERSECTS_all(:,1);
        intersect_y = INTERSECTS_all(:,2);
        if size(INTERSECTS_all,1) == 1 || size(INTERSECTS_all,1) == 0
        PROJECTIONS(ray,angle) = 0;
        continue
        end

      %% Write Projections
      intersect_x = intersect_x(2:(end-1)); % Discard the end points 
      intersect_y = intersect_y(2:(end-1));
      interpolated_points = zeros(size(intersect_x));
      for point = 1:length(intersect_x) 
          [~, ~, f_interp, ~, ~] = find_closest_pixels_interpolate(X_grid,[intersect_x(point) intersect_y(point)],I);
          interpolated_points(point) = f_interp; 
      end
      PROJECTIONS(ray,angle) = sum(interpolated_points) * delta_s;
    end
end
