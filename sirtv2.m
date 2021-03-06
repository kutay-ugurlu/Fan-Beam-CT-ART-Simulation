%% PART 2 : RECONSTRUCTION
% Inputs : Size of the image, Projection matrix.
% Outputs : Image

function [A, IMAGE, errors] = sirtv2(RowNumber_I, ColumnNumber_I, PROJECTIONS, L_detector, source2det_dist, n_iter, show_plot, Original_Image, patience, axes)

if nargin<10
    axes = gca;
end

N_detectors = size(PROJECTIONS,1);
total_number_of_projections = size(PROJECTIONS,2);
projection_angle_step_size = 360 / total_number_of_projections;
D = source2det_dist*0.5;
FOV = L_detector*360/(2*pi*D);
angle_between_detectors = FOV / (N_detectors-1);
left_end = -0.5*RowNumber_I;
right_end = -1 * left_end;
X_grid = left_end : right_end;
Y_grid = X_grid;
thetas = deg2rad(0:projection_angle_step_size:360-projection_angle_step_size); 
gammas = deg2rad(-0.5*FOV:angle_between_detectors:0.5*FOV); 
L_gammas = length(gammas);
L_thetas = length(thetas);
f = rand(RowNumber_I*ColumnNumber_I,1);
errors = zeros(1,n_iter);
sparsity_ratio = 2/RowNumber_I;
n_eqn = numel(PROJECTIONS);
A = (spalloc(n_eqn,RowNumber_I*ColumnNumber_I,numel(PROJECTIONS)*RowNumber_I*ColumnNumber_I*sparsity_ratio));

Deltas = zeros(size(f));
Counter = Deltas;
disp('A is being generated.')
tic
for angle = 1:L_thetas
    theta = thetas(angle);
    for ray = 1:L_gammas
        gamma = gammas(ray);   
        %%
        % Creating intersection vectors for each angle using the equation
        % _t_ = cos($$ \  \theta $$)  _x_  +  sin($$ \  \theta $$)  _y_

        intersect_y = ((D*sin(gamma) - X_grid * cos(theta+gamma)) / sin(theta+gamma));
        intersect_x = ((D*sin(gamma) - Y_grid * sin(theta+gamma)) / cos(theta+gamma));
        %%
        % Putting the sorted intersections in a matrix where first column is x,
        % second is y and merge them: 
        INTERSECTS_x = [X_grid'  intersect_y'];
        INTERSECTS_y = [intersect_x'  Y_grid'];
        INTERSECTS_all = [INTERSECTS_x ; INTERSECTS_y];
        % INTERSECTS_all = sortrows(unique(INTERSECTS_all,'rows'));
        INTERSECTS_all = sortrows(uniquetol(INTERSECTS_all,'ByRows',1e-10));
        % The above line is for Lena

        %%
        % Discarding the intersections out of the grid by conditionally
        % selecting the rows
        INTERSECTS_all = INTERSECTS_all(INTERSECTS_all(:,1)>=left_end & INTERSECTS_all(:,1)<=right_end & INTERSECTS_all(:,2)>=left_end & INTERSECTS_all(:,2)<=right_end,:);
        %%
        % Assigning 0 projection value for 1 point intersections.
        if size(INTERSECTS_all,1) < 2
        continue
        end
        %%
        % Using Pisagor to compute distances travelled in pixels by
        % computing the $$ l_2 $$ norm row vectors of intersection matrix
        weights = vecnorm(diff(INTERSECTS_all),2,2); 
        %%
        % Arithmetic mean of consecutive elements to find mid point: To
        % find the mid point between consecutive intersections, 2 point
        % moving average is used with factor 0.5.
        midpoints_x = movsum(INTERSECTS_all(:,1),2) * 0.5;
        midpoints_y = movsum(INTERSECTS_all(:,2),2) * 0.5;
        
        %%
        % MATLAB function movesum padds a 0 to the beginning of the
        % vector. To get rid of this extra entry at the beginning, vectors
        % are sliced.
        % This block of code is problematic when there is 1 intersection. 
        % Hence, if block above is added.
        midpoints_y = midpoints_y(2:end); 
        midpoints_x = midpoints_x(2:end);
        
        %%
        % The pixels that beam passes through are found.
        row_pixel_indices = right_end - floor(midpoints_y);
        column_pixel_indices = right_end + ceil(midpoints_x);
        PIXELS = [row_pixel_indices column_pixel_indices];
        LEXI = pixel_to_lexicographic_index(PIXELS(:,1),PIXELS(:,2),RowNumber_I,ColumnNumber_I);
        W = zeros(RowNumber_I*ColumnNumber_I,1);
        W(LEXI) = weights;
    
        index = L_gammas*(angle-1)+ray;
        A(index,:) = W; 

    end
end
toc

%% A is generated, now reconstruction loop  
disp('Computation of system matrix is completed.')
PROJECTIONS = PROJECTIONS(:);
alpha = 2/norm(A'*A,'fro');
for iter = 1:n_iter

    f = f - alpha*A'*(A*f-PROJECTIONS);
    f(f<0) = 0;
    IMAGE = mat2gray(reshape(f,RowNumber_I,ColumnNumber_I)); 
    errors(iter) = reconstruction_error(Original_Image,IMAGE);
    
    if errors(end) == min(errors)
        IMAGE_best = IMAGE;
    end

    if early_stopper(errors,patience)
        display(['Early stopping at iteration ',num2str(iter)])
        errors = errors(1:find(errors,1,'last'));
        IMAGE = IMAGE_best;
    return
    end

    if show_plot 
        imagesc(axes,IMAGE); colormap(axes,"gray")
        title(axes,{['Iteration ',num2str(iter),' completed.']})
        hold on 
        drawnow
    end

end
errors = errors(1:find(errors,1,'last'));

end

