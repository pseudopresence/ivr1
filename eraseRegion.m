function [Out] = eraseRegion(Img, C, Size)
    Out = Img;
    t = max(1, C(1) - Size/2);
    b = min(size(Img, 1), C(1) + Size/2);
    l = max(1, C(2) - Size/2);
    r = min(size(Img, 2), C(2) + Size/2);
    Avg = Img(t, l, :) + Img(t, r, :) + Img(b, l, :) + Img(b, r, :);
    Avg = Avg / 4;
    for y = t:b
        for x = l:r
            Out(y, x, :) = Avg;
        end
    end
    