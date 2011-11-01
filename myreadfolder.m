function Imgs = myreadfolder(Folder, Count)
    % Load a first image to use for format and size
    TestImg = myreadimg(Folder, 1);
    % zero-initialise an input matrix of the right size and type
    Imgs = zeros(size(TestImg,1), size(TestImg,2), size(TestImg,3), Count, class(TestImg));
    % read in all the images
    for I = 1:Count
        Imgs(:, :, :, I) = myreadimg(Folder, I);
    end