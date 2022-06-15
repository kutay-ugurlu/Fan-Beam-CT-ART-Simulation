function [IMAGE, errors] = sart_reconstruct(Image_size, A, if_relax, n_iter, PROJECTIONS, Original_Image, if_show, patience, axes)

if nargin < 9
    axes = gca;
end

if if_relax
    alpha = 2/norm(A'*A,"fro");
else
    alpha = 1e-4;
end

PROJECTIONS = PROJECTIONS(:);
f = zeros(Image_size^2,1);
errors = zeros(1,n_iter);
for iter = 1:n_iter
    f = f - alpha*A'*(A*f-PROJECTIONS);
%     f = sart_update(A,f,PROJECTIONS);
    f(f<0) = 0;
    IMAGE = (reshape(f,Image_size,Image_size));
    errors(iter) = reconstruction_error(Original_Image ,IMAGE);
    
    if errors(end) == min(errors)
        IMAGE_best = IMAGE;
    end

    if early_stopper(errors,patience)
        display(['Early stopping at iteration ',num2str(iter)])
        errors = errors(1:find(errors,1,'last'));
        IMAGE = IMAGE_best;
    return
    end
    
    if if_show 
        imagesc(axes,imrotate(IMAGE,90)); colormap(axes,"gray")
        title(axes,{['Iteration ',num2str(iter),' completed.']})
        hold on 
        drawnow
    end

end
errors = errors(1:find(errors,1,'last'));
end

