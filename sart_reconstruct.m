function [IMAGE] = sart_reconstruct(Image_size, A, if_relax, n_iter, PROJECTIONS)

if if_relax
    alpha = 1e-4;
else
    alpha = 1e-4;
end

% PROJECTIONS = PROJECTIONS';
PROJECTIONS = PROJECTIONS(:);
f = zeros(Image_size^2,1);
% L_proj = size(A,1);
for i = 1:n_iter
%     for j = 1:L_proj
%         if A(j,:)*A(j,:)' ~=0 % Check the norm of the row vector
%             f = f - alpha*((A(j,:)*f-PROJECTIONS(j))/(A(j,:)*A(j,:)')*A(j,:))';
%         end
%         f(f<0) = 0; % Error correction in each step using the nonnegativity information prior
%     end
    
    f = f - alpha*A'*(A*f-PROJECTIONS);
    f(f<0) = 0;

    IMAGE = (reshape(f,Image_size,Image_size));
    imagesc(imrotate(mat2gray(IMAGE),90)), colormap gray
    title(['Iteration #',num2str(i),'/',num2str(n_iter)])
    drawnow
    if sum(isinf(IMAGE),'all') || sum(isnan(IMAGE),'all')
        disp('STOP')
    end

end

