function [Out] = normchannel(Img)
    Pixels = reshape(Img, 1, numel(Img));
    %Avg = mean(Pixels);
    %Std = std(Pixels);
    %Out = 0.1 * (Img - Avg) / Std;
    Max = max(Pixels);
    Min = min(Pixels);
    Out = (Img - Min) / (Max - Min);