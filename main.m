clc
clear all
clc


ImgData = myreadfolder('data2/', 60);

medImg =  median(ImgData(:,:,:,[5 55 60]), 4);

%****************************************************
%The variables used to link the objects movement
xLinkerR = [];
yLinkerR=[];
xLinkerG = [];
yLinkerG=[];
xLinkerB = [];
yLinkerB=[];

for k = 5:5:60
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

    
%     imshow(NNImg);
%     plot(CR(2),CR(1),'o');
%     rectangle('Position', [CR(2) - BBSize/2, CR(1) - BBSize/2, BBSize, BBSize]);
%     plot(CG(2),CG(1),'o');
%     rectangle('Position', [CG(2) - BBSize/2, CG(1) - BBSize/2, BBSize, BBSize]);
%     plot(CB(2),CB(1),'o');
%     rectangle('Position', [CB(2) - BBSize/2, CB(1) - BBSize/2, BBSize, BBSize]);
%     hold off;
    xlabel(int2str(k));
    
    TImgR = cliprect(ImgR, CR, BBSize)>ThreshR;
    TImgG = cliprect(ImgG, CG, BBSize)>ThreshG;
    TImgB = cliprect(ImgB, CB, BBSize)>ThreshB;
    
    %To determine the center of mass of the objects
    %***********************************
    
    centerMass = calcCenterMass(TImgR, TImgG, TImgB);
   
    
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
    
   %************************************************
   %To link the points on the estimated background image
   xLinkerR = [xLinkerR (centerMass(1,2) + CR(2) - BBSize/2)];
   yLinkerR = [yLinkerR (centerMass(1,1) + CR(1) - BBSize/2)];
   xLinkerG = [xLinkerG (centerMass(2,2) + CG(2) - BBSize/2)];
   yLinkerG = [yLinkerG (centerMass(2,1) + CG(1) - BBSize/2)];
   xLinkerB = [xLinkerB (centerMass(3,2) + CB(2) - BBSize/2)];
   yLinkerB = [yLinkerB (centerMass(3,1) + CB(1) - BBSize/2)];
   
   %Define unit vectors in the direction of the centroid
   centerMassR = [centerMassXR centerMassYR];
   dR = (centroidR - centerMassR);
   
   centerMassG = [centerMassXG centerMassYG];
   dG = (centroidG - centerMassG);
   
   centerMassB = [centerMassXB centerMassYB];
   dB = (centroidB - centerMassB);
   
   %The unit vectors for each channel
   dR = dR/norm(dR);
   dG = dG/norm(dG);
   dB = dB/norm(dB);
   
    subplot(3,3,1:6);
    imshow(NNImg);
    hold on
    plot(xLinkerR, yLinkerR, 'xr-', xLinkerG, yLinkerG, 'xg-', xLinkerB, yLinkerB, 'xb-');
    xlabel(k);
        
    subplot(3,3,7);
    hold on;
    imshow(TImgR);
    plot(verticesXR, verticesYR, 'r-', 'LineWidth', 2);
    hold on
    plot([centerMassR(1),centroidR(1)+30*dR(1)], [centerMassR(2), centroidR(2)+30*dR(2)],'b-', 'LineWidth',2);
    xlabel('red');
    
    subplot(3,3,8);
    hold on;
    imshow(TImgG);
    hold on
    plot(verticesXG, verticesYG, 'g-', 'LineWidth', 2);
    hold on
    plot([centerMassG(1),centroidG(1)+30*dG(1)], [centerMassG(2), centroidG(2)+30*dG(2)],'b-', 'LineWidth',2);
    xlabel('green');
    
    subplot(3,3,9);
    hold on;
    imshow(TImgB);
    hold on
    plot(verticesXB, verticesYB, 'b-', 'LineWidth', 2);
    hold on
    plot([centerMassB(1),centroidB(1)+30*dB(1)], [centerMassB(2), centroidB(2)+30*dB(2)],'b-', 'LineWidth',2);
    xlabel('blue');
    
    pause(0.1);
end
