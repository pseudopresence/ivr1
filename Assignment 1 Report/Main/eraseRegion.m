function [Out] = eraseRegion(Img, C, Size)
    Out = Img;
    %Find the pixels on the vertices of the bounding box
    %surrounding the robot. top-t, bottom-b, left-l, right-r
    t = max(1, C(1) - Size/2);
    b = min(size(Img, 1), C(1) + Size/2);
    l = max(1, C(2) - Size/2);
    r = min(size(Img, 2), C(2) + Size/2);
    %Find the average of the four pixels at the vertices of the
    %bounding box
    Avg = Img(t, l, :) + Img(t, r, :) + Img(b, l, :) + Img(b, r, :);
    Avg = Avg / 4;
    %Replace the image segment (I.e. the robot) with the average
    %of the four pixels
    for y = t:b
        for x = l:r
            Out(y, x, :) = Avg;
        end
    end
    