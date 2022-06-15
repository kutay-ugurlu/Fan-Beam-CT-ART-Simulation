function f_next = sart_update(A,f, PROJECTIONS)
tic
[nrows, ~] = size(A);
for i = 1:nrows
    row = A(i,:);
    if row*row' ~= 0
        f = f + row'*(PROJECTIONS(i)-row*f)/(row*row');
    end
end
f_next = f;
toc
end