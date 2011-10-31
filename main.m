clear all;
clc;

global HaveToolbox;
HaveToolbox = 0; % TODO - explicitly request Image Toolbox license and fall back

ImgData = myreadfolder('data2/', 80);

medianIdx = [5 75 80];
medianImgs = [];

oldDirR = [0 0];
oldDirG = [0 0];
oldDirB = [0 0];

for mki = 1:size(medianIdx,2)
    mk = medianIdx(mki);
        
    Img = ImgData(:,:,:,mk);
    
    FImg = myimgblur(Img, 5, 5);

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
    [CR, ThreshR, XHist, YHist] = xyhistmax(ImgR);
    [CG, ThreshG, XHist, YHist] = xyhistmax(ImgG);
    [CB, ThreshB, XHist, YHist] = xyhistmax(ImgB);
    
    Img = eraseRegion(Img, CR, BBSize);
    Img = eraseRegion(Img, CG, BBSize);
    Img = eraseRegion(Img, CB, BBSize);
    medianImgs(:,:,:,mki) = Img;
end

medImg =  median(medianImgs, 4);
% medImg = windowmedian(medImg, 10);
clf;


%****************************************************
%The variables used to link the objects movement
xLinkerR = [];
yLinkerR = [];
xLinkerG = [];
yLinkerG = [];
xLinkerB = [];
yLinkerB = [];

for k = 5:80
    Img = ImgData(:,:,:,k);
    
    FImg = myimgblur(Img, 5, 5);

    %Normalise the image
    NImg = normalize_rgb(FImg);
    
    %Split the image into its three colour channels
    ImgR = NImg(:,:,1);
    ImgG = NImg(:,:,2);
    ImgB = NImg(:,:,3);

    %Subtract the blue channel from the green channel
    %to remove some of the excess blue in the green channel
    ImgG = ImgG - 0.2 * ImgB;
   
    %Renormalise each channel
    ImgR = normchannel(ImgR);
    ImgG = normchannel(ImgG);
    ImgB = normchannel(ImgB);
       
    %Create the bounding box dimensions of 120x120
    BBSize = 120;
    
    % Marginal Histogram along X-axis, Y-axis
    [CR, ThreshR, XHistR, YHistR] = xyhistmax(ImgR);
    [CG, ThreshG, XHistG, YHistG] = xyhistmax(ImgG);
    [CB, ThreshB, XHistB, YHistB] = xyhistmax(ImgB);
    
   
    TImgR = cliprect(ImgR, CR, BBSize)>ThreshR;
    TImgG = cliprect(ImgG, CG, BBSize)>ThreshG;
    TImgB = cliprect(ImgB, CB, BBSize)>ThreshB;
    
    %Calculating the bounding box for the thresholded image
    %To determine the center of mass of the objects
    %***********************************
    
    centerMass = calcCenterMass(TImgR, TImgG, TImgB);
   
    
    %******************************************************
    %Calculate and display the bounding box for the image   
    [verticesXR, verticesYR, centroidR, falseImageR] = calcBoundingBox(TImgR);
    [verticesXG, verticesYG, centroidG, falseImageG] = calcBoundingBox(TImgG);
    [verticesXB, verticesYB, centroidB, falseImageB] = calcBoundingBox(TImgB);
    
    %******************************************************
    %Calculate the orientation for each robot
    if min(verticesXR) == 0 || min(verticesXG) == 0 || min(verticesXB) == 0
        continue;
    end
    
    if(falseImageR==0)
    [centerMassXR,centerMassYR] = calcBoundingBoxCM(verticesXR, verticesYR, TImgR);
    elseif(falseImageR==1)
    centerMassXR = previousCMXR;
    centerMassYR = previousCMYR;
    end
    if(falseImageG==0)
    [centerMassXG,centerMassYG] = calcBoundingBoxCM(verticesXG, verticesYG, TImgG);
    elseif(falseImageG==1)
    centerMassXG = previousCMXG;
    centerMassYG = previousCMYG;
    end
    if(falseImageB==0)
    [centerMassXB,centerMassYB] = calcBoundingBoxCM(verticesXB, verticesYB, TImgB);
    elseif(falseImageB==1)
    centerMassXB = previousCMXB;
    centerMassYB = previousCMYB;
    end
    
    %Add variables for the true center of mass
    trueCMXR = (centerMassXR + CR(2) - BBSize/2);
    trueCMYR = (centerMassYR + CR(1) - BBSize/2);
    trueCMXG = (centerMassXG + CG(2) - BBSize/2);
    trueCMYG = (centerMassYG + CG(1) - BBSize/2);
    trueCMXB = (centerMassXB + CB(2) - BBSize/2);
    trueCMYB = (centerMassYB + CB(1) - BBSize/2);
    %Store the previous Center of mass of the objects
    %for plotting purposes
    
    %************************************************
    %To link the points on the estimated background image
    xLinkerR = [xLinkerR trueCMXR];
    yLinkerR = [yLinkerR trueCMYR];
    xLinkerG = [xLinkerG trueCMXG];
    yLinkerG = [yLinkerG trueCMYG];
    xLinkerB = [xLinkerB trueCMXB];
    yLinkerB = [yLinkerB trueCMYB];
    
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
    
    figure(1);
    clf();
    
    subplot(3,3,1:6);
    %imshow(medImg);
    imshow(FImg);
    hold on;
    plot(xLinkerR, yLinkerR, 'xr-', xLinkerG, yLinkerG, 'xg-', xLinkerB, yLinkerB, 'xb-');
    xlabel(k);

    subplot(3,3,7);
    hold on;
    imshow(TImgR);
    plot(verticesXR, verticesYR, 'r-', 'LineWidth', 2);
    plot([centerMassR(1),centroidR(1)+30*dR(1)], [centerMassR(2), centroidR(2)+30*dR(2)], LineColR, 'LineWidth',2);
    xlabel('red');

    subplot(3,3,8);
    hold on;
    imshow(TImgG);
    plot(verticesXG, verticesYG, 'g-', 'LineWidth', 2);
    plot([centerMassG(1),centroidG(1)+30*dG(1)], [centerMassG(2), centroidG(2)+30*dG(2)], LineColG, 'LineWidth',2);
    xlabel('green');

    subplot(3,3,9);
    hold on;
    imshow(TImgB);
    plot(verticesXB, verticesYB, 'b-', 'LineWidth', 2);
    plot([centerMassB(1),centroidB(1)+30*dB(1)], [centerMassB(2), centroidB(2)+30*dB(2)], LineColB, 'LineWidth',2);
    xlabel('blue');

    pause(0.1);
end
