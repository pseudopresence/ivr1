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
%medImg =  median(ImgData(:,:,:,[5 4 3]), 4);


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



for k = 5:10:75
    Img = ImgData(:,:,:,k);
    NImg = Img;
    NImg = normalize_rgb(Img);
    %AdtImg = zeros(size(NImg));
    str = strel(ones(3,3));
    %for i = 1:3
        % AdtImg(:,:,i) = imclose(imopen(adapt(Img(:,:,i), 45, 0.3), str), str);
        % AdtImg(:,:,i) = adapt(NImg(:,:,i), 45, 0.05);
    %end
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

    HistR = processHist(ImgR, edges, 50, 5);
    HistG = processHist(ImgG, edges, 50, 5);
    HistB = processHist(ImgB, edges, 50, 5);
    %figure(1);
    %subplot(2,3,3);
    %imshow(NNImg);
    %xlabel('value');
    %subplot(3,3,4:6);
    %plot(edges, HistR, 'r', edges, HistG, 'g', edges, HistB, 'b');
   % axis([-1.0, 1.0, 0, 1.1*max(HistR)]);

    str = strel(ones(3,3));
    TImgR = imopen(bitand((ImgR >= 0.5), (ImgR <= 1.0)), str);
    TImgG = imopen(bitand((ImgG >= 0.5), (ImgG <= 1.0)), str);
    TImgB = imopen(bitand((ImgB >= 0.5), (ImgB <= 1.0)), str);
    
    %To determine the center of mass of the objects
    %***********************************
    
    centerMass = calcCenterMass(TImgR, TImgG, TImgB);
    
    %**********************************
    %Calculate the moments for each of the images
    propertiesVecR = getproperties(TImgR)
    propertiesVecG = getproperties(TImgG)
    propertiesVecB = getproperties(TImgB)
   
    
    %******************************************************
    %Calculate and display the bounding box for the image

    [verticesXR, verticesYR, centroidR] = calcBoundingBox(TImgR);
    [verticesXG, verticesYG, centroidG] = calcBoundingBox(TImgG);
    [verticesXB, verticesYB, centroidB] = calcBoundingBox(TImgB);
    
    
    centrRX = centroidR(1)
    centrRY = centroidR(2)
    %******************************************************
    %Calculate the orientation for each robot
    [centerMassXR,centerMassYR] = calcBoundingBoxCM(verticesXR, verticesYR, TImgR)
    [centerMassXG,centerMassYG] = calcBoundingBoxCM(verticesXG, verticesYG, TImgG)
    [centerMassXB,centerMassYB] = calcBoundingBoxCM(verticesXB, verticesYB, TImgB)
    
    %Track the location of each image.Calculate the image center of mass
    
    
    %%subplot(3,3,1:6);
    %%imshow(NNImg);
   % xlabel(int2str(k));
   
   
   %************************************************
   %To link the points on the estimated background image
   xLinkerR = [xLinkerR centerMass(1,2)];
   yLinkerR = [yLinkerR centerMass(1,1)];
   xLinkerG = [xLinkerG centerMass(2,2)];
   yLinkerG = [yLinkerG centerMass(2,1)];
   xLinkerB = [xLinkerB centerMass(3,2)];
   yLinkerB = [yLinkerB centerMass(3,1)];
   %Plot of the original image
    size(Img)
%    EImg = edge(Img(:,:,:,k));
%       size(EImg)
%    subplot(2,3,1)
%    imshow(EImg);
   
   
   %Plot of the background image 
    subplot(2,3,2);
    imshow(medImg);
    hold on
    plot(xLinkerR, yLinkerR, 'xr-', xLinkerG, yLinkerG, 'xg-', xLinkerB, yLinkerB, 'xb-');
    
    %Plotting the Binary images
    subplot(2,3,4);
    imshow(TImgR);
    hold on
    plot(verticesXR, verticesYR, 'r-', 'LineWidth', 2);
    hold on
    plot([centerMassXR,centroidR(1)], [centerMassYR, centroidR(2)],'b-', 'LineWidth',2);
    xlabel('red');
    subplot(2,3,5);
    imshow(TImgG);
    hold on
    plot(verticesXG, verticesYG, 'g-', 'LineWidth', 2);
    hold on
    plot([centerMassXG,centroidG(1)-50], [centerMassYG, centroidG(2)-50],'b-', 'LineWidth',2);
    xlabel('green');
    subplot(2,3,6);
    imshow(TImgB);
    hold on
    plot(verticesXB, verticesYB, 'b-', 'LineWidth', 2);
    hold on
    plot([centerMassXB,centroidB(1)-50], [centerMassYB, centroidB(2)-50],'b-', 'LineWidth',2);
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


