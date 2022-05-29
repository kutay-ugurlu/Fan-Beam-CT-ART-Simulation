function error = reconstruction_error(original_image, reconstructed_image)
error = norm(original_image-reconstructed_image)/norm(original_image);