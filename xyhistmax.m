function [C] = xyhistmax(Img)
    XHist = max(Img, [], 1)';
    YHist = max(Img, [], 2);
    XHist = convhist(XHist, 20, 7);
    YHist = convhist(YHist, 20, 7);

    C = [0 0];
    C(1) = find(YHist == max(YHist));
    C(2) = find(XHist == max(XHist));
    