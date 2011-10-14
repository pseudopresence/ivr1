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
Img = ImgData(:,:,:,5);
NImg = normalize_rgb(Img);
AdtImg = zeros(size(NImg));
str = strel(ones(3,3));
for i = 1:3
    % AdtImg(:,:,i) = imclose(imopen(adapt(Img(:,:,i), 45, 0.3), str), str);
    % AdtImg(:,:,i) = adapt(NImg(:,:,i), 45, 0.05);
end
% imshow(AdtImg);
imshow(NImg);

%Test with a single histogram
edges = zeros(256,1);
for i = 1 : 256;
     edges(i) = (i-1)/255.0;
end
HistR = dohist(NImg(:,:,1), 0, edges);

thresholdR = findthresh(HistR, 5/255, 4);
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

