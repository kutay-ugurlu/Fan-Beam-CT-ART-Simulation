function if_stop = early_stopper(errors, patience)
l = length(errors);
last_n_steps = min(l,patience);
last_n_errors = errors(end-last_n_steps+1:end);
if_stop = all([diff(last_n_errors) 0]);
