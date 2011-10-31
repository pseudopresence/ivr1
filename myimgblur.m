function [Out] = myimgblur(Img, WindowSize, BlurWidth)
    global HaveToolbox;
    if HaveToolbox
        Filter = fspecial('gaussian', [WindowSize WindowSize], BlurWidth);
        Out = imfilter(Img, Filter, 'symmetric', 'conv');
    else
        % Correct between the width parameter of fspecial and the one of
        % mygausswin :(
        BlurWidth = WindowSize / BlurWidth;
        
        Filter = mygausswin(WindowSize, BlurWidth) * mygausswin(WindowSize, BlurWidth)';
        Filter = Filter / sum(reshape(Filter,1,numel(Filter)));
        
        FR = conv2(Img(:,:,1), Filter);
        FG = conv2(Img(:,:,2), Filter);
        FB = conv2(Img(:,:,3), Filter);

        % crop the convolved image to original size        
        HalfWidth = floor(WindowSize/2);
        
        MinX = HalfWidth + 1;
        MaxX = size(Img, 2) + HalfWidth;
        
        MinY = HalfWidth + 1;
        MaxY = size(Img, 1) + HalfWidth;
        
        Out = Img;
        Out(:,:,1) = FR(MinY:MaxY, MinX:MaxX);
        Out(:,:,2) = FG(MinY:MaxY, MinX:MaxX);
        Out(:,:,3) = FB(MinY:MaxY, MinX:MaxX);
    end