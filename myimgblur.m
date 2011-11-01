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
        
        % crop the convolved image to original size        
        HalfWidth = floor(WindowSize/2);
        
        MinX = HalfWidth + 1;
        MaxX = size(Img, 2) + HalfWidth;
        
        MinY = HalfWidth + 1;
        MaxY = size(Img, 1) + HalfWidth;
        
        Out = Img;
        for i = 1:3
            F = conv2(Img(:,:,i), Filter);
            Out(:,:,i) = F(MinY:MaxY, MinX:MaxX);
        end
    end