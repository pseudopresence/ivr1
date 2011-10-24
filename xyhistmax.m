function [C, T] = xyhistmax(Img)
    % find the maximum value along each axis
    XHist = max(Img, [], 1)';
    YHist = max(Img, [], 2);
    % convolve it to get some smoothing
    XHist = convhist(XHist, 20, 5);
    YHist = convhist(YHist, 20, 5);

    C = [0 0];
    % find the maximum along each axis
    C(1) = find(YHist == max(YHist));
    C(2) = find(XHist == max(XHist));
    
    % find the range around this value where the axis max is within some
    % threshold of the max
    
   C(1) = round(mean(find(YHist > 0.9 * max(YHist))));
   C(2) = round(mean(find(XHist > 0.9 * max(XHist))));
   T = 0.75 * min(max(YHist), max(XHist));