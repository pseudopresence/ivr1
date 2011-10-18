function [OutHist] = convhist(thehist, filterlen, sizeparam)
    [len,x] = size(thehist);    
    % convolve with a gaussian smoothing window here
    thefilter = mygausswin(filterlen,sizeparam);
    thefilter = thefilter/sum(thefilter);                  % normalize
    tmp2=conv(thefilter,thehist);               
    OutHist=tmp2(1+filterlen/2:len+filterlen/2);     % select corresponding portion
