clc
clear all

ImgData = myreadfolder('data2/',80);

% compute the average for each pixel
% average = zeros(size(test_img));
%for m = 3:size(input, 4)
%    average = average + input(:,:,:,m);
%end
%average = average / (size(input, 4) - 2);
%imshow(average);
X = [0 1 2 3 4 5]
% compute the median for each pixel
%med =  median(input, 4);
%med =  median(input(:,:,:,60:100), 4);
medImg =  median(ImgData(:,:,:,[5 70 80]), 4);


%****************************************************

%****************************************************
%The variables used to link the objects movement
xLinkerR = [];
yLinkerR=[];
xLinkerG = [];
yLinkerG=[];
xLinkerB = [];
yLinkerB=[];


% difference between each image and the median
% for i = 1:100
%     imagesc((ImgData(:,:,:,i) - med)/2 + 0.5);
% end

% adaptive thresholding
for k = 5:5
    filter = fspecial('gaussian', [10 10], 5);
    
    Img = ImgData(:,:,:,k);
    Img = imfilter(Img, filter, 'symmetric', 'conv');
    NImg = Img;
    NImg = normalize_rgb(Img);
    %AdtImg = zeros(size(NImg));
    str = strel(ones(3,3));
    %for i = 1:3
        % AdtImg(:,:,i) = imclose(imopen(adapt(Img(:,:,i), 45, 0.3), str), str);
        % AdtImg(:,:,i) = adapt(NImg(:,:,i), 45, 0.05);
    %end
    % imshow(AdtImg);

    % NImg = windowmedian(NImg, 8);
    
    ImgR = NImg(:,:,1);
    ImgG = NImg(:,:,2);
    ImgB = NImg(:,:,3);

    ImgG = ImgG - 0.7 * ImgB;
    
    ImgR = normchannel(ImgR);
    ImgG = normchannel(ImgG);
    ImgB = normchannel(ImgB);
    
    % Centre of mass along each channel
%     CR = [0 0];
%     SR = 0
%     for y = 1:size(ImgR, 1)
%         for x = 1:size(ImgR, 2)
%             V = exp(10 * ImgR(y, x) - 1);
%             CR = CR + [y x] .* V;
%             SR = SR + V;
%         end
%     end
%     CR = CR ./ SR

    
%     ImgR2 = max(max(ImgR, -ImgG), -ImgB);
%     ImgG2 = max(max(-ImgR, ImgG), -ImgB);
%     ImgB2 = max(max(-ImgR, -ImgG), ImgB);
%     
%     ImgR = ImgR2;
%     ImgG = ImgG2;
%     ImgB = ImgB2;
    
    NNImg = NImg;
    NNImg(:,:,1) = ImgR;
    NNImg(:,:,2) = ImgG;
    NNImg(:,:,3) = ImgB;

    
    
    % 
    % ImgR = NNImg(:,:,1);
    % ImgG = NNImg(:,:,2);
    % ImgB = NNImg(:,:,3);


    % Marginal Histogram along X-axis, Y-axis
    CR = xyhistmax(ImgR);
    CG = xyhistmax(ImgG);
    CB = xyhistmax(ImgB);
    
    %Test with a single histogram
    Bins = 1024;
    edges = zeros(Bins,1);
    for i = 1 : Bins;
         edges(i) = ((i-1)/(Bins-1.0)) - 0.5;
    end
    
    HistR = processHist(ImgR, edges, 200, 5);
    HistG = processHist(ImgG, edges, 200, 5);
    HistB = processHist(ImgB, edges, 200, 5);
    
    % thresholdR = findthresh(HistR/255);
    
    % figure(1);
    % subplot(3,3,1:3);
    % imshow(NNImg * 3.0);
    % xlabel('value');
    % subplot(3,3,4:6);
    % plot(edges, HistR, 'r', edges, HistG, 'g', edges, HistB, 'b');
    % axis([-1.0, 1.0, 0, 1.1*max(HistR)]);


    str = strel(ones(3,3));
    TImgR = imopen(bitand((ImgR >= 0.3), (ImgR <= 1.0)), str);
    TImgG = imopen(bitand((ImgG >= 0.3), (ImgG <= 1.0)), str);
    TImgB = imopen(bitand((ImgB >= 0.3), (ImgB <= 1.0)), str);
    
    subplot(3,3,1:6);
    %imshow(edge(NNImg(:,:,1)));
    %imshow(0.5 * NNImg + 0.5);
    imshow(NNImg);
    xlabel(int2str(k));
    
    %subplot(3,3,4:6);
    %plot(edges, HistR, 'r', edges, HistG, 'g', edges, HistB, 'b');
    %axis([-1.0, 1.0, 0, 1.1*max(HistR)]);
    %plot(XHistR);
    % axis([0, 640, 0, 1.0]);
    
    subplot(3,3,7);
    imshow(TImgR);
    hold on;
    plot(CR(2),CR(1),'o');
    hold off;
    xlabel('red');
    
    subplot(3,3,8);
    imshow(TImgG);
    hold on
    xlabel('green');
    plot(CG(2),CG(1),'o');
    hold off;
    
    subplot(3,3,9);
    imshow(TImgB);
    hold on
    xlabel('blue');
    hold on;
    plot(CB(2),CB(1),'o');
    hold off;
    
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


