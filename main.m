clc
clear all
clc


ImgData = myreadfolder('data8/', 100);

medianIdx = [5 75 100];
medianImgs = [];

oldDirR = [0 0];
oldDirG = [0 0];
oldDirB = [0 0];

for mki = 1:size(medianIdx,2)
    mk = medianIdx(mki);
    filter = fspecial('gaussian', [5 5], 5);
    
    Img = ImgData(:,:,:,mk);
    FImg = imfilter(Img, filter, 'symmetric', 'conv');

    NImg = normalize_rgb(FImg);
    
    ImgR = NImg(:,:,1);
    ImgG = NImg(:,:,2);
    ImgB = NImg(:,:,3);

    ImgG = ImgG - 0.2 * ImgB;
    
    ImgR = normchannel(ImgR);
    ImgG = normchannel(ImgG);
    ImgB = normchannel(ImgB);
       
    BBSize = 120;
    
    % Marginal Histogram along X-axis, Y-axis
    [CR, ThreshR] = xyhistmax(ImgR);
    [CG, ThreshG] = xyhistmax(ImgG);
    [CB, ThreshB] = xyhistmax(ImgB);
    
    Img = eraseRegion(Img, CR, BBSize);
    Img = eraseRegion(Img, CG, BBSize);
    Img = eraseRegion(Img, CB, BBSize);
    medianImgs(:,:,:,mki) = Img;
%     clf();
%     figure(1);
%     imshow(Img);
%     xlabel(mk);
%     pause(1);
end

medImg =  median(medianImgs, 4);
% medImg = windowmedian(medImg, 10);
            

%****************************************************
%The variables used to link the objects movement
xLinkerR = [];
yLinkerR = [];
xLinkerG = [];
yLinkerG = [];
xLinkerB = [];
yLinkerB = [];

for k = 5:100
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
       
    BBSize = 120;
    
    % Marginal Histogram along X-axis, Y-axis
    [CR, ThreshR] = xyhistmax(ImgR);
    [CG, ThreshG] = xyhistmax(ImgG);
    [CB, ThreshB] = xyhistmax(ImgB);
    
    clf();
%     NNImg = NImg;
%     NNImg(:,:,1) = ImgR;
%     NNImg(:,:,2) = ImgG;
%     NNImg(:,:,3) = ImgB;
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
    
    %******************************************************
    %Calculate the orientation for each robot
    if min(verticesXR) == 0 || min(verticesXG) == 0 || min(verticesXB) == 0
        continue;
    end
    [centerMassXR,centerMassYR] = calcBoundingBoxCM(verticesXR, verticesYR, TImgR);
    [centerMassXG,centerMassYG] = calcBoundingBoxCM(verticesXG, verticesYG, TImgG);
    [centerMassXB,centerMassYB] = calcBoundingBoxCM(verticesXB, verticesYB, TImgB);

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
   
    LineColR = 'b-';
    LineColG = 'b-';
    LineColB = 'b-';
    
    if dot(dR, oldDirR) < 0.5
        LineColR = 'r-';
    end
    if dot(dG, oldDirG) < 0.5
        LineColG = 'r-';
    end
    if dot(dB, oldDirB) < 0.5
        LineColB = 'r-';
    end
    oldDirR = dR;
    oldDirG = dG;
    oldDirB = dB;
    
    subplot(3,3,1:6);
    imshow(medImg);
    hold on
    plot(xLinkerR, yLinkerR, 'xr-', xLinkerG, yLinkerG, 'xg-', xLinkerB, yLinkerB, 'xb-');
    xlabel(k);

    subplot(3,3,7);
    hold on;
    imshow(TImgR);
    plot(verticesXR, verticesYR, 'r-', 'LineWidth', 2);
    hold on
    plot([centerMassR(1),centroidR(1)+30*dR(1)], [centerMassR(2), centroidR(2)+30*dR(2)], LineColR, 'LineWidth',2);
    xlabel('red');

    subplot(3,3,8);
    hold on;
    imshow(TImgG);
    hold on
    plot(verticesXG, verticesYG, 'g-', 'LineWidth', 2);
    hold on
    plot([centerMassG(1),centroidG(1)+30*dG(1)], [centerMassG(2), centroidG(2)+30*dG(2)], LineColG, 'LineWidth',2);
    xlabel('green');

    subplot(3,3,9);
    hold on;
    imshow(TImgB);
    hold on
    plot(verticesXB, verticesYB, 'b-', 'LineWidth', 2);
    hold on
    plot([centerMassB(1),centroidB(1)+30*dB(1)], [centerMassB(2), centroidB(2)+30*dB(2)], LineColB, 'LineWidth',2);
    xlabel('blue');

%     clf();
%     figure(1);
%     imshow(edge(rgb2gray(FImg)));
%     pause(1);

    pause(0.1);
end
