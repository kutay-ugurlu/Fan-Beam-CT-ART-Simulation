function [f_next, delta_f, f] = update_eqn(w,f,p)
delta_f = - (f'*w - p)*w/(w'*w);
f_next = f + delta_f;
end


