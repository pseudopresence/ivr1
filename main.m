clear all
clc

ImgData = myreadfolder('data9/', 100);

for k = 1:100
    filter = fspecial('gaussian', [5 5], 5);
    
    Img = ImgData(:,:,:,k);
    FImg = imfilter(Img, filter, 'symmetric', 'conv');

    NImg = normalize_rgb(FImg);
    
    ImgR = NImg(:,:,1);
    ImgG = NImg(:,:,2);
    ImgB = NImg(:,:,3);

    ImgG = ImgG - 0.2 * ImgB;
    
    ImgR = normchannel(ImgR);
    ImgG = normchannel(ImgG);
    ImgB = normchannel(ImgB);
        
    NNImg = NImg;
    NNImg(:,:,1) = ImgR;
    NNImg(:,:,2) = ImgG;
    NNImg(:,:,3) = ImgB;

    % Marginal Histogram along X-axis, Y-axis
    [CR, ThreshR] = xyhistmax(ImgR);
    [CG, ThreshG] = xyhistmax(ImgG);
    [CB, ThreshB] = xyhistmax(ImgB);
    
    clf();

    BBSize = 120;

    subplot(3,3,1:6);
    hold on;
    imshow(NNImg);
    plot(CR(2),CR(1),'o');
    rectangle('Position', [CR(2) - BBSize/2, CR(1) - BBSize/2, BBSize, BBSize]);
    plot(CG(2),CG(1),'o');
    rectangle('Position', [CG(2) - BBSize/2, CG(1) - BBSize/2, BBSize, BBSize]);
    plot(CB(2),CB(1),'o');
    rectangle('Position', [CB(2) - BBSize/2, CB(1) - BBSize/2, BBSize, BBSize]);
    hold off;
    xlabel(int2str(k));
    
    TImgR = cliprect(ImgR, CR, BBSize);
    TImgG = cliprect(ImgG, CG, BBSize);
    TImgB = cliprect(ImgB, CB, BBSize);
        
    subplot(3,3,7);
    hold on;
    imshow(TImgR > ThreshR);
    hold off;
    xlabel('red');
    
    subplot(3,3,8);
    hold on;
    imshow(TImgG > ThreshG);
    hold off;
    xlabel('green');
    
    subplot(3,3,9);
    hold on;
    imshow(TImgB > ThreshB);
    hold off;
    xlabel('blue');
    
    pause(0.1);
end

