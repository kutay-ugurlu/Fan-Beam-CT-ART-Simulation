function [pixels, given_point_idx, f_interp, t, u] = find_closest_pixels_interpolate(X_grid, point, I)
right_end = X_grid(end);
point_x = point(1);
point_y = point(2);

row_pixel_index = right_end - floor(point_y);
column_pixel_index = right_end + ceil(point_x);

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

% I = padarray(I,[1 1],0,'both');

t = (point_x-mid_X(1))/(mid_X(2)-mid_X(1));
u = (point_y-mid_Y(1))/(mid_Y(2)-mid_Y(1));

if t>1 || u>1
    f_interp = I(row_pixel_index,column_pixel_index);
else
f_interp = u*t*I(pixels(1,1),pixels(1,2)) + (1-u)*t*I(pixels(3,1),pixels(3,2)) ...
    + (1-t)*u*I(pixels(2,1),pixels(2,2)) + (1-u)*(1-t)*I(pixels(4,1),pixels(4,2));
end
given_point_idx = [row_pixel_index column_pixel_index];