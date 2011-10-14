function [OutImg] = normalize_rgb(Img)
    OutImg = zeros(size(Img));
    SumImg = sum(Img, 3);
    for i = 1:3
        OutImg(:,:,i) = Img(:,:,i) ./ SumImg;
    end
