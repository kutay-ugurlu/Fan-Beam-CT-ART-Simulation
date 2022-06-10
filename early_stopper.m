function if_stop = early_stopper(errors, patience)
l = length(errors(1:find(errors,1,'last')));
if l < patience
    if_stop = 0;
    return
end
last_n_steps = min(l,patience);
last_n_errors = errors(1:find(errors,1,'last'));
last_errors = last_n_errors(end-last_n_steps+1:end);
diff_errors = diff(last_errors);
if_stop = all(diff_errors >= 0);