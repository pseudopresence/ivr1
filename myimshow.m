function [] = myimshow(Img)
    global HaveToolbox;
    if HaveToolbox
        imshow(Img);
    else
        imagesc(Img);
        axis image;
        axis ij;
        axis off;
    end