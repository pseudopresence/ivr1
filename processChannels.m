function [ImgR, ImgG, ImgB] = processChannels(Img, FilterSize, FilterWidth)
    

    % Blur the image
    FImg = myimgblur(Img, FilterSize, FilterWidth);
    
    % Normalise the image
    NImg = normalize_rgb(FImg);
    
    % Split the image into its three colour channels
    ImgR = NImg(:,:,1);
    ImgG = NImg(:,:,2);
    ImgB = NImg(:,:,3);

    % Subtract the blue channel from the green channel
    % to remove some of the excess blue in the green channel
    ImgG = ImgG - 0.2 * ImgB;
   
    % Renormalise each channel
    ImgR = normchannel(ImgR);
    ImgG = normchannel(ImgG);
    ImgB = normchannel(ImgB);