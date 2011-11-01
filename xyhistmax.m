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

%     hFig = figure(2);
%     clf();
%     set(hFig, 'Position', [0 0 640 480]);
%     axis([0, 640, 0, 1]);
%     hold on;
%     plot(XHist, 'r');
%     
%     line([0 640], [Max(2) Max(2)], 'Color', [0 0 0]);
%     line([0 640], [0.9*Max(2) 0.9*Max(2)]);
%     line([0 640], [T T], 'Color', [0 0 0]);
%     line([C(2) C(2)], [0 0.9*Max(2)]);
%     line([min(XExtent) min(XExtent)], [0 0.9*Max(2)]);
%     line([max(XExtent) max(XExtent)], [0 0.9*Max(2)]);
%     pause(3);
