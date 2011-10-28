function [Out] = windowmedian(Img, WindowSize)
    Out = zeros(size(Img), class(Img));
    HalfWindow = WindowSize / 2;
    [H, W, C] = size(Img);
    for iy = 1:H
        windowMinY = max(1, iy-HalfWindow+1);
        windowMaxY = min(H, iy+HalfWindow);
        for ix = 1:W
            windowMinX = max(1, ix-HalfWindow+1);
            windowMaxX = min(W, ix+HalfWindow);
            for c = 1:C
                I = Img(windowMinY:windowMaxY, windowMinX:windowMaxX, c);
                S = numel(I);
                Out(iy, ix, c) = median(reshape(I, 1, S));
            end
        end
    end
end
