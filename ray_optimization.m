function mixed_ray = ray_optimization(rays)
N = length(rays);
mid = 0.5*N;
upper_row_idx = 1:(mid);
lower_row_idx = (mid+1):N;
upper_row = upsample(rays(upper_row_idx),2);
lower_row = circshift(upsample(rays(lower_row_idx),2),1);
mixed_ray = sum([upper_row;lower_row],1);
