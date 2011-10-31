clc
clear all
clc
%****************************************************
%The variables used to link the objects movement
xLinkerR = [];
yLinkerR=[];
xLinkerG = [];
yLinkerG=[];
xLinkerB = [];
yLinkerB=[];

ImgData = myreadfolder('data1s2/',50);

medianIdx = [5 45 50];
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
    [CR, ThreshR, XHist, YHist] = xyhistmax(ImgR);
    [CG, ThreshG, XHist, YHist] = xyhistmax(ImgG);
    [CB, ThreshB, XHist, YHist] = xyhistmax(ImgB);
    
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
clf;


%****************************************************
%The variables used to link the objects movement
xLinkerR = [];
yLinkerR = [];
xLinkerG = [];
yLinkerG = [];
xLinkerB = [];
yLinkerB = [];

for k = 1:5:50
    %Create a Gaussian smoothing filter
    filter = fspecial('gaussian', [5 5], 5);
    
    %Store the kth image in the variable Img
    Img = ImgData(:,:,:,k);
    %Filter the image with the Gaussian smoothing filer
    FImg = imfilter(Img, filter, 'symmetric', 'conv');

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
    
    %Remove the image contained within the bounding box
    %and threshold the image to create a binary image
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
    
    subplot(3,3,1:6);
    imshow(medImg);
    
    if((trueCMXR>70 && trueCMXR<570)...
        && ((trueCMYR>70 && trueCMYR<410)...
        && StateR==1))
    hold on
    plot(xLinkerR, yLinkerR, 'xr-');
    elseif((trueCMXR>70 && trueCMXR<570)...
        && ((trueCMYR>70 && trueCMYR<410)...
        && StateR==0))
    hold on
    plot(xLinkerR, yLinkerR, 'xr-');
    StateR=1;
    elseif((trueCMXR<70 && trueCMXR>570)...
        || (trueCMYR<70 && trueCMYR>410)...
        && StateX==1)
    hold on
    plot(xLinkerR, yLinkerR, 'xr-');
    end
    hold on
    plot(xLinkerG, yLinkerG, 'xg-');
    hold on
    plot(xLinkerB, yLinkerB, 'xb-');
    hold on
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
    plot([centerMassG(1),centroidG(1)+30*dG(1)], [centerMassG(2), centroidG(2)+30*dG(2)],LineColG, 'LineWidth',2);
    xlabel('green');

    subplot(3,3,9);
    hold on;
    imshow(TImgB);
    hold on
    plot(verticesXB, verticesYB, 'b-', 'LineWidth', 2);
    hold on
    plot([centerMassB(1),centroidB(1)+30*dB(1)], [centerMassB(2), centroidB(2)+30*dB(2)],LineColB, 'LineWidth',2);
    xlabel('blue');

%     clf();
%     figure(1);
%     imshow(edge(rgb2gray(FImg)));
%     pause(1);
    %print('-depsc','-tiff','-r300','picture1')
%     filename = sprintf('..\0000%d.jpg', k);
%     imwrite(figure, filename);
    pause(1);
   %input('...');
end
