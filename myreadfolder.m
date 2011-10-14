function Imgs = myreadfolder(folder, count)
    % Load a first image to use for format and size
    test_img = myreadimg(folder, 1);
    % zero-initialise an input matrix of the right size and type
    Imgs = zeros(size(test_img,1), size(test_img,2), size(test_img,3), count, class(test_img));
    % read in all the images
    for i = 1:count
        Imgs(:, :, :, i) = myreadimg(folder, i);
    end