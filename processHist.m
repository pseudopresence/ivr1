function [Hist] = processHist(Img, edges, filterlen, sizeparam)
    Hist = dohist(Img, 0, edges);    
    % Hist = Hist .* max(abs(edges), 0.0);
    Hist = log(Hist + 1);
    Hist = convhist(Hist, filterlen, sizeparam);
    