% Note: this isn't strictly a histogram, couldn't think of a better word.
function [C, T] = xyhistmax(Img)
    % find the maximum value along each axis
    XHist = max(Img, [], 1)';
    YHist = max(Img, [], 2);
    % convolve it to get some smoothing
    XHist = convhist(XHist, 20, 5);
    YHist = convhist(YHist, 20, 5);

    C = [0 0];
    Max = [0 0];
    
    % find the maximum along each axis
    Max(1) = max(YHist);
    Max(2) = max(XHist);
    
    % find the range around this value where the axis max is within some
    % threshold of the max
    
    YExtent = find(YHist > 0.9 * Max(1));
    XExtent = find(XHist > 0.9 * Max(2));
    C(1) = round(mean(YExtent));
    C(2) = round(mean(XExtent));
    T = 0.75 * min(Max(1), Max(2));
