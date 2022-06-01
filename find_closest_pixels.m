function [pixels, given_point_idx, f_interp] = find_closest_pixels(X_grid, point, I)
right_end = X_grid(end);
point_x = point(1);
point_y = point(2);

row_pixel_index = right_end - floor(point_x);
column_pixel_index = right_end + ceil(point_y);

X_centers = movsum(X_grid,2) * 0.5;
X_centers = X_centers(2:end);
Y_centers = X_centers;

[~, min_idx_x] = mink(X_centers-point_x,2,'ComparisonMethod','abs');
[~, min_idx_y] = mink(Y_centers-point_y,2,'ComparisonMethod','abs');

mid_X = sort(X_centers(min_idx_x));
mid_Y = sort(Y_centers(min_idx_y));

idx_x = right_end - floor(mid_X);
idx_y = right_end + ceil(mid_Y);

pixels = [idx_x(1) idx_y(1);
        idx_x(1) idx_y(2);
        idx_x(2) idx_y(1);
        idx_x(2) idx_y(2)
        ];

t = (point_x-mid_X(1))/(mid_X(2)-mid_X(1));
u = (point_y-mid_Y(1))/(mid_Y(2)-mid_Y(1));
f_interp = u*t*I(pixels(1,:)) + (1-u)*t*I(pixels(3)) ...
    + (1-t)*u*I(pixels(2)) + (1-u)*(1-t)*I(pixels(4));

given_point_idx = [row_pixel_index column_pixel_index];