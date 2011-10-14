function [OutImage] = adapt(Image, WindowSize, MagicNumber)
    [H,W] = size(Image);
    OutImage = zeros(H,W);
    N2 = floor(WindowSize/2);
    for i = 1+N2 : H-N2
      for j = 1+N2 : W-N2
        % extract subimage
        subimage = Image(i-N2:i+N2,j-N2:j+N2);
        threshold = mean(mean(subimage)) - MagicNumber;
        if Image(i,j) < threshold
         OutImage(i,j) = 1;
        else
         OutImage(i,j) = 0;
        end
      end
    end
