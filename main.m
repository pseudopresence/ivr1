clear all

ImgData = myreadfolder('data1/',80);

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

    %Find the edges of each image
    size(TImgR(:,:,1));
    %TImgR = edge(TImgR(:,:));
    %TImgG = edge(TImgG(:,:));
    %TImgB = edge(TImgB(:,:));
    
    %***********************************
    %Calculate the area of the object in the binary image for each channel
    [rows,cols,valsR] = find(TImgR==1);
    imageAreaR = sum(valsR);
    [rows,cols,valsG] = find(TImgG==1);
    imageAreaG = sum(valsG);
    [rows,cols,valsB] = find(TImgB==1);
    imageAreaB = sum(valsB);
    
    %Calculate the center of mass for image
    centerMass=zeros(3,2);
    for r=1:size(NNImg,1)
        for c=1:size(NNImg,2)
           centerMass(1,1) = centerMass(1,1)+r*TImgR(r,c);
           centerMass(1,2) = centerMass(1,2)+c*TImgR(r,c);
           centerMass(2,1) = centerMass(2,1)+r*TImgG(r,c);
           centerMass(2,2) = centerMass(2,2)+c*TImgG(r,c);
           centerMass(3,1) = centerMass(3,1)+r*TImgB(r,c);
           centerMass(3,2) =  centerMass(3,2)+c*TImgB(r,c);
        end
    end
    rcenterR = centerMass(1,1)/imageAreaR;
    ccenterR = centerMass(1,2)/imageAreaR;
    
    rcenterG = centerMass(2,1)/imageAreaG;
    ccenterG = centerMass(2,2)/imageAreaG;
    
    rcenterB = centerMass(3,1)/imageAreaB;
    ccenterB = centerMass(3,2)/imageAreaB;
    
    %**********************************
    %Calculate the moments for each of the images
    propertiesVecR = getproperties(TImgR);
    propertiesVecG = getproperties(TImgG);
    propertiesVecB = getproperties(TImgB);
   
    
    
    %Calculate and display the counding box for the image
    
    %RED CHANNEL  
    %Label the image
    labelR = mybwlabel(TImgR);
    %Then extract the various properties from the image
    propsR = regionprops(labelR, ['basic']);
    %Look at the image bounding box
    boundingBoxR = cat(1,propsR.BoundingBox);
    
    
    size(labelR);
    labelRCount = 0;
    for i=1:size(labelR,1)
        for j=1:size(labelR,2)
           if(labelR(i,j)==0)
               
           else
              labelRCount = labelRCount+1; 
           end
        end
    end
%     [rows,cols,vals] = find(labelR==1);
%     imageAreaR2 = sum(vals);
    %******************************************************
       
    
    %Track the location of each image.Calculate the image center of mass
    
    
    %%subplot(3,3,1:6);
    %%imshow(NNImg);
   % xlabel(int2str(k));
   %************************************************
   %To link the points on the estimated background image
   xLinkerR = [xLinkerR ccenterR]
   yLinkerR = [yLinkerR rcenterR]
   xLinkerG = [xLinkerG ccenterG]
   yLinkerG = [yLinkerG rcenterG]
   xLinkerB = [xLinkerB ccenterB]
   yLinkerB = [yLinkerB rcenterB]
   %Plot of the background image 
    subplot(2,3,2);
    imshow(medImg);
    hold on
    plot(xLinkerR, yLinkerR, 'xr-', xLinkerG, yLinkerG, 'xg-', xLinkerB, yLinkerB, 'xb-');
    
    subplot(2,3,4);
    imshow(TImgR);
    hold on
    plot(xLinkerR, yLinkerR,'xr-' )
    xlabel('red');
    subplot(2,3,5);
    imshow(TImgG);
    hold on
    plot(ccenterG, rcenterG,'og' )
    xlabel('green');
    subplot(2,3,6);
    imshow(TImgB);
    hold on
    plot(ccenterB, rcenterB,'ob' )
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


