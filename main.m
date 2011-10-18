clear all

ImgData = myreadfolder('data2/', 100);

% compute the average for each pixel
% average = zeros(size(test_img));
%for m = 3:size(input, 4)
%    average = average + input(:,:,:,m);
%end
%average = average / (size(input, 4) - 2);
%imshow(average);

% compute the median for each pixel
% med =  median(input, 4);
% med =  median(input(:,:,:,60:100), 4);
% med =  median(ImgData(:,:,:,1:10:100), 4);
% imshow(med);

% difference between each image and the median
% for i = 1:100
%     imagesc((ImgData(:,:,:,i) - med)/2 + 0.5);
% end

% adaptive thresholding
for k = 1:100
    Img = ImgData(:,:,:,k);

    NImg = normalize_rgb(Img);
    AdtImg = zeros(size(NImg));
    str = strel(ones(3,3));
    for i = 1:3
        % AdtImg(:,:,i) = imclose(imopen(adapt(Img(:,:,i), 45, 0.3), str), str);
        % AdtImg(:,:,i) = adapt(NImg(:,:,i), 45, 0.05);
    end
    % imshow(AdtImg);


    %Test with a single histogram
    Bins = 1024;
    edges = zeros(Bins,1);
    for i = 1 : Bins;
         edges(i) = ((i-1)/(Bins-1.0)) - 0.5;
    end

    ImgR = NImg(:,:,1);
    ImgG = NImg(:,:,2);
    ImgB = NImg(:,:,3);

    AvgR = mean(reshape(ImgR, 1, numel(ImgR)));
    AvgG = mean(reshape(ImgG, 1, numel(ImgG)));
    AvgB = mean(reshape(ImgB, 1, numel(ImgB)));

    ImgR = ImgR - AvgR;
    ImgG = ImgG - AvgG;
    ImgB = ImgB - AvgB;

    ImgG = ImgG - 0.5 * ImgB;

    StdR = std(reshape(ImgR, 1, numel(ImgR)));
    StdG = std(reshape(ImgG, 1, numel(ImgG)));
    StdB = std(reshape(ImgB, 1, numel(ImgB)));

    ImgR = 0.1 * ImgR / StdR;
    ImgG = 0.1 * ImgG / StdG;
    ImgB = 0.1 * ImgB / StdB;

    NNImg = NImg;
    NNImg(:,:,1) = ImgR;
    NNImg(:,:,2) = ImgG;
    NNImg(:,:,3) = ImgB;

    % NNImg = windowmedian(NNImg, 8);
    % 
    % ImgR = NNImg(:,:,1);
    % ImgG = NNImg(:,:,2);
    % ImgB = NNImg(:,:,3);

    % HistR = processHist(ImgR, edges, 50, 5);
    % HistG = processHist(ImgG, edges, 50, 5);
    % HistB = processHist(ImgB, edges, 50, 5);
    % figure(1);
    % subplot(3,3,1:3);
    % imshow(NNImg * 3.0);
    % xlabel('value');
    % subplot(3,3,4:6);
    % plot(edges, HistR, 'r', edges, HistG, 'g', edges, HistB, 'b');
    % axis([-1.0, 1.0, 0, 1.1*max(HistR)]);

    str = strel(ones(3,3));
    TImgR = imopen(bitand((ImgR >= 0.5), (ImgR <= 1.0)), str);
    TImgG = imopen(bitand((ImgG >= 0.5), (ImgG <= 1.0)), str);
    TImgB = imopen(bitand((ImgB >= 0.5), (ImgB <= 1.0)), str);

    subplot(3,3,1:6);
    imshow(NNImg);
    xlabel(int2str(k));
    subplot(3,3,7);
    imshow(TImgR);
    xlabel('red');
    subplot(3,3,8);
    imshow(TImgG);
    xlabel('green');
    subplot(3,3,9);
    imshow(TImgB);
    xlabel('blue');
    pause(0.1);
end
%thresholdR = findthresh(HistR, 5/255, 4);
% filter = fspecial('gaussian', [50 1], 6);
% filter = filter/sum(filter);  % this normalises the filter
% edges = zeros(256,1);
% for i = 1 : 256;
%     edges(i) = (i-1)/255.0;
% end
  
% for i = 1:100
%     NrmImg = normalize_rgb(ImgData(:,:,:,i));
% %     HistR = dohist(NrmImg(:,:,1), 0, edges);
% %     HistG = dohist(NrmImg(:,:,2), 0, edges);
% %     HistB = dohist(NrmImg(:,:,3), 0, edges);
% %     SmoothHistR = conv(filter,HistR);
% %     SmoothHistG = conv(filter,HistG);
% %     SmoothHistB = conv(filter,HistB);
% %     TImg = NrmImg;
% %     for j = 1:3
% %         TImg(:,:,j) = (NrmImg(:,:,j) > 0.45);
% %     end
%     
%     clf
%     
% %     subplot(2,1,1);
% %     imshow(TImg);
% %     subplot(2,1,2);
% %     plot(edges, HistR, 'r', edges, HistG, 'g', edges, HistB, 'b');
% %     axis([0, 1, 0, 1.1*max(HistR)]);
%     
%     pause(0.1);
% end
% 


