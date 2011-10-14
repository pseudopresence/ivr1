function [OutImg] = normalize_rgb(Img)
    OutImg = zeros(size(Img));
    % SumImg = sum(Img, 3);
    [H,W,C] = size(Img);
    SumImg = zeros(H, W);
    ColW = [0.3 0.59 0.11] * 2;
    % ColW = [1.0 1.0 1.0];
    for i = 1:3
        SumImg = SumImg + Img(:,:,i) .* ColW(i);
    end
    for i = 1:3
        OutImg(:,:,i) = Img(:,:,i) ./ SumImg;
    end
