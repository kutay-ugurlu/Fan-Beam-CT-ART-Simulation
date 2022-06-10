function [f_next, delta_f, f] = update_eqn(w,f,p, alpha)
delta_f = - alpha * ((f'*w - p)/(w'*w)) * w;
f_next = f + delta_f;
end


