function centerMassOut = calcCenterMass(TImgR, TImgG, TImgB)

%Calculate the area of the object in the binary image for each channel
    [rows,cols,valsR] = find(TImgR==1);
    imageAreaR = sum(valsR);
    [rows,cols,valsG] = find(TImgG==1);
    imageAreaG = sum(valsG);
    [rows,cols,valsB] = find(TImgB==1);
    imageAreaB = sum(valsB);
    
    %Calculate the center of mass for image
    centerMass=zeros(3,2);
    for r=1:size(TImgR,1)
        for c=1:size(TImgR,2)
           centerMass(1,1) = centerMass(1,1)+r*TImgR(r,c);
           centerMass(1,2) = centerMass(1,2)+c*TImgR(r,c);
           centerMass(2,1) = centerMass(2,1)+r*TImgG(r,c);
           centerMass(2,2) = centerMass(2,2)+c*TImgG(r,c);
           centerMass(3,1) = centerMass(3,1)+r*TImgB(r,c);
           centerMass(3,2) =  centerMass(3,2)+c*TImgB(r,c);
        end
    end
    
    %Center of Mass output
    centerMassOut = zeros(3,2);
    %rcenterR
    centerMassOut(1,1)= centerMass(1,1)/imageAreaR;
    %ccenterR
    centerMassOut(1,2)= centerMass(1,2)/imageAreaR;
    
    %rcenterG 
    centerMassOut(2,1)= centerMass(2,1)/imageAreaG;
    %ccenterG
    centerMassOut(2,2)= centerMass(2,2)/imageAreaG;
    
    %rcenterB
    centerMassOut(3,1)= centerMass(3,1)/imageAreaB;
    %ccenterB
    centerMassOut(3,2)= centerMass(3,2)/imageAreaB;