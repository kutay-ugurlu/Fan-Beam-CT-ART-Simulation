function f_next = update_eqn(w,f,p)
f_next = f - (f'*w - p)*w/(w'*w);
end


