function [IMAGE] = sart_reconstruct(Image_size, A, if_relax, n_iter, PROJECTIONS)

if if_relax
    alpha = 1/n_iter;
else
    alpha = 1;
end

% PROJECTIONS = PROJECTIONS';
PROJECTIONS = PROJECTIONS(:);
f = rand(Image_size^2,1);
L_proj = length(PROJECTIONS);
for i = 1:n_iter
    for j = 1:L_proj
        if A(j,:)*A(j,:)' ~=0 % Check the norm of the row vector
        f = f - alpha*((A(j,:)*f-PROJECTIONS(j))/(A(j,:)*A(j,:)')*A(j,:))';
        end
        f(f<0) = 0; % Error correction in each step using the nonnegativity information prior
    end
    IMAGE = reshape(f,Image_size,Image_size);
    imagesc(mat2gray(IMAGE)), colormap gray
    title(['Iteration #',num2str(i),'/',num2str(n_iter)])
    drawnow
end

end
